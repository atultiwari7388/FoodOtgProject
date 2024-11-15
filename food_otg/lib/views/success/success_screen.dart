import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_otg/constants/constants.dart';
import 'package:food_otg/views/entry_point.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Vibration.vibrate(duration: 1000); // Vibrate for 1 second
    // Start a timer to automatically redirect after 3 seconds
    Timer(Duration(seconds: 5), () {
      Get.offAll(() => DashboardScreen(),
          transition: Transition.fade, arguments: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Image.asset(
              'assets/new_order_placed.gif',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:food_otg/common/custom_gradient_button.dart';
// import 'package:food_otg/constants/constants.dart';
// import 'package:food_otg/utils/app_styles.dart';
// import 'package:food_otg/views/entry_point.dart';
// import 'package:get/get.dart';
// import 'package:vibration/vibration.dart'; // Import for vibrating device

// class SuccessScreen extends StatefulWidget {
//   const SuccessScreen({Key? key}) : super(key: key);

//   @override
//   State<SuccessScreen> createState() => _SuccessScreenState();
// }

// class _SuccessScreenState extends State<SuccessScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Vibration.vibrate(duration: 1000); // Vibrate for 1 second
//     // Start a timer to automatically redirect after 3 seconds
//     Timer(Duration(seconds: 3), () {
//       Get.offAll(() => DashboardScreen(),
//           transition: Transition.fade, arguments: 1);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhite,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle,
//               color: Colors.green,
//               size: 100.h,
//             ),
//             SizedBox(height: 20),
//             Text('Order Successful!',
//                 style: appStyle(24, kDark, FontWeight.normal)),
//             SizedBox(height: 20.h),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Ordered Food',
//                     textAlign: TextAlign.center,
//                     style: appStyle(18, kDark, FontWeight.normal),
//                   ),
//                   SizedBox(height: 5),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30.h),
//             CustomGradientButton(
//               text: "Back to History",
//               onPress: () {
//                 Get.offAll(() => DashboardScreen(),
//                     transition: Transition.fade, arguments: 1);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

