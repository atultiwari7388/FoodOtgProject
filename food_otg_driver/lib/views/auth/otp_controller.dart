import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../controllers/authentication_controller.dart';
import '../../utils/app_style.dart';
import '../../utils/toast_msg.dart';

class OtpAuthenticationScreen extends StatefulWidget {
  const OtpAuthenticationScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<OtpAuthenticationScreen> createState() =>
      _OtpAuthenticationScreenState();
}

class _OtpAuthenticationScreenState extends State<OtpAuthenticationScreen>
    with CodeAutoFill {
  AuthenticationController controller = Get.find<AuthenticationController>();

  @override
  void initState() {
    super.initState();
    listenForCode(); // Start listening for OTP
    log("Listening for code with CodeAutoFill");
  }

  @override
  void codeUpdated() {
    setState(() {
      controller.otpController.text = code!;
    });
    log("Auto-filled OTP: $code");

    // Delay the call to signInWithPhoneNumber to ensure the OTP is fully entered
    Future.delayed(Duration(milliseconds: 500), () {
      if (controller.otpController.text.length == 6) {
        controller.signInWithPhoneNumber(
            context, controller.otpController.text);
      } else {
        log("OTP is not valid yet.");
      }
    });
  }

  @override
  void dispose() {
    cancel(); // Stop listening for OTP when the widget is disposed
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
        body: Column(
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
                child: PinFieldAutoFill(
                  controller: controller.otpController,
                  currentCode: controller.otpController.text,
                  onCodeChanged: (val) {
                    log("OTP Value entered: $val");
                  },
                  codeLength: 6,
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: kDark),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
        ),
      ),
    );
  }
}




// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import '../../common/reusable_text.dart';
// import '../../constants/constants.dart';
// import '../../controllers/authentication_controller.dart';
// import '../../utils/app_style.dart';

// class OtpAuthenticationScreen extends StatelessWidget {
//   const OtpAuthenticationScreen({super.key, required this.verificationId});

//   final String verificationId;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     AuthenticationController controller = Get.find<AuthenticationController>();
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: kLightWhite,
//         appBar: AppBar(
//           backgroundColor: kWhite,
//           iconTheme: IconThemeData(color: kPrimary),
//           title: ReusableText(
//             text: "OTP Verification",
//             style: appStyle(20, kDark, FontWeight.normal),
//           ),
//           elevation: 0,
//         ),
//         body: Container(
//           // color: kWhite,
//           child: Container(
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: size.height * .04,
//                 ),
//                 Text("We have sent a verification code to",
//                     style: appStyle(14, kDark, FontWeight.normal)),
//                 SizedBox(height: 5.h),
//                 Text(" +91${controller.phoneController.text.toString()}",
//                     style: appStyle(14, kDark, FontWeight.bold)),
//                 SizedBox(height: 20),
//                 Center(
//                   child: SizedBox(
//                     height: size.height / 18,
//                     width: size.width / 1.2,
//                     child: PinCodeTextField(
//                       appContext: context,
//                       controller: controller.otpController,
//                       length: 6,
//                       onChanged: (val) {
//                         log("Otp Value $val");
//                       },
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(18),
//                         fieldHeight: size.height / 19,
//                         fieldWidth: size.width / 8,
//                       ),
//                       keyboardType: TextInputType.number,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       onCompleted: (otp) {
//                         controller.otpController.text = otp;
//                         controller.signInWithPhoneNumber(context, otp);
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 50.h),
//                 Spacer(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
