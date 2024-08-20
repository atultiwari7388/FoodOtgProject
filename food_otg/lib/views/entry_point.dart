import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/controllers/tab_index_controller.dart';
import 'package:food_otg/services/app_services.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:food_otg/views/cart/cart_screen.dart';
import 'package:food_otg/views/history/history_screen.dart';
import 'package:food_otg/views/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../services/collection_refrences.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key});

  Stream<Map<String, dynamic>> getUserDataStream(String userId) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('Users').doc(userId);

    // Check if history collection exists
    bool historyExists =
        await userRef.collection('history').get().then((historySnapshot) {
      return historySnapshot.docs.isNotEmpty;
    });

    if (!historyExists) {
      // Only cart stream if history doesn't exist
      yield* userRef.collection('cart').snapshots().map((cartSnapshot) {
        int cartItemCount = cartSnapshot.docs.length;
        return {
          'cartItemCount': cartItemCount,
          'hasHistory': false,
        };
      });
    } else {
      // Combined stream if history exists
      yield* CombineLatestStream.combine2(
        userRef.collection('cart').snapshots(),
        userRef.collection('history').snapshots(),
        (cartSnapshot, historySnapshot) {
          int cartItemCount = cartSnapshot.docs.length;

          List<DocumentSnapshot> historyDocs = historySnapshot.docs;
          List<DocumentSnapshot> filteredHistoryDocs = historyDocs.where((doc) {
            num status = doc['status'] ?? -1; // Default to -1 if status is null
            return status != 5 && status != -1;
          }).toList();

          bool hasHistory = filteredHistoryDocs.isNotEmpty;

          Map<String, dynamic> data = {
            'cartItemCount': cartItemCount,
            'hasHistory': hasHistory,
          };

          if (hasHistory) {
            DocumentSnapshot nextOrder = filteredHistoryDocs.first;
            data['orderId'] = nextOrder.id;
            data['orderStatus'] =
                nextOrder['status'] ?? -1; // Default to -1 if status is null
          }

          return data;
        },
      );
    }
  }

  List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());

    String userId = currentUId;

    int initialTabIndex = Get.arguments ?? 0;
    controller.setTabIndex = initialTabIndex;

    return StreamBuilder<Map<String, dynamic>>(
      stream: getUserDataStream(userId),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        int cartItemCount = snapshot.data!['cartItemCount'] ?? 0;
        bool hasHistory = snapshot.data!['hasHistory'] ?? false;
        String? orderId = snapshot.data!['orderId'];
        num orderStatus = snapshot.data!['orderStatus'] ?? -1;
        String orderStatusString =
            AppServices().getStatusString(orderStatus.toInt());

        return Obx(
          () => Scaffold(
            body: Stack(
              children: [
                screens[controller.getTabIndex],
                if (hasHistory && controller.getTabIndex != 1)
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.setTabIndex = 1;
                      },
                      child: Container(
                        height: 113.h,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.receipt_long,
                                          color: kSecondary),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Order ID: $orderId",
                                            style: appStyle(
                                                16, kDark, FontWeight.bold),
                                          ),
                                          Text(
                                            "Status: $orderStatusString",
                                            style: appStyle(
                                                14, kRed, FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.setTabIndex = 1;
                                    },
                                    child: Icon(Icons.chevron_right,
                                        color: kSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      BottomNavigationBar(
                        elevation: 0,
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        unselectedIconTheme: const IconThemeData(color: kGray),
                        selectedItemColor: kSecondary,
                        selectedIconTheme:
                            const IconThemeData(color: kSecondary),
                        selectedLabelStyle:
                            appStyle(12, kSecondary, FontWeight.bold),
                        onTap: (value) {
                          controller.setTabIndex = value;
                        },
                        currentIndex: controller.getTabIndex,
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(AntDesign.home),
                            label: "Home",
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(AntDesign.book),
                            label: "History",
                          ),
                          BottomNavigationBarItem(
                            icon: Badge(
                              backgroundColor: kRed,
                              label: Text(cartItemCount.toString()),
                              child: Icon(AntDesign.shoppingcart),
                            ),
                            label: "Cart",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
