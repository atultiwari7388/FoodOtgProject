import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager/common/custom_gradient_button.dart';
import 'package:food_otg_manager/utils/toast_msg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../common/dashed_divider.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';
import '../../../services/collection_refrences.dart';
import '../../../utils/app_style.dart';
import '../../../utils/generate_otp.dart';

class HistoryScreenItems extends StatefulWidget {
  const HistoryScreenItems({
    Key? key,
    required this.orderId,
    required this.location,
    required this.totalPrice,
    required this.userId,
    required this.status,
    required this.userLat,
    required this.userLong,
    required this.orderItems,
    required this.switchTab,
    required this.orderDate,
  }) : super(key: key);
  final String orderId;
  final String location;
  final num totalPrice;
  final String userId;
  final int status;
  final double userLat;
  final double userLong;
  final dynamic orderItems;
  final Function(int) switchTab; // Add this line
  final dynamic orderDate;

  @override
  State<HistoryScreenItems> createState() => _HistoryScreenItemsState();
}

class _HistoryScreenItemsState extends State<HistoryScreenItems> {
  String? managerResId;
  String? managerId;
  String? restName;
  String? resManagerName;
  late GeoPoint restLocation;
  var logger = Logger();
  double dist = 0.0;
  bool isLoadingShown = true;

// Function to fetch manager and restaurant details
  Future<void> fetchManagerAndRestaurantDetails() async {
    try {
      managerId = currentUId;
      logger.d("Manager ID: $managerId");
      DocumentSnapshot managerSnapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(managerId)
          .get();

      // Extract the restaurant ID from the manager document
      String restaurantId = managerSnapshot.get('resId');
      String restaurantName = managerSnapshot.get('res_name');
      String managerName = managerSnapshot.get("name");
      GeoPoint restaurantLocation = managerSnapshot.get("locationLatLng");

      // Calculate distance and check if user is within 5 km range
      double distance = calculateDistance(
        widget.userLat,
        widget.userLong,
        restaurantLocation.latitude,
        restaurantLocation.longitude,
      );
      setState(() {
        dist = distance;
      });
      logger.i("Calulating distance and check if user is within 5 km range  " +
          dist.toString() +
          "  km");
      // Check if the distance is within 5 km range
      if (dist <= 5) {
        // Display order details since it's within range
        setState(() {
          managerResId = restaurantId;
          restName = restaurantName;
          resManagerName = managerName;
          restLocation = restaurantLocation;
          logger.d("Manager Restaurant ID: $managerResId");
          logger.d(
              "Manager Restaurant Location: ${restLocation.latitude.toString() + ":" + restLocation.longitude.toString()}");
          logger.d("Manager Name: $resManagerName");
          logger.d("Manager Restaurant Name: $restName");
        });
      } else {
        // Skip displaying this order
        // showToastMessage(
        //     "Info", "No orders found within 5 km range", Colors.red);

        logger.e("No item found total distnce is ${dist.toString()}");
      }
    } catch (error) {
      if (error is PlatformException &&
          error.code == 'io.grpc.Status.DEADLINE_EXCEEDED') {
        logger.e('Timeout error: $error');
      } else {
        // Handle other types of errors
        logger.e("Error fetching restaurant location: $error");
      }
    }
  }

// Function to calculate distance between two geographical points using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers

    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

// Function to check if the user is within 5 km range of the restaurant
  bool isWithin5KmRange(
      double userLat, double userLong, double restLat, double restLong) {
    double distance = calculateDistance(userLat, userLong, restLat, restLong);
    logger.d("Total distance: " + distance.toString() + "km");
    return distance <= 5;
  }

  @override
  void initState() {
    super.initState();
    fetchManagerAndRestaurantDetails();
  }

