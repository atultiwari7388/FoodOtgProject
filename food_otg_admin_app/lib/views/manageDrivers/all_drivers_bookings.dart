import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../utils/appStyle.dart';
import '../manageOrders/orders_details_screen.dart';

class ViewAllDriversOrders extends StatefulWidget {
  const ViewAllDriversOrders(
      {super.key, required this.driverId, required this.driverName});

  final String driverId;
  final String driverName;

  @override
  State<ViewAllDriversOrders> createState() => _ViewAllDriversOrdersState();
}

class _ViewAllDriversOrdersState extends State<ViewAllDriversOrders> {
  // bool isLoading = true;
  late Stream<List<DocumentSnapshot>> _ordersStream;
  final TextEditingController searchController = TextEditingController();

  int _perPage = 10;
  int _currentPage = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _ordersStream = _getOrdersStream();
  }

  Stream<List<DocumentSnapshot>> _getOrdersStream() {
    Query query = FirebaseFirestore.instance
        .collection("orders")
        .where("driverId", isEqualTo: widget.driverId);

    // Apply orderBy and where clauses based on search text
    if (searchController.text.isNotEmpty) {
      query = query
          .orderBy("orderId")
          .where("orderId",
              isGreaterThanOrEqualTo: "#${searchController.text.toString()}")
          .where("orderId",
              isLessThanOrEqualTo:
                  "#${searchController.text.toString()}\uf8ff");
    } else {
      query = query.orderBy("orderDate", descending: true);
    }

    // Apply date range filter if both dates are selected
    if (_startDate != null && _endDate != null) {
      query = query
          .where("orderDate", isGreaterThanOrEqualTo: _startDate)
          .where("orderDate",
              isLessThanOrEqualTo:
                  _endDate!.add(const Duration(days: 1))); // include end date
    }

    return query.limit(_perPage).snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null &&
        picked !=
            DateTimeRange(
                start: _startDate ?? DateTime.now(),
                end: _endDate ?? DateTime.now())) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _ordersStream = _getOrdersStream(); // Update the stream
      });
    }
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _perPage += 10;
      _ordersStream = _getOrdersStream();
      log(_currentPage.toString());
      log(_perPage.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.driverName}'s Orders"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by OrderId',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        // Make it circular
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Keep the same value
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            _ordersStream =
                                _getOrdersStream(); // Update the stream
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _ordersStream = _getOrdersStream(); // Update the stream
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () => _selectDateRange(context),
                    icon: Icon(Icons.calendar_month, color: kDark)),
              ],
            ),
            SizedBox(height: 20),
            buildHeadingRowWidgets(
                "OderId", "PayMode", "Price", "FoodName", "Status"),
            SizedBox(height: 30),
            Expanded(child: buildBookingList()),
          ],
        ),
      ),
    );
  }

  Widget buildHeadingRowWidgets(orderId, payMode, price, foodName, status) {
    return Container(
      padding:
          const EdgeInsets.only(top: 18.0, left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(orderId,
                style:
                    appStyle(kIsWeb ? 20 : 10, kSecondary, FontWeight.normal)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              payMode,
              style: appStyle(kIsWeb ? 20 : 10, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              price,
              style: appStyle(kIsWeb ? 20 : 10, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              foodName,
              style: appStyle(kIsWeb ? 20 : 10, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: appStyle(kIsWeb ? 20 : 10, kSecondary, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingList() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _ordersStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final streamData = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display List of Drivers
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: streamData.length,
                  itemBuilder: (context, index) {
                    final data =
                        streamData[index].data() as Map<String, dynamic>;
                    // final serialNumber = index + 1;
                    final orderId = data["orderId"] ?? "";
                    final cName = data["driverName"] ?? "";
                    final cNumber = data["userPhoneNumber"] ?? "";
                    final payMode = data["payMode"] ?? "No Selected";
                    final price = data["totalBill"] ?? 0;
                    // final foodName = data["foodName"] ?? "";
                    final status = data["status"] ?? "";
                    final stringStatus = getStatusString(status);
                    final date = data["orderDate"];
                    // Inside the ListView.builder() itemBuilder function
                    final List<dynamic> orderItems = data["orderItems"];
                    final discountAmountPercentage = data['discountValue'];
                    final discountAmount = data["discountAmount"];
                    final gstAmountPercentage = data["gstAmount"];
                    final gstAmountPrice = data["gstAmountPrice"];
                    final deliveryCharges = data["deliveryCharges"];
                    final subTotalBill = data["subTotalBill"];
                    final totalPrice = data["totalBill"];
                    final orderDate = DateTime.fromMillisecondsSinceEpoch(
                        data['orderDate'].millisecondsSinceEpoch);

                    List<String> foodNames = [];
                    List<num> foodPrices = [];
                    List<num> foodQuantity = [];

                    if (orderItems != null) {
                      foodNames = orderItems
                          .map((item) => item["foodName"].toString())
                          .toList();
                      foodPrices = orderItems
                          .map((item) => item["foodPrice"] as num)
                          .toList();
                      foodQuantity = orderItems
                          .map((item) => item["quantity"] as num)
                          .toList();
                    }

                    return InkWell(
                      onTap: () => Get.to(() => OrderDetailsScreen(
                            orderId: orderId,
                            userName: cName,
                            userNumber: cNumber,
                            userDeliveryAddress:
                                data["userDeliveryAddress"] ?? "",
                            resName: data["restName"] ?? "Not Found",
                            foodName: foodNames,
                            foodPrice: foodPrices ?? 0,
                            quantity: foodQuantity ?? 0,
                            payMode: payMode,
                            couponCode: data["couponCode"] ?? "",
                            discount: data["discount"] ?? 0.0,
                            managerName: data["managerName"] ?? "",
                            status: data["status"] ?? 0,
                            discountAmountPercentage: discountAmountPercentage,
                            discountAmount: discountAmount,
                            gstAmountPercentage: gstAmountPercentage,
                            gstAmountPrice: gstAmountPrice,
                            deliveryCharges: deliveryCharges,
                            subTotalBill: subTotalBill,
                            totalPrice: totalPrice,
                            orderDate: orderDate,
                          )),
                      child: reusableRowWidget(
                        orderId,
                        payMode,
                        price.toString(),
                        foodNames.join(", "),
                        stringStatus,
                      ),
                    );
                  },
                ),
              ),
              // Pagination Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: TextButton(
                    onPressed: _loadNextPage,
                    child: const Text("Next"),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget reusableRowWidget(orderId, payMode, price, foodName, status) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(orderId,
                    style:
                        appStyle(kIsWeb ? 16 : 10, kDark, FontWeight.normal)),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  payMode,
                  style: appStyle(kIsWeb ? 16 : 10, kDark, FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  price,
                  style: appStyle(kIsWeb ? 16 : 10, kDark, FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  foodName,
                  style: appStyle(kIsWeb ? 16 : 10, kDark, FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: appStyle(kIsWeb ? 16 : 10, kDark, FontWeight.normal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }

  // Define a function to map numeric status to string status
  String getStatusString(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Order Confirmed";
      case 2:
        return "Assigned to Delivery Partner";
      case 3:
        return "Ongoing";
      case 4:
        return "Share Otp";
      case 5:
        return "Order Delivered";
      case -1:
        return "Order Cancelled";
      // Add more cases as needed for other statuses
      default:
        return "Unknown Status";
    }
  }
}
