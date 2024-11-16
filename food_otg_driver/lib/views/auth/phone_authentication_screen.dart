import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/custom_gradient_button.dart';
import '../../constants/constants.dart';
import '../../controllers/authentication_controller.dart';
import '../../utils/app_style.dart';
import '../../utils/toast_msg.dart';
import 'dart:async';
import 'dart:developer';
import 'package:another_telephony/telephony.dart';
import '../../common/reusable_text.dart';

class PhoneAuthenticationScreen extends StatefulWidget {
  const PhoneAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthenticationScreen> createState() =>
      _PhoneAuthenticationScreenState();
}

class _PhoneAuthenticationScreenState extends State<PhoneAuthenticationScreen> {
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
  }

  Future<void> _getPhoneNumber() async {
    try {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      if (permissionsGranted ?? false) {
        final controller = Get.find<AuthenticationController>();
        // Use telephony.dialNumber() instead of getSimStateData
        await telephony.openDialer(""); // Opens dialer without number
        // Note: We can't directly get phone number due to platform limitations
        // User will need to enter number manually
      }
    } catch (e) {
      log("Error getting phone number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GetBuilder<AuthenticationController>(
        init: AuthenticationController(),
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
                        SizedBox(height: 7.h),
                        Text("Welcome to FOODOTG\n Driver",
                            textAlign: TextAlign.center,
                            style: appStyle(19, kDark, FontWeight.bold)),
                        SizedBox(height: 7.h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Login or Signup",
                                  textAlign: TextAlign.center,
                                  style: appStyle(14, kGray, FontWeight.w400),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: kGrayLight),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: kOffWhite),
                                child: Container(
                                  padding:
                                      EdgeInsets.only(left: 4.w, right: 7.w),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/india.png",
                                    width: 40.w,
                                    height: 40.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.h),
                                      border: Border.all(color: kGray),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: controller.phoneController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: "  Enter your phone number",
                                          prefixText: " ",
                                          prefixStyle: appStyle(
                                              14, kDark, FontWeight.w200)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomGradientButton(
                            text: "Continue",
                            onPress: () async {
                              if (controller.phoneController.text.length ==
                                  10) {
                                controller.verifyPhoneNumber();
                              } else {
                                showToastMessage(
                                  "Error",
                                  "Please enter a valid 10-digit number",
                                  Colors.red,
                                );
                              }
                            },
                            h: 45.h,
                            w: 350.w),
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
