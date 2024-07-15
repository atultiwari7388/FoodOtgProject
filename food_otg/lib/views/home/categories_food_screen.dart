import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_otg/services/collection_refrences.dart';
import 'package:food_otg/views/checkout/checkout_screen.dart';
import 'package:food_otg/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../utils/app_styles.dart';

class CategoriesFoodScreen extends StatefulWidget {
  const CategoriesFoodScreen(
      {super.key, required this.categoryId, required this.categoryName});

  final String categoryId;
  final String categoryName;

  @override
  State<CategoriesFoodScreen> createState() => _CategoriesFoodScreenState();
}

class _CategoriesFoodScreenState extends State<CategoriesFoodScreen> {
  TextEditingController searchController = TextEditingController();
  bool _showMenu = false;
  String? _selectedFilter;
  String? _selectedSubCategoryId;

  List<Map<String, dynamic>> filters = [];

  late String categoryFoodCategoryId = widget.categoryId;
  late String categoryFoodCategoryName = widget.categoryName;

  @override
  void initState() {
    super.initState();
    fetchDynamicFilters();
  }

  Future<void> fetchDynamicFilters() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("SubCategories")
          .orderBy("priority", descending: false)
          .get();
      querySnapshot.docs.forEach((doc) {
        log("Subcategory name: ${doc["subCatName"]}");
        log("Subcategory image URL: ${doc["imageUrl"]}");
        log("Subcategory Id ${doc["docId"]}");
        setState(() {
          filters.add({
            "name": doc["subCatName"],
            "icon": doc["imageUrl"],
            "id": doc["docId"],
          });
        });
      });
    } catch (error) {
      print("Error fetching dynamic filters: $error");
    }
  }

  // Function to handle filter selection
  void _selectFilter(String filter) {
    final selectedFilter = filters.firstWhere(
      (filters) => filters['name'] == filter,
    );
    setState(() {
      _selectedFilter = filter;
      _selectedSubCategoryId = selectedFilter['id'];
      log("Selected Sub Category name " + selectedFilter["name"].toString());
      log("Selected Sub Category id " + selectedFilter["id"].toString());
    });
  }

  Stream<int> getCartItemCountStream(String userId) {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Reference to the user's document
    DocumentReference userRef = firestore.collection('Users').doc(userId);
    // Reference to the user's cart subcollection
    CollectionReference cartRef = userRef.collection('cart');
    // Create a stream that listens to changes in the cart subcollection
    return cartRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kDark),
        title: ReusableText(
          text: categoryFoodCategoryName,
          style: appStyle(16, kDark, FontWeight.w600),
        ),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, color: kDark)),
        actions: [
          StreamBuilder<int>(
            stream: getCartItemCountStream(currentUId),
            builder: (context, snapshot) {
              int itemCount = snapshot.data ?? 0;
              if (itemCount > 0) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => CheckoutScreen());
                  },
                  child: Container(
                    child: Badge(
                      label: Text(itemCount.toString()),
                      child: Icon(AntDesign.shoppingcart),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(width: 20.w),
       
        ],
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8.0.w, right: 8.0.w, top: 2.h, bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.h),
                          border: Border.all(color: kGrayLight),
                          boxShadow: [
                            BoxShadow(
                              color: kLightWhite,
                              spreadRadius: 0.2,
                              blurRadius: 0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              // searchController.text = value;
                              searchController.text = value.toLowerCase();
                              searchController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: searchController.text.length),
                              );
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by item name.....",
                            prefixIcon: Icon(Icons.search),
                            prefixStyle: appStyle(14, kDark, FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),

                    // Filter section
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.w, vertical: 6.h),
                        child: Row(
                          children: filters.map((filter) {
                            bool isSelected = _selectedFilter == filter['name'];
                            return GestureDetector(
                              onTap: () => _selectFilter(filter['name']),
                              child: Container(
                                margin: EdgeInsets.only(right: 10.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? Color(0xffECEDF1)
                                          : kOffWhite,
                                      spreadRadius: 0.2,
                                      blurRadius: 0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      filter['icon'],
                                      height: 20.h,
                                      width: 20.w,
                                      // color: isSelected ? kPrimary : kDark,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      filter['name'],
                                      style: appStyle(
                                          12,
                                          kDark,
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Expanded(
                        child: StreamBuilder(
                      stream: searchController.text.isEmpty
                          ? FirebaseFirestore.instance
                              .collection("Items")
                              .where("categoryId",
                                  isEqualTo: categoryFoodCategoryId)
                              .where("subCategoryId",
                                  isEqualTo: _selectedSubCategoryId)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("Items")
                              .where("categoryId",
                                  isEqualTo: categoryFoodCategoryId)
                              .where("subCategoryId",
                                  isEqualTo: _selectedSubCategoryId)
                              .where("title",
                                  isGreaterThanOrEqualTo: searchController.text
                                      .trim()[0]
                                      .toUpperCase())
                              .where("title",
                                  isLessThanOrEqualTo: searchController.text
                                          .trim()[0]
                                          .toUpperCase() +
                                      '\uf8ff')
                              .snapshots(),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snap.hasError) {
                          return Center(
                            child: Text('Error: ${snap.error}'),
                          );
                        } else {
                          final foodDocs = snap.data!.docs;
                          if (foodDocs.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.7,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Lottie.asset("assets/no-data-found.json",
                                    repeat: true, height: 320.h),
                              ),
                            );
                          } else {
                            // Convert snapshot data to a list and sort by "priority" field
                            List sortedFoodDocs = [...foodDocs];
                            sortedFoodDocs.sort((a, b) => a
                                .data()["priority"]
                                .compareTo(b.data()["priority"]));

                            // Local filtering for case-insensitive search
                            List filteredFoodDocs = sortedFoodDocs.where((doc) {
                              String title = doc.data()["title"];
                              return title.toLowerCase().contains(
                                  searchController.text.trim().toLowerCase());
                            }).toList();

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 12.w, right: 12.w, top: 12.h),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredFoodDocs.length,
                                itemBuilder: (ctx, index) {
                                  final foodDoc =
                                      filteredFoodDocs[index].data();
                                  return FoodTileWidget(
                                      food: foodDoc, id: widget.categoryId);
                                },
                              ),
                            );
                          }
                        }
                      },
                    )),
                  ],
                ),
              ),

              // Semi-transparent overlay to dim the background when menu is open
              if (_showMenu)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMenu = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              Positioned(
                bottom: 0.h,
                right: 5.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMenu = !_showMenu;
                    });
                  },
                  child: Container(
                    height: 38.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.h),
                          topRight: Radius.circular(10.h),
                        ),
                        color: kDark),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(_showMenu ? Icons.close : Icons.menu,
                              color: kWhite),
                          Text(_showMenu ? "Close" : "Menu",
                              style: appStyle(14, kWhite, FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_showMenu)
                Positioned(
                  bottom: 50.h,
                  right: 10.w,
                  child: Container(
                    width: 290.w,
                    height: 400.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: kGrayLight),
                      boxShadow: [
                        BoxShadow(
                          color: kLightWhite,
                          spreadRadius: 0.2,
                          blurRadius: 0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Categories")
                            .orderBy("priority", descending: false)
                            .where("active", isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            final catG = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: catG.length,
                              itemBuilder: (ctx, index) {
                                final floatingCatData = catG[index].data();
                                final floatingCategoryName =
                                    floatingCatData["categoryName"];
                                final floatingCategoryId =
                                    floatingCatData["docId"];
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        // Update the selected category ID
                                        categoryFoodCategoryId =
                                            floatingCategoryId.toString();
                                        // Optionally, you can also update the category name if needed
                                        categoryFoodCategoryName =
                                            floatingCategoryName.toString();
                                        _showMenu = false;
                                      });
                                      log("Floating cat Id  " +
                                          categoryFoodCategoryId.toString());
                                      log("Floating categoryName  " +
                                          categoryFoodCategoryName.toString());
                                    },
                                    child: _buildMenuItem(
                                        floatingCategoryName.toString()));
                              },
                            );
                          }
                        }),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: appStyle(14, kDark, FontWeight.w500),
      ),
    );
  }
}
