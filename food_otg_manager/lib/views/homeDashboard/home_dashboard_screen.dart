import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager/common/custom_app_bar.dart';
import 'package:food_otg_manager/services/collection_refrences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../utils/app_style.dart';
import '../orderHistory/order_history_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key, required this.setTab});
  final Function? setTab;

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String? restaurantAddress;
  int totalOrders = 0;
  int todaysOrder = 0;
  int pendingOrders = 0;

  Future<void> fetchRestaurantLocation() async {
    try {
      String managerId = currentUId;
      log("Manager ID: $managerId");
      DocumentSnapshot managerSnapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(managerId)
          .get();

      // Extract the restaurant ID from the manager document
      String restaurantId = managerSnapshot.get('resId');
      log("Restaurant ID: $restaurantId");

      // Fetch the restaurant details from the Restaurants collection using the restaurantId
      DocumentSnapshot restaurantSnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(restaurantId)
          .get();

      // Extract the locationLatLng from the restaurant document
      GeoPoint location = restaurantSnapshot.get('locationLatLng');
      log("Location: $location");

      // Convert the latitude and longitude to human-readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      log(placemarks[0].administrativeArea.toString());
      log(location.latitude.toString());
      log(location.longitude.toString());
      if (placemarks.isNotEmpty) {
        setState(() {
          restaurantAddress =
              "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
          log("Restaurant Address: $restaurantAddress");
        });
      }
    } catch (error) {
      if (error is PlatformException &&
          error.code == 'io.grpc.Status.DEADLINE_EXCEEDED') {
        // Retry the operation or show an error message to the user
        log('Timeout error: $error');
      } else {
        // Handle other types of errors
        log("Error fetching restaurant location: $error");
      }
    }
  }

  // Fetch total and pending orders data from Firestore
  Future _fetchOrdersData() async {
    // Fetch total orders where managerId matches currentUId
    QuerySnapshot totalOrdersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('managerId', isEqualTo: currentUId)
        // .where("status", isEqualTo: )
        .get();

    // Fetch pending orders where managerId matches currentUId and status is 1
    QuerySnapshot pendingOrdersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('managerId', isEqualTo: currentUId)
        .where('status', whereIn: [1, 2, 3, 4]).get();

    // Get today's date range (start and end of the day)
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Fetch today's orders where managerId matches currentUId and orderDate is within today's range
    QuerySnapshot todaysOrdersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('managerId', isEqualTo: currentUId)
        // .where("status", isEqualTo: 1)
        .where('orderDate', isGreaterThanOrEqualTo: startOfDay)
        .where('orderDate', isLessThanOrEqualTo: endOfDay)
        .get();

    setState(() {
      totalOrders = totalOrdersSnapshot.docs.length;
      pendingOrders = pendingOrdersSnapshot.docs.length;
      todaysOrder = todaysOrdersSnapshot.docs.length;

      log("Total Orders: " + totalOrdersSnapshot.docs.length.toString());
      log("Pending Orders: " + pendingOrdersSnapshot.docs.length.toString());
      log("Today  Orders: " + todaysOrdersSnapshot.docs.length.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrdersData();
    fetchRestaurantLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(),
      ),
      body: restaurantAddress != null
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 30.sp, color: Colors.green),
                        SizedBox(width: 5.w),
                        SizedBox(
                          width: 279,
                          child: Text("$restaurantAddress",
                              maxLines: 2,
                              style: appStyle(16, kDark, FontWeight.normal)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      // onTap: () => Get.to(() => OrderHistoryScreen()),
                      onTap: () {
                        widget.setTab?.call(1);
                      },
                      child: _compactDashboardItem(
                          "Today Orders", todaysOrder.toString(), kSecondary),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => Get.to(() => OrderHistoryScreen()),
                      child: _compactDashboardItem(
                          "Total Orders", totalOrders.toString(), kRed),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      // onTap: () => Get.to(() => OrderHistoryScreen()),
                      onTap: () {
                        widget.setTab?.call(1);
                      },
                      child: _compactDashboardItem("Pending Orders",
                          pendingOrders.toString(), Colors.green),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _compactDashboardItem(String title, String value, Color color) {
    return Container(
      height: 180.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: appStyle(26, kWhite, FontWeight.bold)),
          SizedBox(height: 10.h),
          Text(value, style: appStyle(16, kWhite, FontWeight.bold)),
        ],
      ),
    );
  }
}
