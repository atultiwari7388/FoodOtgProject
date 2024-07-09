import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_otg_manager/views/homeDashboard/home_dashboard_screen.dart';
import 'package:food_otg_manager/views/items/items_screen.dart';
import 'package:food_otg_manager/views/orders/orders.dart';
import '../../constants/constants.dart';
import '../../utils/app_style.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int tab = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // PushNotification().init();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = false;
      });
    } // Optionally handle the else case where the user is null
  }

  void setTab(int index) {
    setState(() {
      tab = index;
    });
  }

  final GlobalKey<ScaffoldState> _myGlobe = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeDashboardScreen(setTab: setTab),
      OrdersScreen(setTab: setTab),
      ItemsScreen()
      // ProfileScreen(),
    ];

    return Scaffold(
      key: _myGlobe,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: tab,
              children: screens,
            ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        items: [
          BottomNavigationBarItem(
              icon: Icon(AntDesign.home), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(AntDesign.shoppingcart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(AntDesign.book), label: "Items"),
        ],
        currentIndex: tab,
        selectedItemColor: kSecondary,
        selectedLabelStyle: appStyle(12, kSecondary, FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            tab = index;
          });
        },
      ),
    );
  }
}
