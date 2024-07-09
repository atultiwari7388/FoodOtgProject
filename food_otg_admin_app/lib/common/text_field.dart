import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../utils/appStyle.dart';

TextFormField buildTextFormField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        // labelText: labelText,
        labelStyle: appStyle(18, kDark, FontWeight.normal)),
  );
}
