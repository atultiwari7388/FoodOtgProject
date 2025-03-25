import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_driver_2025/views/adminReview/admin_review.dart';
import 'package:get/get.dart';
import '../utils/toast_msg.dart';
import '../views/auth/otp_controller.dart';
import '../views/auth/personal_details_screen.dart';
import '../views/auth/phone_authentication_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthenticationController extends GetxController {
  //create firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String vid = "";
  bool isLoading = false;
  bool isVerification = false;

  //================ check for state auth changes  ================
  Stream<User?> get authChanges => _auth.authStateChanges();

  //================ all the users data ================
  User get user => _auth.currentUser!;

  //crate a function for verify phone
  void verifyPhoneNumber() async {
    try {
      isLoading = true;
      update();

      // Get app signature for SMS auto-fill
      final appSignature = await SmsAutoFill().getAppSignature;
      log("App Signature: $appSignature");

      await _auth.verifyPhoneNumber(
          phoneNumber: "+91${phoneController.text}",
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieve the SMS code
            log("Auto retrieving verification code");

            // Sign in when OTP is automatically detected
            await _auth.signInWithCredential(credential);
            isVerification = false;
            update();
          },
          timeout: const Duration(seconds: 120),
          verificationFailed: (FirebaseAuthException exception) {
            if (exception.code == 'invalid-phone-number') {
              showToastMessage("Error", "Invalid Phone number", Colors.red);
            }
            log(exception.toString());
          },
          codeSent: (String _verificationId, int? forcedRespondToken) {
            vid = _verificationId;
            log("Verification ID: $vid");
            isLoading = false;
            update();

            // Use phone_authentication_screen.dart version to avoid conflict
            Get.to(() => OtpAuthenticationScreen(verificationId: vid));

            isLoading = false;
            update();
          },
          codeAutoRetrievalTimeout: (String e) {
            log("Time out Error $e");
            return null;
          });
    } catch (e) {
      isLoading = false;
      update();
      showToastMessage("Error", e.toString(), Colors.red);
    }
  }

  //for sign in
  void signInWithPhoneNumber(BuildContext context, String otp) async {
    isVerification = true;
    update();
    final PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(
      verificationId: vid,
      smsCode: otp,
    );
    try {
      //for signIn with credential
      var signInUser = await _auth.signInWithCredential(phoneAuthCredential);

      print(signInUser);

      final User? user = signInUser.user;
      if (user != null) {
        isVerification = false;
        update();
        if (signInUser.additionalUserInfo!.isNewUser) {
          //add the data to firebase or move to complete your profile screen
          Get.offAll(() => const PersonalDetailsScreen(),
              transition: Transition.leftToRightWithFade,
              duration: const Duration(seconds: 2));
        } else {
          final doc =
              await FirebaseFirestore.instance.doc("Drivers/${user.uid}").get();
          if (doc.exists) {
            if (doc["approved"] == true) {
              log("Go to Dashboard Screen");
              Get.offAll(() => DashboardScreen(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 900));
              log("User is authenticated");
            } else if (doc["approved"] == false) {
              log("go to admin review screen");
              //send to admin review screen
              Get.offAll(() => AdminReviewScreen());
            } else {
              Get.offAll(() => const PhoneAuthenticationScreen());
            }
          } else {
            Get.offAll(() => PhoneAuthenticationScreen());
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        isVerification = false;
        update();
        showToastMessage(
            "Error", "Invalid OTP. Enter correct OTP.", Colors.red);
        await _auth.signOut().then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const PhoneAuthenticationScreen()),
              (route) => false);
        });
      }
    }
  }

  //====================== signOut from app =====================
  void signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PhoneAuthenticationScreen()),
          (route) => false);
    } catch (e) {
      showToastMessage("Error", e.toString(), Colors.red);
    }
  }
}
