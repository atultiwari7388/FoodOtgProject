import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/views/adminHome/admin_home_screen.dart';
import 'package:food_otg_admin_app/views/appSideAdminCode/dashboard_screen.dart';
import 'package:food_otg_admin_app/views/auth/authentication_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // Add a delay of 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Check if user is already logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.email == "adminmylex@gmail.com") {
        _navigateToAdminScreen();
      } else {
        _navigateToDashboardScreen();
      }
    } else {
      _navigateToAuthScreen();
    }
  }

  void _navigateToAdminScreen() {
    if (kIsWeb) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppSideAdminDashBoardScreen()),
      );
    }
  }

  void _navigateToDashboardScreen() {
    if (kIsWeb) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppSideAdminDashBoardScreen()),
      );
    }
  }

  void _navigateToAuthScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget while waiting for initialization
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:food_otg_admin_app/views/adminHome/admin_home_screen.dart';
// import 'package:food_otg_admin_app/views/appSideAdminCode/dashboard_screen.dart';
// import 'package:food_otg_admin_app/views/auth/authentication_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     if (auth.currentUser != null) {
//       if (auth.currentUser!.email == "adminmylex@gmail.com") {
//         return kIsWeb
//             ? const AdminHomeScreen()
//             : const AppSideAdminDashBoardScreen();
//       } else {
//         return kIsWeb
//             ? const AdminHomeScreen()
//             : const AppSideAdminDashBoardScreen();
//       }
//     } else {
//       return const AuthenticationScreen();
//     }
//   }
// }
