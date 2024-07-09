import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';
import '../utils/app_styles.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton(
      {super.key, required this.text, required this.onPress});

  final String text;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF976E38),
              Color(0xFFF8E79F),
              Color(0xFF976E38),
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: onPress,
          child: Text(text, style: appStyle(16, kDark, FontWeight.w500)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size(320.w, 45.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}