import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/backgroun_container.dart';
import 'package:food_otg/constants/uidata.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import 'category_page.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kOffWhite,
        title: Text(
          "Categories",
          style: AppFontStyles.font18Style
              .copyWith(color: kGray, fontWeight: FontWeight.bold),
        ),
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: height,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(categories.length, (i) {
              var category = categories[i];
              return CategoryTileWidget(category: category);
            }),
          ),
        ),
      ),
    );
  }
}

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget({
    super.key,
    required this.category,
  });

  final dynamic category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>  CategoryPage(categoryName: category["title"],),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 900),);
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 18.r,
          backgroundColor: kGrayLight,
          child: Image.network(category["imageUrl"],
              fit: BoxFit.contain),
        ),
        title:
            Text(category["title"], style: AppFontStyles.font14Style),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios_sharp,
              size: 15.r, color: kGray),
        ),
      ),
    );
  }
}
