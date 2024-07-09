import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_otg_manager/constants/constants.dart';
import 'package:food_otg_manager/views/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import '../utils/toast_msg.dart';

class EmailAuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void verifyEmailAndPassword() async {
    try {
      isLoading = true;
      update();

      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        isLoading = false;
        update();
        if (value.user != null) {
          log(value.user.toString());
          Get.offAll(() => DashboardScreen(),
              transition: Transition.cupertino,
              duration: const Duration(milliseconds: 900));
        } else {
          Get.snackbar(
            'Error',
            'Invalid Email or Password',
            backgroundColor: kRed,
            duration: Duration(seconds: 2),
          );
        }
        isLoading = false;
        update();
      }).onError((error, stackTrace) {
        isLoading = false;
        update();
        Get.snackbar(
          'Error',
          error.toString(),
          backgroundColor: kRed,
          duration: Duration(seconds: 2),
        );
      });
    } catch (e) {
      isLoading = false;
      update();
      showToastMessage("Error", e.toString(), kRed);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
