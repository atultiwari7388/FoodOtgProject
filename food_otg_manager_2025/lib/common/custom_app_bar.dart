import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager_2025/common/reusable_text.dart';
import 'package:food_otg_manager_2025/utils/app_style.dart';
import 'package:food_otg_manager_2025/views/profile/profile_screen.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../services/collection_refrences.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      height: 90.h,
      width: width,
      color: kOffWhite,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Icon(Icons.location_on, color: kSecondary, size: 35.sp),
            //     Padding(
            //       padding: EdgeInsets.only(bottom: 4.h, left: 5.w),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           ReusableText(
            //               text: "Deliver to",
            //               style: appStyle(12, kSecondary, FontWeight.bold)),
            //           SizedBox(
            //             width: width * 0.65,
            //             child: Text(
            //               "677, Panchkula, Haryana",
            //               overflow: TextOverflow.ellipsis,
            //               style: appStyle(10, kGrayLight, FontWeight.normal),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            //
            ReusableText(
                text: "DashBoard",
                style: appStyle(20, kSecondary, FontWeight.normal)),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 900));
              },
              child: CircleAvatar(
                radius: 19.r,
                backgroundColor: kSecondary,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Managers')
                      .doc(currentUId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final profileImageUrl = data['profilePicture'] ?? '';
                    final userName = data['name'] ?? '';

                    if (profileImageUrl.isEmpty) {
                      return Text(
                        userName.isNotEmpty ? userName[0] : '',
                        style: appStyle(20, kWhite, FontWeight.bold),
                      );
                    } else {
                      return ClipOval(
                        child: Image.network(
                          profileImageUrl,
                          width: 38.r, // Set appropriate size for the image
                          height: 38.r,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return " 🌞 ";
    } else if (hour >= 12 && hour < 16) {
      return " ⛅ ";
    } else {
      return " 🌙 ";
    }
  }
}
