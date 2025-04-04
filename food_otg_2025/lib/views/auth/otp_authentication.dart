import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_2025/utils/app_styles.dart';
import 'package:get/get.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../controllers/authentication_controller.dart';
import '../../utils/toast_msg.dart';

class OtpAuthenticationScreen extends StatefulWidget {
  const OtpAuthenticationScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<OtpAuthenticationScreen> createState() =>
      _OtpAuthenticationScreenState();
}

class _OtpAuthenticationScreenState extends State<OtpAuthenticationScreen> {
  final AuthenticationController controller =
      Get.find<AuthenticationController>();
  // final Telephony telephony = Telephony.instance;
  Timer? _timer;
  bool _codeReceived = false;

  @override
  void initState() {
    super.initState();
    // _listenOtp();
    // Set a timeout for OTP auto-fill
    _timer = Timer(const Duration(seconds: 60), () {
      if (!_codeReceived) {
        log("SMS listener timeout after 60 seconds");
      }
    });
  }

  // Future<void> _listenOtp() async {
  //   try {
  //     bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  //     if (permissionsGranted ?? false) {
  //       telephony.listenIncomingSms(
  //         onNewMessage: (SmsMessage message) {
  //           String messageBody = message.body ?? '';
  //           log("New SMS received: $messageBody");
  //           _extractAndProcessOtp(messageBody);
  //         },
  //         listenInBackground: false,
  //       );
  //       log("Started listening for SMS");
  //     }
  //   } catch (e) {
  //     log("Error in OTP listener: $e");
  //   }
  // }

  void _extractAndProcessOtp(String message) {
    // Extract 6 digit code using regex
    final RegExp regExp = RegExp(r'\d{6}');
    final match = regExp.firstMatch(message);

    if (match != null) {
      final extractedCode = match.group(0);
      log("Extracted 6-digit code: $extractedCode");

      if (mounted && extractedCode != null) {
        setState(() {
          _codeReceived = true;
          controller.otpController.text = extractedCode;
        });

        // Auto verify after short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          controller.signInWithPhoneNumber(context, extractedCode);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kLightWhite,
        appBar: AppBar(
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kPrimary),
          title: ReusableText(
            text: "OTP Verification",
            style: appStyle(20, kDark, FontWeight.normal),
          ),
          elevation: 0,
        ),
        body: GetBuilder<AuthenticationController>(builder: (controller) {
          return Column(
            children: [
              SizedBox(height: size.height * .04),
              Text(
                "We have sent a verification code to",
                style: appStyle(14, kDark, FontWeight.normal),
              ),
              SizedBox(height: 5.h),
              Text(
                "+91${controller.phoneController.text}",
                style: appStyle(14, kDark, FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: size.height / 18,
                  width: size.width / 1.2,
                  child: TextField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter OTP",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) {
                      if (val.length == 6) {
                        log("Valid length OTP entered manually");
                        controller.signInWithPhoneNumber(context, val);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (controller.isVerification)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    final otp = controller.otpController.text;
                    if (otp.length == 6) {
                      log("Manually verifying OTP: $otp");
                      controller.signInWithPhoneNumber(context, otp);
                    } else {
                      showToastMessage(
                        "Error",
                        "Please enter a valid 6-digit OTP.",
                        Colors.red,
                      );
                    }
                  },
                  child: Text("Verify"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: kWhite,
                    minimumSize: Size(size.width / 1.5, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              Spacer(),
            ],
          );
        }),
      ),
    );
  }
}



// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:food_otg_2025/common/reusable_text.dart';
// import 'package:food_otg_2025/constants/constants.dart';
// import 'package:food_otg_2025/controllers/authentication_controller.dart';
// import 'package:food_otg_2025/utils/app_styles.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class OtpAuthenticationScreen extends StatefulWidget {
//   const OtpAuthenticationScreen({super.key, required this.verificationId});

//   final String verificationId;

//   @override
//   State<OtpAuthenticationScreen> createState() =>
//       _OtpAuthenticationScreenState();
// }

// class _OtpAuthenticationScreenState extends State<OtpAuthenticationScreen> {







//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     AuthenticationController controller = Get.find<AuthenticationController>();
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: kLightWhite,
//         appBar: AppBar(),
//         body: controller.isVerification
//             ? Center(
//                 child: Image.asset(
//                   "assets/login_out_deliver.gif",
//                   // repeat: true,
//                   height: MediaQuery.of(context).size.height,
//                   width: double.maxFinite,
//                   // color: Colors.transparent,
//                   fit: BoxFit.cover,
//                 ),
//               )
//             : Container(
//                 padding: EdgeInsets.all(12),
//                 margin: EdgeInsets.only(left: 10, right: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: size.height * .2),
//                     Center(
//                       child: ReusableText(
//                         text: "OTP Verification",
//                         style: appStyle(20, kDark, FontWeight.normal),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Center(
//                       child: Text("We have sent a verification code to",
//                           style: appStyle(14, kDark, FontWeight.normal)),
//                     ),
//                     SizedBox(height: 5.h),
//                     Center(
//                       child: Text(
//                           " +91${controller.phoneController.text.toString()}",
//                           style: appStyle(14, kDark, FontWeight.bold)),
//                     ),
//                     SizedBox(height: 20.h),
//                     Center(
//                       child: SizedBox(
//                         height: size.height / 18,
//                         width: size.width / 1.2,
//                         child: PinCodeTextField(
//                           appContext: context,
//                           controller: controller.otpController,
//                           length: 6,
//                           onChanged: (val) {
//                             log("Otp Value $val");
//                           },
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             borderRadius: BorderRadius.circular(18),
//                             fieldHeight: size.height / 19,
//                             fieldWidth: size.width / 8,
//                           ),
//                           keyboardType: TextInputType.number,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           onCompleted: (otp) {
//                             controller.otpController.text = otp;
//                             controller.signInWithPhoneNumber(context, otp);
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 50.h),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
