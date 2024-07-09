import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/backgroun_container.dart';
import 'package:food_otg/common/custom_gradient_button.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/controllers/personal_details_controller.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:get/get.dart';
import '../location/location_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kPrimary),
        title: Text('Personal Details',
            style: appStyle(20, kDark, FontWeight.w500)),
        elevation: 3,
        centerTitle: true,
      ),
      body: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (!controller.isLoading) {
            return BackgroundContainer(
              color: kWhite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "What's your name?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: controller.nameController,
                      onChanged: (value) {
                        setState(() {
                          controller.isButtonEnabled = value.isNotEmpty;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      "What is your interest ?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

// Row containing checkboxes for Vegetarian and Non-Vegetarian
                    Row(
                      children: [
                        // Veg checkbox
                        Text("Veg"),
                        Checkbox(
                          value: controller.isVegetarian,
                          onChanged: (value) {
                            setState(() {
                              controller.isVegetarian = value!;
                              if (value == true ||
                                  controller.isNonVegetarian ||
                                  controller.isVegan) {
                                controller.isButtonEnabled = true;
                              } else {
                                controller.isButtonEnabled = false;
                              }
                            });
                          },
                          activeColor: controller.isVegetarian
                              ? Colors.green
                              : null, // Set color to green if selected
                        ),

                        // Non-Veg checkbox
                        Text("Non-Veg"),
                        Checkbox(
                          value: controller.isNonVegetarian,
                          onChanged: (value) {
                            setState(() {
                              controller.isNonVegetarian = value!;
                              if (value == true ||
                                  controller.isVegetarian ||
                                  controller.isVegan) {
                                controller.isButtonEnabled = true;
                              } else {
                                controller.isButtonEnabled = false;
                              }
                            });
                          },
                          activeColor: controller.isNonVegetarian
                              ? Colors.red
                              : null, // Set color to red if selected
                        ),

                        Text("Vegan"),
                        Checkbox(
                          value: controller.isVegan,
                          onChanged: (value) {
                            setState(() {
                              controller.isVegan = value!;
                              if (value == true ||
                                  controller.isVegetarian ||
                                  controller.isNonVegetarian) {
                                controller.isButtonEnabled = true;
                              } else {
                                controller.isButtonEnabled = false;
                              }
                            });
                          },
                          activeColor: controller.isVegan
                              ? kPrimary
                              : null, // Set color to red if selected
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.w),
                      child: controller.isButtonEnabled
                          ? CustomGradientButton(
                              onPress: () => controller.updateUserProfile(),
                              text: "Done")
                          : Container(
                              height: 45.h,
                              width: 320.w,
                              decoration: BoxDecoration(
                                color: kLightWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Done",
                                  style: appStyle(16, kDark, FontWeight.w500),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
