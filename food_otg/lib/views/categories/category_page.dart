import 'package:flutter/material.dart';
import 'package:food_otg/constants/constants.dart';
import '../../utils/app_styles.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.categoryName});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kOffWhite,
        title: Text(categoryName,
            style: AppFontStyles.font18Style
                .copyWith(color: kGray, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
