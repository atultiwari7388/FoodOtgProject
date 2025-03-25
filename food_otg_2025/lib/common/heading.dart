import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_otg_2025/constants/constants.dart';
import 'package:food_otg_2025/utils/app_styles.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              text,
              style: AppFontStyles.font16Style
                  .copyWith(color: kDark, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(AntDesign.appstore1, size: 20.sp, color: kSecondary),
          )
        ],
      ),
    );
  }
}
