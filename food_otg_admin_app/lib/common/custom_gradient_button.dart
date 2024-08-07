import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../utils/appStyle.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton(
      {super.key,
      required this.text,
      required this.onPress,
      required this.h,
      required this.w});

  final String text;
  final void Function()? onPress;
  final double h;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size(w, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(text, style: appStyle(16, kDark, FontWeight.w500)),
        ),
      ),
    );
  }
}
