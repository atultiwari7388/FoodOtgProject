import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager/common/custom_gradient_button.dart';
import 'package:food_otg_manager/controllers/email_authentication_controller.dart';
import 'package:food_otg_manager/utils/app_style.dart';
import 'package:food_otg_manager/utils/toast_msg.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';

class EmailAuthenticationScreen extends StatelessWidget {
  const EmailAuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GetBuilder<EmailAuthenticationController>(
        init: EmailAuthenticationController(),
        builder: (controller) {
          if (!controller.isLoading) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image or App Logo
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/login_bg.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // phone auth and login section
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Heading
                        SizedBox(height: 7.h),
                        Text("Welcome to FOODOTG\n  MANAGER",
                            textAlign: TextAlign.center,
                            style: appStyle(18, kDark, FontWeight.bold)),
                        // Login or Signup Text
                        SizedBox(height: 7.h),
                        // Login or Signup Text
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Center the children horizontally
                            children: [
                              Expanded(
                                child: Divider(), // Divider on the left
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                // Adjust the padding as needed
                                child: Text(
                                  "Login ",
                                  textAlign: TextAlign.center,
                                  style: appStyle(14, kGray, FontWeight.w400),
                                ),
                              ),
                              Expanded(
                                child: Divider(), // Divider on the right
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimary), // Border color
                          ),
                          child: TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter email address",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimary), // Border color
                          ),
                          child: TextFormField(
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter password",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
                        CustomGradientButton(
                          w: 320.w,
                          h: 45.h,
                          text: "Continue",
                          onPress: () {
                            String email =
                                controller.emailController.text.trim();
                            String password =
                                controller.passwordController.text.trim();

                            if (email.length >= 6 && password.length >= 6) {
                              controller.verifyEmailAndPassword();
                            } else {
                              showToastMessage(
                                  "Error",
                                  "Email and password must be at least 6 characters long.",
                                  kRed);
                            }
                          },
                        ),

                        Spacer(),
                        SizedBox(
                          width: 260.w,
                          child: Text(
                              "By Continuing , you agree to our Terms of Service Privacy Policy Content Policy.",
                              textAlign: TextAlign.center,
                              style: appStyle(10, kGray, FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