  @override
  Widget build(BuildContext context) {
    // if (dist == 0.0 && isLoadingShown) {
    //   isLoadingShown = false;
    //   return Center(child: CircularProgressIndicator());
    // }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 20.0.w),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1.0,
                  blurRadius: .3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "${widget.orderId}",
                        style: appStyle(16, kDark, FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: kDark, size: 28.sp),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width: 220,
                        child: Text(
                          // ignore: unnecessary_null_comparison
                          "${widget.location != null ? widget.location.split('  ').last : ''}",
                          maxLines: 2,
                          style: appStyle(14, kDark, FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "Status:",
                        style: appStyle(14, Colors.green, FontWeight.bold),
                      ),
                      ReusableText(
                        text: getStatusString(widget.status),
                        style: appStyle(
                            14,
                            widget.status == 0
                                ? Colors.orange
                                : widget.status == 1
                                    ? Colors.green
                                    : widget.status == 2
                                        ? Colors.blue
                                        : widget.status == 3
                                            ? Colors.yellow
                                            : widget.status == 4
                                                ? Colors.blue
                                                : widget.status == 5
                                                    ? Colors.green
                                                    : widget.status == -1
                                                        ? Colors.red
                                                        : Colors.black,
                            FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text:
                        "Order Date: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.orderDate)}",
                    style: appStyle(13, kGrayLight, FontWeight.normal),
                  ),
                  SizedBox(height: 20.h),
                  DashedDivider(),
                  SizedBox(height: 20.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem = widget.orderItems[index];
                      return Column(
                        children: [
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  orderItem["foodImage"],
                                  width: 40.w,
                                  height: 40.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderItem['foodName'].toString(),
                                      style: appStyle(
                                          14, kDark, FontWeight.normal),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_cart,
                                            color: kGray, size: 20.sp),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "Qty: ${orderItem['quantity']} * ₹${orderItem['foodPrice'].round()} ",
                                          style: appStyle(
                                              12, kGray, FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          DashedDivider(),
                        ],
                      );
                    },
                  ),
                  DashedDivider(),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "Total ",
                        style: appStyle(14, kRed, FontWeight.bold),
                      ),
                      ReusableText(
                          text: "₹${widget.totalPrice.round()}",
                          style: appStyle(14, kRed, FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: 20.h),
                  DashedDivider(),
                  SizedBox(height: 20.h),
                  //======================== when status is 0 For first time to accept the order
                  if (widget.status == 0)
                    Center(
                      child: CustomGradientButton(
                        text: "Confirm",
                        onPress: () => _acceptOrder(widget.status),
                        h: 35.h,
                        w: 120.w,
                      ),
                    ),

                  //======================== when status is 1, Waiting for delivery partner to accept the order
                  if (widget.status == 1)
                    Row(
                      children: [
                        CircularProgressIndicator(color: kSecondary),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 240.w,
                          child: Text("Food is preparing ",
                              maxLines: 2,
                              style: appStyle(15, kSecondary, FontWeight.bold)),
                        )
                      ],
                    ),

                  //======================== when status is 2, Preparing food
                  if (widget.status == 2)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240.w,
                          child: Text(
                              "* When your food is ready then tap on the Food is Prepared Button",
                              maxLines: 2,
                              style: appStyle(11, kGray, FontWeight.normal)),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: CustomGradientButton(
                            text: "Food is Prepared",
                            onPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.orderId)
                                  .update({'status': 3});

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.userId)
                                  .collection('history')
                                  .doc(widget.orderId)
                                  .update({"status": 3});
                            },
                            h: 40.h,
                            w: 80.w,
                          ),
                        )
                      ],
                    ),
                ],
              ),
            )));
  }

  // Define a function to map numeric status to string status
  String getStatusString(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Order Confirmed";
      case 2:
        return "Driver Assign";
      case 3:
        return "Out of delivery";
      case 4:
        return "OTP/Payment Request";
      case 5:
        return "Order Delivered";
      case -1:
        return "Order Cancelled";
      // Add more cases as needed for other statuses
      default:
        return "Unknown Status";
    }
  }

  void _acceptOrder(int status) async {
    try {
      // Update values in the orders collection
      int otp = generateOTP();
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({
        // 'restId': managerResId.toString(),
        'restName': restName.toString(),
        'managerId': managerId.toString(),
        'managerName': resManagerName.toString(),
        "restLocation": restLocation,
        "otp": otp,
        'status': 1,
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('history')
          .doc(widget.orderId)
          .update({
        // 'restId': managerResId.toString(),
        'restName': restName.toString(),
        'managerId': managerId.toString(),
        'managerName': resManagerName.toString(),
        "restLocation": restLocation,
        "otp": otp,
        'status': 1,
      });
      widget.switchTab(1);

      // Listen to the stream of the order document to get real-time updates
      final StreamSubscription<DocumentSnapshot> subscription =
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.orderId)
              .snapshots()
              .listen((DocumentSnapshot orderSnapshot) {
        if (orderSnapshot.exists) {
          // Update the UI with the new status
          setState(() {
            status = orderSnapshot['status'];
          });
        }
      });

      // Dispose the subscription when the widget is disposed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        subscription.cancel();
      });

      showToastMessage("Success", "Order accepted", Colors.green);
    } catch (error) {
      logger.e("Error accepting order: $error");
    }
  }
}
