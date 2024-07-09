import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/dashed_divider.dart';
import 'package:food_otg/common/reusable_text.dart';
import 'package:food_otg/services/collection_refrences.dart';
import 'package:food_otg/views/aboutus/about_us.dart';
import 'package:food_otg/views/address/address_management_screen.dart';
import 'package:food_otg/views/favoriteScreen/favorite_screen.dart';
import 'package:food_otg/views/history/all_order_history_screen.dart';
import 'package:food_otg/views/notification/notification_setting_screen.dart';
import 'package:food_otg/views/profile/profile_details_screen.dart';
import 'package:get/get.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';
import '../../utils/app_styles.dart';
import '../../utils/toast_msg.dart';
import '../auth/phone_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0,
        title: ReusableText(
            text: "Profile", style: appStyle(18, kDark, FontWeight.normal)),
      ),
      body: CustomContainer(
        containerContent: Container(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 5.w, right: 5.w),
              padding: EdgeInsets.only(left: 7.w, right: 12.w, top: 7.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h),
                  //top card
                  GestureDetector(
                      onTap: () => Get.to(() => ProfileDetailsScreen(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 900)),
                      child: buildTopProfileSection()),
                  SizedBox(height: 18.h),

                  Container(
                    width: double.maxFinite,
                    // margin: EdgeInsets.symmetric(horizontal: 12.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: kLightWhite,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Food",
                              style: appStyle(18, kPrimary, FontWeight.normal),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                                width: 30.w, height: 3.h, color: Colors.red),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        DashedDivider(color: kGrayLight),
                        SizedBox(height: 10.h),
                        buildListTile(
                            "Your Foods",
                            () => Get.to(() => AllOrderHistoryScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                            "Favorite",
                            () => Get.to(
                                () =>
                                    WishlistScreen(currentUserUid: currentUId),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                            "Address Book",
                            () => Get.to(
                                () => AddressManagementScreen(
                                    userLat: 0, userLng: 0),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                            "Your Profile",
                            () => Get.to(() => ProfileDetailsScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.maxFinite,
                    // margin: EdgeInsets.symmetric(horizontal: 12.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: kLightWhite,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "More",
                              style: appStyle(18, kPrimary, FontWeight.normal),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                                width: 30.w, height: 3.h, color: Colors.red),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        DashedDivider(color: kGrayLight),
                        SizedBox(height: 10.h),
                        buildListTile(
                            "About",
                            () => Get.to(() => AboutUsScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                            "Send Feedback", () => print("Send Feedback")),
                        buildListTile(
                            "Settings",
                            () => Get.to(() => NotificationScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile("Logout", () => signOut(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(String title, void Function() onTap) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: kGray),
      title: Text(title, style: appStyle(13, kDark, FontWeight.normal)),
      onTap: onTap,
    );
  }

//================================ top Profile section =============================
  Container buildTopProfileSection() {
    return Container(
      height: 120.h,
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w),
      decoration: BoxDecoration(
        color: kLightWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final profilePictureUrl = data['profilePicture'] ?? '';
          final userName = data['userName'] ?? '';
          final email = data['email'] ?? '';

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 33.r,
                backgroundColor: kSecondary,
                child: profilePictureUrl.isEmpty
                    ? Text(
                        userName.isNotEmpty ? userName[0] : '',
                        style: appStyle(20, kWhite, FontWeight.bold),
                      )
                    : CircleAvatar(
                        radius: 33.r,
                        backgroundImage: NetworkImage(profilePictureUrl),
                      ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: userName.isNotEmpty ? userName : '',
                      style: appStyle(15, kDark, FontWeight.bold),
                    ),
                    ReusableText(
                      text: email.isNotEmpty ? email : '',
                      style: appStyle(12, kDark, FontWeight.normal),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  //====================== signOut from app =====================
  void signOut(BuildContext context) async {
    try {
      await auth.signOut();
      Get.offAll(() => PhoneAuthenticationScreen());
    } catch (e) {
      showToastMessage("Error", e.toString(), Colors.red);
    }
  }
}
