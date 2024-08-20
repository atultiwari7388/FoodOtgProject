import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/utils/toast_msg.dart';
import '../utils/app_styles.dart';
import 'collection_refrences.dart';

class AppServices {
  Future<String?> showPaymentModeDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Choose Payment Mode', style: AppFontStyles.font20Style),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Online Payment',
                style: AppFontStyles.font16Style,
              ),
              leading: Radio<String>(
                value: 'online',
                groupValue: 'paymentMode',
                onChanged: (String? value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
            ListTile(
              title: Text('Pay with Cash', style: AppFontStyles.font16Style),
              leading: Radio<String>(
                value: 'cash',
                groupValue: 'paymentMode',
                onChanged: (String? value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define a function to map numeric status to string status
  String getStatusString(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Order Confirmed";
      case 2:
        return "Driver Assigned";
      case 3:
        return "Out for delivery";
      case 4:
        return "Payment to Delivery Partner";
      case 5:
        return "Order Delivered";
      case -1:
        return "Order Cancelled";
      // Add more cases as needed for other statuses
      default:
        return "Unknown Status";
    }
  }

  Future<void> updateDriverEarnings(double fare, double totalFare,
      double gstAmount, String paymentMode, String driverId) async {
    DocumentReference driverRef =
        FirebaseFirestore.instance.collection('Drivers').doc(driverId);

    DocumentSnapshot driverDoc = await driverRef.get();
    if (!driverDoc.exists) return;

    Map<String, dynamic> data = driverDoc.data() as Map<String, dynamic>;

    // Increment rideComplete count
    num rideComplete = (data['orderCompleted'] ?? 0).toDouble();
    rideComplete += 1;

    // Increment totalRide count
    num totalRide = (data['totalOrders'] ?? 0).toDouble();
    totalRide += 1;

    // Add fare to totalEarning
    num totalEarning = (data['totalEarning'] ?? 0.0).toDouble();
    totalEarning += fare;

    // Update earnings based on payment mode
    if (paymentMode == 'cash') {
      num offlinePayments = (data['offlinePayments'] ?? 0.0).toDouble();
      offlinePayments += fare;

      await driverRef.update({
        'offlinePayments': offlinePayments,
      });
    } else if (paymentMode == 'online') {
      num onlinePayments = (data['onlinePayments'] ?? 0.0).toDouble();
      onlinePayments += fare;

      await driverRef.update({
        'onlinePayments': onlinePayments,
      });
    }

    Timestamp? lastUpdated = data['lastUpdated'];
    DateTime now = DateTime.now();

    // Get the current date (day) and store it as a variable
    int currentDay = now.day;

    // Check if the current date is the same as the lastUpdated date
    if (lastUpdated != null && lastUpdated.toDate().day == currentDay) {
      // If it's the same day, add fare to todaysEarning and update GST amount and total fare
      num todaysEarning = (data['todaysEarning'] ?? 0.0).toDouble();
      todaysEarning += fare;

      await driverRef.update({
        'orderCompleted': rideComplete,
        'totalEarning': totalEarning,
        'todaysEarning': todaysEarning,
        'lastUpdated': Timestamp.fromDate(now),
        'totalOrders': totalRide,
        'gstAmount': (data['gstAmount'] ?? 0.0) + gstAmount,
        'totalOrdersFare': (data['totalOrdersFare'] ?? 0.0) + totalFare,
      });
    } else {
      // If it's a new day, reset todaysEarning to 0 and start adding earnings for the new day
      await driverRef.update({
        'orderCompleted': rideComplete,
        'totalEarning': totalEarning,
        'todaysEarning': fare,
        'lastUpdated': Timestamp.fromDate(now),
        'totalOrders': totalRide,
        'gstAmount': gstAmount,
        'totalOrdersFare': totalFare,
      });
    }
  }

  //=============================== rating and review =========================
// Add a method to show the rating dialog
  void showRatingDialog(
    String orderId,
    String driverId,
    BuildContext context,
    String managerId,
    List<dynamic> orderItems,
  ) {
    double _rating = 0;
    String _review = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Rate to Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating; // Update rating when it changes
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Write a review'),
                onChanged: (value) {
                  _review = value; // Update review when it changes
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _updateRatingAndReview(
                  orderId,
                  driverId,
                  _rating,
                  _review,
                  managerId,
                  orderItems,
                );
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRatingAndReview(
    String orderId,
    String driverId,
    double rating,
    String review,
    String managerId,
    // String itemId,
    List<dynamic> orderItems,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUId)
          .collection("history")
          .doc(orderId)
          .update({
        'rating': rating,
        'review': review,
        "reviewSubmitted": true,
      });
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'rating': rating,
        'review': review,
        "reviewSubmitted": true,
      });

      await FirebaseFirestore.instance
          .collection('Managers')
          .doc(managerId)
          .collection('ratings')
          .doc()
          .set({
        'rating': rating,
        'review': review,
        "uId": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": DateTime.now(),
      });

      await FirebaseFirestore.instance
          .collection('Drivers')
          .doc(driverId)
          .collection('ratings')
          .doc()
          .set({
        'rating': rating,
        'review': review,
        "uId": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": DateTime.now(),
      });

      for (var orderItem in orderItems) {
        final itemId = orderItem['foodId'];
        DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
            .collection('Items')
            .doc(itemId)
            .get();

        num currentRatingCount = itemSnapshot["ratingCount"] ?? 0;
        num newratingCount = currentRatingCount + 1;
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(itemId)
            .update({
          'rating': rating,
          'ratingCount': newratingCount,
          "timestamp": DateTime.now(),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('Items')
              .doc(itemId)
              .collection('ratings')
              .doc()
              .set({
            'rating': rating,
            'review': review,
            "uId": FirebaseAuth.instance.currentUser!.uid,
            "timestamp": DateTime.now(),
          });
        });

        log('Rating and review updated successfully.');
      }
    } catch (error) {
      log('Error updating rating and review: $error');
      showToastMessage(
          'Error', 'Failed to submit rating and review.', Colors.red);
    }
  }
}
