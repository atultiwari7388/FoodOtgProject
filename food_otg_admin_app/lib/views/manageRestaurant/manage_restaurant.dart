import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/views/manageRestaurant/add_restaurant.dart';
import 'package:food_otg_admin_app/views/manageRestaurant/restaurant_details_screen.dart';
import 'package:get/get.dart';
import '../../services/firebase_database_services.dart';
import '../../utils/toast_msg.dart';

class ManageRestaurantScreen extends StatefulWidget {
  static const String id = "manage_restaurant_screen";

  const ManageRestaurantScreen({super.key});

  @override
  State<ManageRestaurantScreen> createState() => _ManageRestaurantScreenState();
}

class _ManageRestaurantScreenState extends State<ManageRestaurantScreen> {
  final TextEditingController searchController = TextEditingController();
  late Stream<List<DocumentSnapshot>> _restaurantStream;
  int _perPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _restaurantStream = _restaurantStreamData();
  }

  Stream<List<DocumentSnapshot>> _restaurantStreamData() {
    Query query = FirebaseDatabaseServices().allRestaurantList;

    // Apply orderBy and where clauses based on search text
    if (searchController.text.isNotEmpty) {
      query = query
          .orderBy("contact")
          .where("contact",
              isGreaterThanOrEqualTo: "+91${searchController.text}")
          .where("contact",
              isLessThanOrEqualTo: "+91${searchController.text}\uf8ff");
    } else {
      query = query.orderBy("created_at", descending: true);
    }

    return query.limit(_perPage).snapshots().map((snapshot) => snapshot.docs);
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _perPage += 10;
      _restaurantStream = _restaurantStreamData();
      log(_currentPage.toString());
      log(_perPage.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Manage Restaurant",
                    style: appStyle(25, kDark, FontWeight.normal)),
                CustomGradientButton(
                  w: 220,
                  h: 45,
                  text: "Add Restaurant",
                  onPress: () => Get.to(() => const AddRestaurant(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 900)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Make it circular
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Keep the same value
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      _restaurantStream =
                          _restaurantStreamData(); // Update the stream
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _restaurantStream =
                      _restaurantStreamData(); // Update the stream
                });
              },
            ),
            SizedBox(height: 30),
            buildHeadingRowWidgets(
                "Res.Id.", "Name", "Location", "Phone", "Active"),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _restaurantStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final streamData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display List of Drivers
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: streamData.length,
                        itemBuilder: (context, index) {
                          final data =
                              streamData[index].data() as Map<String, dynamic>;
                          final resId = data["id"] ?? "";
                          final restaurantName = data["res_name"] ?? "";
                          final location = data["locationAddress"] ?? "";
                          final phoneNumber = data["contact"] ?? "";
                          final bool approved = data["active"];
                          final String id = streamData[index].id;
                          return InkWell(
                            onTap: () => Get.to(() => RestaurantDetailsScreen(
                                  resName: restaurantName,
                                  resData: data,
                                  id: id,
                                )),
                            child: reusableRowWidget(
                              resId,
                              restaurantName,
                              location,
                              phoneNumber,
                              approved,
                              streamData[index].reference,
                            ),
                          );
                        },
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
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Restaurants"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Restaurant",
                        style: appStyle(16, kDark, FontWeight.normal)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkGray),
                        onPressed: () => Get.to(() => const AddRestaurant(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 900)),
                        child: Text("Add Restaurant",
                            style: appStyle(12, kSecondary, FontWeight.normal)))
                  ],
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: _restaurantStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final streamData = snapshot.data!;
                      return Table(
                        border: TableBorder.all(color: kDark, width: 1.0),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: kDark),
                            children: [
                              buildTableHeaderCell("Res.Id."),
                              buildTableHeaderCell("Name"),
                              buildTableHeaderCell("Location"),
                              buildTableHeaderCell("Phone"),
                              buildTableHeaderCell("Active"),
                            ],
                          ),
                          // Display List of Restaurants
                          for (var data in streamData) ...[
                            buildManageRestaurantTableRow(
                                data, streamData.indexOf(data)),
                          ],
                          // Pagination Button
                          TableRow(
                            children: [
                              TableCell(
                                child:
                                    SizedBox(), // This cell is for the pagination button
                              ),
                              TableCell(
                                child: SizedBox(),
                              ),
                              TableCell(
                                child: SizedBox(),
                              ),
                              TableCell(
                                child: SizedBox(),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: _loadNextPage,
                                      child: const Text("Next"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  TableRow buildManageRestaurantTableRow(DocumentSnapshot data, int index) {
    final serialNumber = index + 1;
    final id = data.id;
    return TableRow(
      children: [
        buildTableCell(serialNumber.toString(), data, id),
        TableCell(
          child: Text(
            data["res_name"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            data["locationAddress"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            data["contact"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Switch(
            value: data["active"],
            onChanged: (value) {
              setState(() {
                // data["active"] = value;
              });
              data.reference.update({'active': value}).then((value) {
                showToastMessage("Success", "Value updated", Colors.green);
              }).catchError((error) {
                showToastMessage("Error", "Failed to update value", Colors.red);
                print("Failed to update value: $error");
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildTableCell(String text, DocumentSnapshot data, String id) {
    return TableCell(
      child: GestureDetector(
        onTap: () {
          log("Restaurant Id is : $id");
          Get.to(() => RestaurantDetailsScreen(
                resData: data.data() as Map<String, dynamic>,
                resName: data["res_name"],
                id: id,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildTableHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildHeadingRowWidgets(srNum, name, location, phone, isActive) {
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
            child:
                Text(srNum, style: appStyle(20, kSecondary, FontWeight.normal)),
          ),
          Expanded(
            flex: 1,
            child:
                Text(name, style: appStyle(20, kSecondary, FontWeight.normal)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              location,
              style: appStyle(20, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              phone,
              style: appStyle(20, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              isActive,
              textAlign: TextAlign.center,
              style: appStyle(20, kSecondary, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget reusableRowWidget(
      srNum, name, location, phone, isActive, DocumentReference docRef) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(srNum,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(name,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(location,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(phone,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                flex: 1,
                child: Builder(builder: (context) {
                  return Switch(
                    key: UniqueKey(),
                    value: isActive,
                    onChanged: (bool value) {
                      setState(() {
                        isActive = value;
                      });

                      docRef.update({'active': value}).then((value) {
                        showToastMessage(
                            "Success", "Value updated", Colors.green);
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
