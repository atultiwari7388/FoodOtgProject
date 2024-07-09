import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/views/anniversary_dob/anniversary_and_dob.dart';
import 'package:food_otg_admin_app/views/categories/categories.dart';
import 'package:food_otg_admin_app/views/driverCommission/driver_commission_screen.dart';
import 'package:food_otg_admin_app/views/manageBanners/manage_banners.dart';
import 'package:food_otg_admin_app/views/manageCoupons/manage_coupons.dart';
import 'package:food_otg_admin_app/views/manageCustomer/manage_customer.dart';
import 'package:food_otg_admin_app/views/manageDrivers/manage_drivers.dart';
import 'package:food_otg_admin_app/views/manageItems/manage_items.dart';
import 'package:food_otg_admin_app/views/manageManager/manage_managers.dart';
import 'package:food_otg_admin_app/views/manageOrders/manage_orders.dart';
import 'package:food_otg_admin_app/views/managePayments/manage_payments.dart';
import 'package:food_otg_admin_app/views/manageRestaurant/manage_restaurant.dart';
import 'package:food_otg_admin_app/views/subCategory/sub_category_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/analysis_boxes_widget.dart';
import '../../common/custom_text_widget.dart';
import '../../constants/constants.dart';
import '../../services/firebase_database_services.dart';
import '../../services/firebase_services.dart';
import '../manageDrivers2Screen/manage_drivers_2_screeen.dart';

class AppSideAdminDashBoardScreen extends StatefulWidget {
  const AppSideAdminDashBoardScreen({super.key});

  @override
  State<AppSideAdminDashBoardScreen> createState() =>
      _AppSideAdminDashBoardScreenState();
}

class _AppSideAdminDashBoardScreenState
    extends State<AppSideAdminDashBoardScreen> {
  String formatDateWithTimeStamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return dateFormat.format(dateTime);
  }

  Widget buildAnalysisBox({
    required Stream<QuerySnapshot> stream,
    required String firstText,
    required IconData icon,
    Color containerColor = kPrimary,
    required onTap,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          int count = documents.length;

          return InkWell(
            onTap: onTap,
            child: AnalysisBoxesWidgets(
              containerColor: containerColor,
              firstText: firstText,
              secondText: count.toString(),
              icon: icon,
            ),
          );
        } else {
          return Container(); // Placeholder widget for error or no data
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Back Admin"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: kDarkGray,
                ),
                child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                // child: Text('FoodOTG-Admin',
                //     style: appStyle(24, kSecondary, FontWeight.normal)),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.hotel, color: kSecondary),
                title: const Text('Manage Restaurants'),
                onTap: () {
                  Get.to(() => const ManageRestaurantScreen());
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.person, color: kSecondary),
                title: Text('Manage Managers'),
                onTap: () {
                  Get.to(() => const ManageManagerScreen());
                  // Handle Orders tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: kSecondary),
                title: Text('Categories'),
                onTap: () {
                  Get.to(() => const CategoriesScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: kSecondary),
                title: Text('Sub-Categories'),
                onTap: () {
                  Get.to(() => const SubCategoriesScreen());

                  // Handle Orders tap
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.list, color: kSecondary),
                title: const Text('Manage Items'),
                onTap: () {
                  Get.to(() => const ManageItemsScreen());
                  // Handle Orders tap
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: kSecondary),
                title: Text('Manage Orders'),
                onTap: () {
                  Get.to(() => const ManageOrdersScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.airplane_ticket_outlined,
                    color: kSecondary),
                title: Text('Manage Coupons'),
                onTap: () {
                  Get.to(() => const ManageCouponsScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_bike, color: kSecondary),
                title: Text('Manage Drivers'),
                onTap: () {
                  Get.to(() => const ManageDriversScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_bike, color: kSecondary),
                title: Text('Manage Drivers 2'),
                onTap: () {
                  Get.to(() => const ManageDriversSecondScreenTesting());
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: kSecondary),
                title: Text('Manage Customers'),
                onTap: () {
                  Get.to(() => const ManageCustomersScreen());
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.bookmark_add_rounded, color: kSecondary),
                title: const Text('Manage Banners'),
                onTap: () {
                  Get.to(() => const ManageBanners());
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.indianRupeeSign,
                    color: kSecondary),
                title: Text('Manage Payments'),
                onTap: () {
                  Get.to(() => ManagePaymentsScreen());
                  // Handle Orders tap
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.birthdayCake,
                    color: kSecondary),
                title: Text('Anniversary and Birthday'),
                onTap: () {
                  Get.to(() => BirthdayAnniversaryScreen());
                },
              ),
              // ListTile(
              //   leading: const Icon(FontAwesomeIcons.circle, color: kSecondary),
              //   title: Text('Settings'),
              //   onTap: () {
              //     Get.to(() => DriverCommissionTypeScreen());
              //   },
              // ),
              // SizedBox(height: 70.h),
              // InkWell(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (ctx) => AlertDialog(
              //         title: const Text("Logout"),
              //         content: const Text("Are you sure you want to Logout."),
              //         actions: <Widget>[
              //           TextButton(
              //             onPressed: () => Navigator.pop(context),
              //             child: Text("No",
              //                 style: appStyle(16, kRed, FontWeight.normal)),
              //           ),
              //           TextButton(
              //             onPressed: () => FirebaseServices().signOut(context),
              //             child: Text("Yes",
              //                 style: appStyle(
              //                     16, Colors.green, FontWeight.normal)),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              //   child: const Row(
              //     children: [
              //       CustomTextWidget(
              //         text: "LogOut",
              //         color: kSecondary,
              //       ),
              //       SizedBox(width: 10),
              //       FaIcon(FontAwesomeIcons.arrowRightFromBracket,
              //           color: kWhite),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        body: buildBodySectionCode());
  }

  Container buildBodySectionCode() {
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 3.5,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            shrinkWrap: true,
            padding: const EdgeInsets.all(2),
            children: [
              // Total Appointments
              buildAnalysisBox(
                onTap: () {
                  Get.to(() => const ManageCustomersScreen());
                },
                stream: FirebaseDatabaseServices().usersList,
                firstText: "Total Customers",
                icon: FontAwesomeIcons.users,
                containerColor: Colors.blue,
              ),
// //================== Total Driver =================================
              buildAnalysisBox(
                onTap: () {
                  Get.to(() => const ManageOrdersScreen());
                },
                stream: FirebaseDatabaseServices().ordersList,
                firstText: "Total Orders",
                icon: FontAwesomeIcons.list,
                containerColor: Colors.green,
              ),
// //================== Total Booking ===============================
              buildAnalysisBox(
                onTap: () {
                  Get.to(() => const ManageOrdersScreen());
                },
                stream: FirebaseDatabaseServices().pendingOrdersList,
                firstText: "Pending Orders",
                icon: FontAwesomeIcons.clipboardList,
                containerColor: Colors.red,
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
