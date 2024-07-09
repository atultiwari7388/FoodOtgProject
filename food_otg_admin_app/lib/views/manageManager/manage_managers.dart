import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/views/manageDrivers/manage_drivers.dart';
import 'package:food_otg_admin_app/views/manageManager/add_manager.dart';
import 'package:food_otg_admin_app/views/manageManager/manager_details_screen.dart';
import 'package:get/get.dart';
import '../../services/firebase_database_services.dart';
import '../../utils/toast_msg.dart';

class ManageManagerScreen extends StatefulWidget {
  static const String id = "manage_manager_screen";

  const ManageManagerScreen({super.key});

  @override
  State<ManageManagerScreen> createState() => _ManageManagerScreenState();
}

class _ManageManagerScreenState extends State<ManageManagerScreen> {
  final TextEditingController searchController = TextEditingController();
  late Stream<List<DocumentSnapshot>> _managerStream;
  int _perPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _managerStream = _managerStreamData();
  }

  Stream<List<DocumentSnapshot>> _managerStreamData() {
    Query query = FirebaseDatabaseServices().allManagersList;

    // Apply orderBy and where clauses based on search text
    if (searchController.text.isNotEmpty) {
      query = query
          .orderBy("phoneNumber")
          .where("phoneNumber",
              isGreaterThanOrEqualTo: "${searchController.text}")
          .where("phoneNumber",
              isLessThanOrEqualTo: "${searchController.text}\uf8ff");
    } else {
      query = query.orderBy("created_at", descending: true);
    }

    return query.limit(_perPage).snapshots().map((snapshot) => snapshot.docs);
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
      _perPage += 10;
      _managerStream = _managerStreamData();
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
                Text("Manage Manager",
                    style: appStyle(25, kDark, FontWeight.normal)),
                CustomGradientButton(
                  w: 220,
                  h: 45,
                  text: "Add Manager",
                  onPress: () => Get.to(() => const AddManager(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 900)),
                ),
              ],
            ),
            // const SizedBox(height: 70),
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
                      _managerStream =
                          _managerStreamData(); // Update the stream
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _managerStream = _managerStreamData(); // Update the stream
                });
              },
            ),
            SizedBox(height: 30),

            buildHeadingRowWidgets(
                "Sr.No.", "Name", "Email", "Phone", "Restaurant", "Active"),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _managerStream,
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
                          final serialNumber = index + 1;
                          final name = data["name"] ?? "";
                          final email = data["email"] ?? "";
                          final phoneNumber = data["phoneNumber"] ?? "";
                          final restaurantName = data["res_name"] ?? "";
                          final bool approved = data["active"];
                          final String docId = data["uid"];
                          // final restaurantId = item.id;

                          return InkWell(
                            onTap: () => Get.to(() => ManagersDetailsScreen(
                                docId: docId, managerName: name, data: data)),
                            child: reusableRowWidget(
                              serialNumber.toString(),
                              name,
                              email,
                              phoneNumber,
                              restaurantName,
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
          title: Text("Manage Mangers"),
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
                    Text("Manage Managers",
                        style: appStyle(16, kDark, FontWeight.normal)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkGray),
                        onPressed: () => Get.to(() => const AddManager(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 900)),
                        child: Text("Add Manager",
                            style: appStyle(12, kSecondary, FontWeight.normal)))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by number',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Make it circular
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
                          _managerStream =
                              _managerStreamData(); // Update the stream
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _managerStream =
                          _managerStreamData(); // Update the stream
                    });
                  },
                ),
                SizedBox(height: 10),
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: _managerStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final streamData = snapshot.data!;
                      return Table(
                        border: TableBorder.all(color: kDark, width: 1.0),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: kDark),
                            children: [
                              buildTableHeaderCell("Sr.no."),
                              buildTableHeaderCell("Name"),
                              buildTableHeaderCell("Email"),
                              buildTableHeaderCell("Phone"),
                              buildTableHeaderCell("Restaurant"),
                              buildTableHeaderCell("Active"),
                            ],
                          ),
                          // Display List of Restaurants
                          for (var data in streamData) ...[
                            buildManageManagerTableRow(streamData, data),
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

  TableRow buildManageManagerTableRow(
      List<DocumentSnapshot<Object?>> streamData, DocumentSnapshot data) {
    return TableRow(
      children: [
        buildTableCell(streamData, data),
        TableCell(
          child: Text(
            data["name"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            data["email"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            data["phoneNumber"] ?? "",
            style: appStyle(12, kDark, FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Text(
            data["res_name"] ?? "",
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

  TableCell buildTableCell(List<DocumentSnapshot<Object?>> streamData,
      DocumentSnapshot<Object?> data) {
    return TableCell(
      child: GestureDetector(
        onTap: () => Get.to(
          () => ManagersDetailsScreen(
            docId: data["uid"],
            managerName: data["name"],
            data: data.data() as Map<String, dynamic>,
          ),
        ),
        child: Text(
          (streamData.indexOf(data) + 1).toString(),
          style: appStyle(12, kDark, FontWeight.normal),
          textAlign: TextAlign.center,
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

  Widget buildHeadingRowWidgets(
      srNum, name, email, phone, restaurant, isActive) {
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
              email,
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
              restaurant,
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

  Widget reusableRowWidget(srNum, name, email, phone, restaurant, isActive,
      DocumentReference docRef) {
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
                  child: Text(email,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(phone,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(restaurant,
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
