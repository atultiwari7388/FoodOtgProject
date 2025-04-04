import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_2025/common/dashed_divider.dart';
import 'package:food_otg_2025/services/app_services.dart';
import 'package:food_otg_2025/utils/toast_msg.dart';
import 'package:food_otg_2025/views/history/round_fare.dart';
import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../common/custom_container.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../services/collection_refrences.dart';
import '../../utils/app_styles.dart';

class AllOrderHistoryScreen extends StatefulWidget {
  const AllOrderHistoryScreen({Key? key});

  @override
  State<AllOrderHistoryScreen> createState() => _AllOrderHistoryScreenState();
}

class _AllOrderHistoryScreenState extends State<AllOrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Center(
          child: ReusableText(
              text: "History",
              style: appStyle(20, kSecondary, FontWeight.bold)),
        ),
      ),
      body: CustomContainer(
        containerContent: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUId)
              .collection("history")
              .where("status", isEqualTo: 5)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Check if cart is empty
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Your history is empty'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final cartItem = snapshot.data!.docs[index];
                      final cartId = cartItem["orderId"];
                      return AllOrderHistoryScreenItems(
                          cartItem: cartItem, cartId: cartId);
                    },
                  ),
                  SizedBox(height: 105.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllOrderHistoryScreenItems extends StatefulWidget {
  final dynamic cartItem;
  final String cartId;

  const AllOrderHistoryScreenItems(
      {Key? key, required this.cartItem, required this.cartId})
      : super(key: key);

  @override
  State<AllOrderHistoryScreenItems> createState() =>
      _AllOrderHistoryScreenItemsState();
}

class _AllOrderHistoryScreenItemsState
    extends State<AllOrderHistoryScreenItems> {
  @override
  Widget build(BuildContext context) {
    final orderId = widget.cartItem['orderId'];
    final managerId = widget.cartItem['managerId'];
    final resIdList = widget.cartItem['restId'];
    final orderTime = DateTime.fromMillisecondsSinceEpoch(
        widget.cartItem['orderDate'].millisecondsSinceEpoch);
    final location = widget.cartItem['userDeliveryAddress'].split(' ').last;
    final status = widget.cartItem['status'];
    final newStatus = AppServices().getStatusString(status);

    final totalPrice = widget.cartItem['totalBill'];
    final otp = widget.cartItem["otp"] ?? "";
    final paymentMode = widget.cartItem['payMode'];
    final driverId = widget.cartItem["driverId"];
    final bool reviewSubmitted = widget.cartItem['reviewSubmitted'] ?? false;
    final roundfareTotal = roundFare(totalPrice);

    final discountAmountPercentage = widget.cartItem['discountValue'];
    final discountAmount = widget.cartItem["discountAmount"];
    final gstAmountPercentage = widget.cartItem["gstAmount"];
    final gstAmountPrice = widget.cartItem["gstAmountPrice"];
    final deliveryCharges = widget.cartItem["deliveryCharges"];
    final subTotalBill = widget.cartItem["subTotalBill"];

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
                    text: "$orderId",
                    style: appStyle(16, kDark, FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: kDark, size: 28.sp),
                      SizedBox(width: 5.w),
                      ReusableText(
                        text: "$location",
                        style: appStyle(14, kRed, FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              ReusableText(
                text: "Status: $newStatus",
                style: appStyle(14, Colors.green, FontWeight.bold),
              ),
              SizedBox(height: 3.h),
              ReusableText(
                text:
                    "Order Time: ${DateFormat('yyyy-MM-dd HH:mm').format(orderTime)}",
                style: appStyle(13, kGrayLight, FontWeight.normal),
              ),
              SizedBox(height: 20.h),
              DashedDivider(),
              SizedBox(height: 20.h),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.cartItem['orderItems'].length,
                itemBuilder: (context, index) {
                  final orderItem = widget.cartItem['orderItems'][index];
                  return Column(
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              orderItem["foodImage"],
                              width: 70.w,
                              height: 70.h,
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
                                  style: appStyle(18, kDark, FontWeight.normal),
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
                                          14, kGray, FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      DashedDivider(),
                    ],
                  );
                },
              ),
              DashedDivider(),
              SizedBox(height: 20.h),
              Column(
                children: [
                  reusbaleRowTextWidget("SubTotal :",
                      "₹${subTotalBill.round().toStringAsFixed(2)}"),
                  SizedBox(height: 3.h),
                  reusbaleRowTextWidget(
                      "Discounts (${discountAmountPercentage}%) :",
                      "-₹${discountAmount.round().toStringAsFixed(2)}"),
                  SizedBox(height: 3.h),
                  reusbaleRowTextWidget("Delivery Charges  :",
                      "₹${deliveryCharges.round().toStringAsFixed(2)}"),
                  SizedBox(height: 3.h),
                  reusbaleRowTextWidget("GST(${gstAmountPercentage}%)  :",
                      "₹${gstAmountPrice.round().toStringAsFixed(2)}"),
                  SizedBox(height: 5.h),
                  DashedDivider(),
                  SizedBox(height: 5.h),
                  reusbaleRowTextWidget("Total Bill  :",
                      "₹${roundfareTotal.round().toStringAsFixed(2)}"),
                ],
              ),
              SizedBox(height: 20.h),
              DashedDivider(),
              SizedBox(height: 20.h),
              if (status == 5 && reviewSubmitted == false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // showRatingDialog(booking, context);
                        AppServices().showRatingDialog(orderId, driverId,
                            context, managerId, widget.cartItem['orderItems']);
                      },
                      child: Text("Leave a Rating"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondary,
                        foregroundColor: kDark,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Row reusbaleRowTextWidget(String firstTitle, String secondTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(firstTitle, style: appStyle(14, kDark, FontWeight.normal)),
        Text(secondTitle, style: appStyle(11, kGray, FontWeight.normal)),
      ],
    );
  }
}
