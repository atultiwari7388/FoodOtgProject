import 'package:flutter/material.dart';
import 'package:food_otg_2025/constants/constants.dart';

class CustomCircleIconButton extends StatelessWidget {
  const CustomCircleIconButton(
      {super.key, required this.icon, required this.onPress});

  final Icon icon;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kWhite,
      child: IconButton(
        icon: icon,
        onPressed: onPress,
      ),
    );
  }
}
