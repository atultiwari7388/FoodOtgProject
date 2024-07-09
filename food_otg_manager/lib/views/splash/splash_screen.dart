import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager/constants/constants.dart';
import 'package:food_otg_manager/views/auth/email_authentication.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      if (user != null) {
        Get.offAll(() => DashboardScreen(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 900));
        log("User is authenticated");
      } else {
        Get.offAll(() => EmailAuthenticationScreen(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 900));
        log("User is null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              "assets/logo.png",
              height: 250.h,
              fit: BoxFit.cover,
            )),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
