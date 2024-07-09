import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/utils/toast_msg.dart';
import 'package:food_otg_admin_app/views/manageDrivers/driver_details_screen.dart';
import 'package:food_otg_admin_app/views/manageDrivers2Screen/second_driver_details_screen.dart';
import 'package:get/get.dart';

import '../../services/firebase_database_services.dart';

class ManageDriversSecondScreenTesting extends StatefulWidget {
  static const String id = "manage_drivers_screen_second_testing";

  const ManageDriversSecondScreenTesting({super.key});

  @override
  State<ManageDriversSecondScreenTesting> createState() =>
      _ManageDriversSecondScreenTestingState();
}

class _ManageDriversSecondScreenTestingState
    extends State<ManageDriversSecondScreenTesting> {
  final TextEditingController searchController = TextEditingController();
  late Stream<List<DocumentSnapshot>> _driverStream;
  int _perPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _driverStream = _driverStreamData();
  }

  Stream<List<DocumentSnapshot>> _driverStreamData() {
    Query query = FirebaseDatabaseServices().allDriversSecondTestingList;

    // Apply orderBy and where clauses based on search text
    if (searchController.text.isNotEmpty) {
      query = query
          .orderBy("phoneNumber")
          .where("phoneNumber",
              isGreaterThanOrEqualTo: "+91${searchController.text}")
          .where("phoneNumber",
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
      _driverStream = _driverStreamData();
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
                Text("Manage Drivers 2",
                    style: appStyle(25, kDark, FontWeight.normal)),
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
                      _driverStream = _driverStreamData(); // Update the stream
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _driverStream = _driverStreamData(); // Update the stream
                });
              },
            ),
            SizedBox(height: 30),
            buildHeadingRowWidgets(
                "Sr.no.", "D'Name", "Phone", "Email", "Active"),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _driverStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final streamData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: streamData.length,
                        itemBuilder: (context, index) {
                          final data =
                              streamData[index].data() as Map<String, dynamic>;
                          final serialNumber = index + 1;
                          final driverName = data["userName"] ?? "";
                          final driverPhone = data["phoneNumber"] ?? "";
                          final driverEmail = data["email"] ?? "";
                          final bool approved = data["approved"];
                          final docId = streamData[index].id;
                          return InkWell(
                            onTap: () => Get.to(() =>
                                DriversDetailSecondScreenTesting(
                                    riderData: streamData[index])),
                            child: reusableRowWidget(
                              serialNumber.toString(),
                              driverName,
                              driverPhone.toString(),
                              driverEmail,
                              approved,
                              streamData[index].reference,
                            ),
                          );
                        },
                      ),
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
        appBar: AppBar(title: Text("Manage Drivers")),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Drivers",
                        style: appStyle(16, kDark, FontWeight.normal)),
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
                          _driverStream =
                              _driverStreamData(); // Update the stream
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _driverStream = _driverStreamData(); // Update the stream
                    });
                  },
                ),
                SizedBox(height: 10),
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: _driverStream,
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
                              buildTableHeaderCell("D'Name"),
                              buildTableHeaderCell("Phone"),
                              buildTableHeaderCell("Email"),
                              buildTableHeaderCell("Active"),
                            ],
                          ),
                          for (var data in streamData)
                            buildDriverTableRow(data, streamData.indexOf(data)),
                          TableRow(
                            children: [
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

  Widget buildHeadingRowWidgets(srNum, driverName, phone, email, isActive) {
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
            child: Text(driverName,
                style: appStyle(20, kSecondary, FontWeight.normal)),
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
              email,
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
      srNum, driverName, phone, email, isActive, DocumentReference docRef) {
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
                  child: Text(driverName,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(phone,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(email,
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

                      docRef.update({'approved': value}).then((value) {
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

  TableRow buildDriverTableRow(DocumentSnapshot data, int index) {
    final driverData = data.data() as Map<String, dynamic>;
    final serialNumber = index + 1;
    final driverName = driverData["userName"] ?? "";
    final driverPhone = driverData["phoneNumber"] ?? "";
    final driverEmail = driverData["email"] ?? "";
    final bool approved = driverData["approved"];

    return TableRow(
      children: [
        buildTableCell(serialNumber.toString(), data),
        buildTableCell(driverName, data),
        buildTableCell(driverPhone, data),
        buildTableCell(driverEmail, data),
        TableCell(
          child: Switch(
            value: approved,
            onChanged: (value) {
              setState(() {
                // Update local state
              });
              data.reference.update({'approved': value}).then((value) {
                showToastMessage("Success", "Value updated", Colors.green);
              }).catchError((error) {
                showToastMessage("Error", "Failed to update value", Colors.red);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildTableCell(String text, DocumentSnapshot data) {
    return TableCell(
      child: GestureDetector(
        onTap: () {
          Get.to(() => DriversDetailSecondScreenTesting(riderData: data));
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
}
