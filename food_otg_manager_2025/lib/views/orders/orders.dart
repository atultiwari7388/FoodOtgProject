import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg_manager_2025/utils/distance_calculation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../services/collection_refrences.dart';
import '../../utils/app_style.dart';
import 'components/order_history_component.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.setTab});
  final Function? setTab;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late Stream<QuerySnapshot> ordersStream;
  String? restaurantAddress;
  String? restId;
  GeoPoint? location;
  var logger = Logger();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabsController;

  Future<void> fetchRestaurantLocation() async {
    try {
      String managerId = currentUId;
      log("Manager ID: $managerId");
      DocumentSnapshot managerSnapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(managerId)
          .get();

      // Extract the restaurant ID from the manager document
      String restaurantId = managerSnapshot.get('resId');
      log("Restaurant ID: $restaurantId");

      // Fetch the restaurant details from the Restaurants collection using the restaurantId
      DocumentSnapshot restaurantSnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(restaurantId)
          .get();

      // Extract the locationLatLng from the restaurant document
      location = restaurantSnapshot.get('locationLatLng');
      log("Location: $location");

      // Convert the latitude and longitude to human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
          location!.latitude, location!.longitude);
      log(placemarks[0].administrativeArea.toString());
      log(location!.latitude.toString());
      log(location!.longitude.toString());
      if (placemarks.isNotEmpty) {
        setState(() {
          restaurantAddress =
              "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";

          restId = restaurantId;
          log("Restaurant Address: $restaurantAddress");
          log("Restaurant Id: $restId");
        });
      }
    } catch (error) {
      if (error is PlatformException &&
          error.code == 'io.grpc.Status.DEADLINE_EXCEEDED') {
        // Retry the operation or show an error message to the user
        log('Timeout error: $error');
      } else {
        // Handle other types of errors
        log("Error fetching restaurant location: $error");
      }
    }
  }

  void switchTab(int index) {
    _tabsController.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchRestaurantLocation();
    _tabsController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kLightWhite,
          title: ReusableText(
            text: "Orders",
            style: appStyle(20, kSecondary, FontWeight.bold),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('restId', arrayContains: restId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: kPrimary,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ReusableText(
                      text: "No orders found",
                      style: appStyle(20, kSecondary, FontWeight.bold),
                    ),
                  ],
                ),
              );
            }
            // Filter orders based on status
            List<Map<String, dynamic>> newOrders = [];
            List<Map<String, dynamic>> ongoingOrders = [];
            List<Map<String, dynamic>> completedOrders = [];

            // Extract orders data from the snapshot
            List<Map<String, dynamic>> orders = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            // Filter orders based on status
            newOrders = orders.where((order) => order['status'] == 0).toList();
            ongoingOrders = orders
                .where((order) => order['status'] >= 1 && order['status'] <= 4)
                .toList();
            completedOrders =
                orders.where((order) => order['status'] == 5).toList();

            return Column(
              children: [
                TabBar(
                  controller: _tabsController,
                  labelColor: kSecondary,
                  unselectedLabelColor: kGray,
                  tabAlignment: TabAlignment.center,
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  labelStyle: appStyle(16, kDark, FontWeight.normal),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 2.w, color: kSecondary), // Set your color here
                    insets: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  tabs: const [
                    Tab(text: "New"),
                    Tab(text: "Ongoing"),
                    Tab(text: "Complete/Cancel"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabsController,
                    children: [
                      _buildOrdersList(newOrders, 0),
                      _buildOrdersList(ongoingOrders, 1),
                      _buildOrdersList(completedOrders, 2),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, int status) {
    // Get the search query from the text controller
    final searchQuery = searchController.text.toLowerCase();

    // Filter orders based on orderId containing the search query
    final filteredOrders = orders.where((order) {
      final orderId = order["orderId"].toLowerCase();
      return orderId.contains(searchQuery);
    }).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          //filter and search bar section
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(child: buildTopSearchBar()),
                SizedBox(width: 5.w),
                FilterChip(
                    label: Icon(Icons.calendar_month, color: kSecondary),
                    onSelected: (value) {})
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            itemBuilder: (ctx, index) {
              final order = filteredOrders[index];
              final orderId = order["orderId"];
              final locationAddress = order["userDeliveryAddress"];
              final orderItems = order["orderItems"];
              final totalPrice = order["totalBill"];
              final userId = order["userId"];
              final status = order["status"];
              final double userLat = order["userLat"];
              final double userLong = order["userLong"];
              final orderDate = DateTime.fromMillisecondsSinceEpoch(
                  order['orderDate'].millisecondsSinceEpoch);

              if (location != null) {
                double distance = calculateDistance(
                    userLat, userLong, location!.latitude, location!.longitude);
                logger.d("Total distance: " + distance.toString() + " km");

                if (distance <= 5) {
                  return HistoryScreenItems(
                    orderId: orderId,
                    location: locationAddress,
                    totalPrice: totalPrice,
                    userId: userId,
                    status: status,
                    userLat: userLat,
                    userLong: userLong,
                    orderItems: orderItems,
                    switchTab: (index) => switchTab(index),
                    orderDate: orderDate,
                  );
                } else {
                  return SizedBox();
                }
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

/**-------------------------- Build Top Search Bar ----------------------------------**/
  Widget buildTopSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.h),
          border: Border.all(color: kGrayLight),
          boxShadow: [
            BoxShadow(
              color: kLightWhite,
              spreadRadius: 0.2,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search by #FOTG00001",
              prefixIcon: Icon(Icons.search),
              prefixStyle: appStyle(14, kDark, FontWeight.w200)),
        ),
      ),
    );
  }
}
