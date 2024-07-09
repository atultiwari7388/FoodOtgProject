import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/custom_gradient_button.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:food_otg/views/entry_point.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Set your location to start exploring restaurants near you",
                style: appStyle(18, kDark, FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              // SizedBox(height: 20),
              // Add your location image or Lottie file here
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/map_img.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ), // Placeholder for illustration, replace with your widget
              ),

              SizedBox(height: 20.h),

              CustomGradientButton(
                  text: "Enable Device Location",
                  onPress: () => Get.offAll(() => DashboardScreen())),
              SizedBox(height: 20.h),
              OutlinedButton(
                onPressed: () {
                  Get.offAll(() => DashboardScreen());
                  // Action to enter location manually
                },
                child: Text('Enter Your Location Manually'),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 46.h),
                    foregroundColor: kPrimary,
                    side: BorderSide(color: kPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
