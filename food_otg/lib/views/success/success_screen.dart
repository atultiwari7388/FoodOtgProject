import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/custom_gradient_button.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:food_otg/views/entry_point.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.h,
            ),
            SizedBox(height: 20),
            Text('Order Successful!',
                style: appStyle(24, kDark, FontWeight.normal)),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Ordered Food',
                      textAlign: TextAlign.center,
                      style: appStyle(18, kDark, FontWeight.normal)),
                  SizedBox(height: 5),
                  // Text('${widget.food['title']} - ₹${widget.food['price']}',
                  //     textAlign: TextAlign.center,
                  //     style: appStyle(16, kDark, FontWeight.normal)),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomGradientButton(
                text: "Back to Home",
                onPress: () => Get.offAll(() => DashboardScreen())),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: Text(
            //     'Back to Home',
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.white,
            //     onPrimary: Colors.green,
            //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
