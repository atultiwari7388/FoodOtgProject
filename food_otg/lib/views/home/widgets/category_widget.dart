import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/utils/app_styles.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.img,
    required this.title,
    required this.onTap,
    // required this.isVeg,
  }) : super(key: key);

  final String img;
  final String title;
  // final bool isVeg;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Container(
                height: 210.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF976E38)),
                ),
                width: double.infinity,
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    // color: kWhite,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF976E38),
                        Color(0xFFF8E79F),
                        Color(0xFF976E38),
                        // Color(0xFFF8E79F),
                        // Colors.white,
                        // Colors.white.withOpacity(0.1),
                        // Colors.white
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: appStyle(15, kDark, FontWeight.w500)),
                      // Text('₹$price',
                      //     style: appStyle(15, kWhite, FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   top: 10.h,
              //   right: 10.w,
              //   child: IconButton(
              //     onPressed: () {
              //       // Handle adding to wishlist
              //     },
              //     icon: Icon(
              //       Icons.favorite_border,
              //       color: Colors.red,
              //     ),
              //   ),
              // ),
              // Positioned(
              //   bottom: 5.h,
              //   right: 10.w,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              //     decoration: BoxDecoration(
              //       // color: isVeg ? Colors.green : Colors.red,
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Text(
              //       // isVeg == true ? 'Veg' : 'Non-Veg',
              //       "veg",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
