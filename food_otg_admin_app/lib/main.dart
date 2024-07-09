import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/views/splash/splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //run for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCOOlOFUsiUSB2ILt-49xl7ztUPCGWnKMc",
        authDomain: "food-otg-service-app.firebaseapp.com",
        projectId: "food-otg-service-app",
        storageBucket: "food-otg-service-app.appspot.com",
        messagingSenderId: "798843974680",
        appId: "1:798843974680:web:ac2d5119735d37a626ff6d",
        measurementId: "G-Z5LSXHV2GZ",
      ),
    );
  } else {
    //run for android
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodOTG Admin',
      theme: ThemeData(
        useMaterial3: true,
        iconTheme: const IconThemeData(color: kWhite),
        appBarTheme: const AppBarTheme(
          backgroundColor: kDark,
          iconTheme: IconThemeData(color: kSecondary),
          titleTextStyle: TextStyle(color: kSecondary, fontSize: 20),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
