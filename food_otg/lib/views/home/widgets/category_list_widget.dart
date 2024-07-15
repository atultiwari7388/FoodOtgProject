import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/views/home/widgets/category_widget.dart';
import 'package:get/get.dart';
import '../categories_food_screen.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key, required this.searchText})
      : super(key: key);

  final String searchText;

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Categories")
          .orderBy("priority", descending: false)
          .where("active", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          final catG = snapshot.data!.docs;
          final searchText = widget.searchText.toLowerCase();
          final filteredCategories = catG.where((category) {
            final categoryName =
                category['categoryName'].toString().toLowerCase();
            return categoryName.contains(searchText);
          }).toList();

          if (filteredCategories.isEmpty) {
            return Center(
              child: Text('No categories found.'),
            );
          }

          return Container(
            padding: EdgeInsets.only(left: 12.w, top: 5.h),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredCategories.length,
              itemBuilder: (ctx, i) {
                final catData = filteredCategories[i].data();
                return CategoryWidget(
                  img: catData["imageUrl"],
                  title: catData["categoryName"],
                  onTap: () {
                    Get.to(
                      () => CategoriesFoodScreen(
                        categoryName: catData["categoryName"],
                        categoryId: catData["docId"],
                      ),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 900),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
