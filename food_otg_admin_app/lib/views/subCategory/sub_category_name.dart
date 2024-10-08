import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/views/subCategory/add_sub_category.dart';
import 'package:food_otg_admin_app/views/subCategory/edit_subcategory.dart';
import 'package:get/get.dart';
import '../../services/firebase_database_services.dart';
import '../../utils/toast_msg.dart';

class SubCategoriesScreen extends StatefulWidget {
  static const String id = "sub_categories_screen";

  const SubCategoriesScreen({super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final TextEditingController searchController = TextEditingController();
  late Stream<List<DocumentSnapshot>> _subCatStream;
  int _perPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _subCatStream = _subCatStreamData();
  }

  Stream<List<DocumentSnapshot>> _subCatStreamData() {
    Query query = FirebaseDatabaseServices().allSubCategoriesList;

    // Apply orderBy and where clauses based on search text
    if (searchController.text.isNotEmpty) {
      query = query
          .orderBy("subCatName")
          .where("subCatName",
              isGreaterThanOrEqualTo: "${searchController.text}")
          .where("subCatName",
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
      _subCatStream = _subCatStreamData();
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
                Text("Sub Categories",
                    style: appStyle(25, kDark, FontWeight.normal)),
                CustomGradientButton(
                  w: 220,
                  h: 45,
                  text: "Add Sub-Category",
                  onPress: () => Get.to(() => const AddSubCategory(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 900)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Sub cat name',
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
                      _subCatStream = _subCatStreamData(); // Update the stream
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _subCatStream = _subCatStreamData(); // Update the stream
                });
              },
            ),
            SizedBox(height: 30),
            buildHeadingRowWidgets(
                "Sr.no.", "Category Name", "Priority", "Actions", "Active"),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _subCatStream,
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
                          // final docId = data["docId"] ?? "";
                          final categoryName = data["subCatName"] ?? "";
                          final priority = data["priority"].toString();
                          final bool approved = data["active"];
                          final String categoryId = data["categoryId"] ?? "";

                          return reusableRowWidget(
                              serialNumber.toString(),
                              categoryName,
                              priority.toString(),
                              approved,
                              streamData[index].reference,
                              categoryId,
                              data);
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
        appBar: AppBar(title: Text("Sub-Categories")),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sub-Categories",
                        style: appStyle(16, kDark, FontWeight.normal)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkGray),
                        onPressed: () => Get.to(() => const AddSubCategory(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 900)),
                        child: Text("Add Sub-Category",
                            style: appStyle(12, kSecondary, FontWeight.normal)))
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Sub cat name',
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
                          _subCatStream =
                              _subCatStreamData(); // Update the stream
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _subCatStream = _subCatStreamData(); // Update the stream
                    });
                  },
                ),
                SizedBox(height: 15),
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: _subCatStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final streamData = snapshot.data!;
                      return Table(
                        border: TableBorder.all(color: kDark, width: 1.0),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: kDark),
                            children: [
                              buildTableHeaderCell("Sr.No"),
                              buildTableHeaderCell("C'name"),
                              buildTableHeaderCell("Priority"),
                              buildTableHeaderCell("Actions"),
                              buildTableHeaderCell("Active"),
                            ],
                          ),
                          // Display List of Restaurants
                          for (var data in streamData) ...[
                            TableRow(
                              children: [
                                TableCell(
                                  child: Image.network(
                                    data["imageUrl"].toString(),
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    data["subCatName"].toString(),
                                    style:
                                        appStyle(12, kDark, FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    data["priority"].toString(),
                                    style:
                                        appStyle(12, kDark, FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            Get.to(() => EditSubCategoryScreen(
                                                  subCatId: data["docId"],
                                                  data: data.data()
                                                      as Map<String, dynamic>,
                                                )),
                                        child: const Icon(Icons.edit,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                TableCell(
                                  child: Switch(
                                    value: data["active"],
                                    onChanged: (value) {
                                      setState(() {
                                        // data["active"] = value;
                                      });
                                      data.reference.update(
                                          {'active': value}).then((value) {
                                        showToastMessage("Success",
                                            "Value updated", Colors.green);
                                      }).catchError((error) {
                                        showToastMessage(
                                            "Error",
                                            "Failed to update value",
                                            Colors.red);
                                        print("Failed to update value: $error");
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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
      srNum, categoryName, priority, actions, isActive) {
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
            child: Text(categoryName,
                style: appStyle(20, kSecondary, FontWeight.normal)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              priority,
              style: appStyle(20, kSecondary, FontWeight.normal),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              actions,
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

  Widget reusableRowWidget(srNum, categoryName, priority, isActive,
      DocumentReference docRef, categoryId, data) {
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
                  child: Text(categoryName,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Text(priority,
                      style: appStyle(16, kDark, FontWeight.normal))),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.to(() => EditSubCategoryScreen(
                              subCatId: categoryId, data: data)),
                          icon: const Icon(Icons.edit, color: Colors.green)),
                    ],
                  )),
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
