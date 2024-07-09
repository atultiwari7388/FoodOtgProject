import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/controllers/tab_index_controller.dart';
import 'package:food_otg/services/collection_refrences.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:food_otg/views/cart/cart_screen.dart';
import 'package:food_otg/views/history/history_screen.dart';
import 'package:food_otg/views/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key});

  Stream<int> getCartItemCountStream(String userId) {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the user's document
    DocumentReference userRef = firestore.collection('Users').doc(userId);

    // Reference to the user's cart subcollection
    CollectionReference cartRef = userRef.collection('cart');

    // Create a stream that listens to changes in the cart subcollection
    return cartRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    CartScreen(),
    // ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());

    // Get the currently logged-in user's UID
    String userId = currentUId; // Replace this with the actual user's UID

    return StreamBuilder(
      stream: getCartItemCountStream(userId),
      builder: (context, AsyncSnapshot<int> snapshot) {
        int cartItemCount = snapshot.data ?? 0;

        return Obx(
          () => Scaffold(
            body: Stack(
              children: [
                screens[controller.getTabIndex],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigationBar(
                    elevation: 0,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    unselectedIconTheme: const IconThemeData(color: kGray),
                    selectedItemColor: kSecondary,
                    selectedIconTheme: const IconThemeData(color: kSecondary),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
