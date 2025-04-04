import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_driver_2025/constants/constants.dart';
import 'package:food_otg_driver_2025/utils/app_style.dart';

class AdminReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review In Progress',
            style: appStyle(18, kDark, FontWeight.normal)),
        elevation: 1,
        backgroundColor: kPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 100.h,
              color: kPrimary,
            ),
            SizedBox(height: 20.h),
            Text(
              'Your application is under review',
              style: appStyle(18, kDark, FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Text(
                'Our admin team is reviewing your details. You will be notified once your application is approved.',
                style: appStyle(15, kDark, FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to some other part of the app, or allow the user to logout or check status
            //   },
            //   child: Text('Go to Home', style: AppFontStyles.font20Style),
            // ),
          ],
        ),
      ),
    );
  }
}
