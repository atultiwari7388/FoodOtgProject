import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager_2025/views/auth/email_authentication.dart';
import 'package:food_otg_manager_2025/views/items/add_items.dart';
import 'package:food_otg_manager_2025/views/items/items_screen.dart';
import 'package:food_otg_manager_2025/views/notificationSetting/notification_setting.dart';
import 'package:food_otg_manager_2025/views/orderHistory/order_history_screen.dart';
import 'package:food_otg_manager_2025/views/profile/profile_details_screen.dart';
import 'package:get/get.dart';
import '../../common/custom_container.dart';
import '../../common/dashed_divider.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../services/collection_refrences.dart';
import '../../utils/app_style.dart';
import '../../utils/toast_msg.dart';
import '../aboutUs/about_us.dart';

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
                              "Orders and Items",
                              style:
                                  appStyle(18, kSecondary, FontWeight.normal),
                            ),
                            SizedBox(width: 5.w),
                            Container(width: 30.w, height: 3.h, color: kDark),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        DashedDivider(color: kGrayLight),
                        SizedBox(height: 10.h),
                        buildListTile(
                            "assets/add-items.png",
                            "Add Items",
                            () => Get.to(() => AddItemsScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                          "assets/item-list.png",
                          "Item Lists",
                          () => Get.to(() => ItemsScreen(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 900)),
                        ),
                        buildListTile(
                            "assets/order-history.png",
                            "Order History",
                            () => Get.to(() => OrderHistoryScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile(
                          "assets/profile.png",
                          "Your Profile",
                          () => Get.to(() => ProfileDetailsScreen(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 900)),
                        ),
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
                              style:
                                  appStyle(18, kSecondary, FontWeight.normal),
                            ),
                            SizedBox(width: 5.w),
                            Container(width: 30.w, height: 3.h, color: kDark),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        DashedDivider(color: kGrayLight),
                        SizedBox(height: 10.h),
                        buildListTile(
                          "assets/about_us.png",
                          "About us",
                          () => Get.to(() => AboutUsScreen(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 900)),
                        ),
                        buildListTile(
                            "assets/settings.png",
                            "Settings",
                            () => Get.to(() => NotificationSettingScreen(),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 900))),
                        buildListTile("assets/logout.png", "Logout",
                            () => signOut(context)),
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

  ListTile buildListTile(String iconName, String title, void Function() onTap) {
    return ListTile(
      leading: Image.asset(iconName, height: 20.h, width: 20.w),
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
            .collection('Managers')
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
          final userName = data['name'] ?? '';
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
      Get.offAll(() => EmailAuthenticationScreen());
    } catch (e) {
      showToastMessage("Error", e.toString(), Colors.red);
    }
  }
}
