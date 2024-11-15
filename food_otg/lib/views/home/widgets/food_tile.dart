import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/common/dashed_divider.dart';
import 'package:food_otg/common/reusable_text.dart';
import 'package:food_otg/controllers/food_tile_controller.dart';
import 'package:food_otg/functions/add_to_cart.dart';
import 'package:food_otg/services/collection_refrences.dart';
import 'package:food_otg/utils/app_styles.dart';
import 'package:food_otg/utils/toast_msg.dart';
import 'package:food_otg/views/checkout/checkout_screen.dart';
import 'package:get/get.dart';
import '../../../common/custom_circle_icon_button.dart';
import '../../../constants/constants.dart';

class FoodTileWidget extends StatefulWidget {
  const FoodTileWidget({Key? key, required this.food, required this.id});

  final dynamic food;
  final String id;

  @override
  State<FoodTileWidget> createState() => _FoodTileWidgetState();
}

class _FoodTileWidgetState extends State<FoodTileWidget> {
  // final foodTileController = Get.put(FoodTileController());

  int _selectedSizeIndex = -1;
  Set<String> _selectedAddOns = {};
  Set<String> _selectedAllergicOns = {};

  int get selectedSizeIndex => _selectedSizeIndex;

  Set<String> get selectedAddOns => _selectedAddOns;

  Set<String> get selectedAllergicOns => _selectedAllergicOns;
  String? selectedSizeName;
  double? selectedSizePrice;

  // num? selectedAddOnPrice;

  Map<String, num> selectedAddOnPrices = {};
  double totalPrice = 0.0;
  double? addOnPrice;
  double finalPrice = 0.0;

  List<DocumentSnapshot>? _addOnDocuments;

  @override
  void initState() {
    super.initState();
    if (widget.food.containsKey("addOns")) {
      _fetchAddOnsData(widget.food["addOns"]).then((docs) {
        setState(() {
          _addOnDocuments = docs;
        });
      });
    }
  }

  set selectedSizeIndex(int index) {
    _selectedSizeIndex = index;
    setState(() {});
  }

  List<dynamic> cartItems = [];

  double calculateTotalPrice(
      int quantity, Map<String, num> selectedAddOnPrices) {
    double basePrice = double.parse(widget.food["price"].toStringAsFixed(1));
    double sizePrice = selectedSizePrice ?? 0.0;
    double addOnsTotalPrice =
        selectedAddOnPrices.values.fold(0.0, (sum, price) => sum + price);

    // Calculate the total price
    double totalPrice = (basePrice + sizePrice + addOnsTotalPrice) * quantity;
    finalPrice = totalPrice;

    log("Base price: $basePrice");
    log("Selected size price: $sizePrice");
    log("Selected addons total price: $addOnsTotalPrice");
    log("Quantity: $quantity");
    log("Total price: $totalPrice");
    log("Final Price: $finalPrice");
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodTileController>(
      init: FoodTileController(),
      builder: (value) {
        return Stack(
          // clipBehavior: Clip.hardEdge,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              height: 140.h,
              width: width,
              decoration: BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Container(
                padding: EdgeInsets.all(4.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 140.h,
                            width: 140.w,
                            child: Image.network(widget.food["image"],
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                              color: kGray.withOpacity(0.6),
                              height: 16.h,
                              width: width,
                              child: RatingBarIndicator(
                                rating: widget.food["rating"].toDouble(),
                                itemCount: 5,
                                itemSize: 20.h,
                                itemBuilder: (ctx, i) =>
                                    const Icon(Icons.star, color: Colors.amber),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.food["isVeg"] == true
                            ? Row(
                                children: [
                                  Image.asset("assets/veg-2.png",
                                      height: 20.h, width: 20.w),
                                  Text("Veg",
                                      style: appStyle(
                                          7, Colors.green, FontWeight.normal))
                                ],
                              )
                            : Row(
                                children: [
                                  Image.asset("assets/non-veg-2.png",
                                      height: 20.h, width: 20.w),
                                  SizedBox(width: 2.w),
                                  Text("Non-Veg",
                                      style:
                                          appStyle(7, kRed, FontWeight.normal))
                                ],
                              ),
                        SizedBox(
                          width: 95.w,
                          child: Text(widget.food["title"],
                              maxLines: 2,
                              style: appStyle(11, kDark, FontWeight.normal)),
                        ),
                        ReusableText(
                            text: "Delivery Time ${widget.food["time"]}",
                            style: appStyle(11, kGray, FontWeight.w400)),
                        SizedBox(
                          width: width * 0.2,
                          height: 15.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.food["foodCalories"].length,
                            itemBuilder: (ctx, i) {
                              final tag = widget.food["foodCalories"][i];
                              return Container(
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                    color: kSecondaryLight,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.r))),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.h),
                                    child: ReusableText(
                                        text: tag,
                                        style: appStyle(
                                            8, kGray, FontWeight.w400)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //Available price
            Positioned(
              right: 70.w,
              top: 9.h,
              // top: 38.h,
              // bottom: 0.h,
              child: Container(
                width: 50.w,
                height: 19.h,
                child: Center(
                  child: ReusableText(
                    text: "₹${widget.food["price"].toStringAsFixed(0)}",
                    style: appStyle(14, kDark, FontWeight.normal),
                  ),
                ),
              ),
            ),

            Positioned(
              right: 102.w,
              top: 9.h,
              // top: 38.h,
              // bottom: 0.h,
              child: Container(
                width: 50.w,
                height: 19.h,
                child: Center(
                  child: ReusableText(
                    text: "₹${widget.food["oldPrice"].toStringAsFixed(0)}",
                    style: appStyle(10, kGray, FontWeight.bold)
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
              ),
            ),

            // //
            // //add to cart section
            Positioned(
              right: 5.w,
              top: 6.h,
              child: GestureDetector(
                onTap: () {
                  buildShowModalBottomSheet(context);
                },
                child: Container(
                    width: 60.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      // color: kSecondary,
                      border: Border.all(color: kSecondary),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Center(
                      child: ReusableText(
                          text: "ADD",
                          style: appStyle(14, kSecondary, FontWeight.bold)),
                    )),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) async {
    int quantity = 1; // Initial quantity
    totalPrice = double.parse(widget.food["price"].toStringAsFixed(1));
    bool isFoodInWishlist = false;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection("Wishlists")
        .where('userId', isEqualTo: currentUId)
        .where('foodId', isEqualTo: widget.id)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // If the item is found in the wishlist, set isFoodInWishlist to true
          isFoodInWishlist = true;
        });
      }
    });

    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxHeight: 700.h),
      isScrollControlled: true,
      backgroundColor: kOffWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 210.w,
                          child: Text(widget.food["title"],
                              overflow: TextOverflow.ellipsis,
                              style: appStyle(20, kDark, FontWeight.normal)),
                        ),
                        Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCircleIconButton(
                                icon: Icon(Icons.close, color: kSecondary),
                                onPress: () => Navigator.pop(context)),
                            SizedBox(width: 5.w),
                            CustomCircleIconButton(
                                icon: Icon(Icons.favorite,
                                    color:
                                        isFoodInWishlist ? Colors.red : kGray),
                                onPress: () {
                                  // addToWishlist(context, bookDocId, currentUId);
                                  if (isFoodInWishlist) {
                                    removeFromWishlist(
                                        context, widget.food["docId"]);
                                  } else {
                                    addToWishlist(context, widget.food["docId"],
                                        currentUId);
                                  }

                                  setState(() {
                                    isFoodInWishlist = !isFoodInWishlist;
                                  });
                                }),
                            SizedBox(width: 5.w),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    DashedDivider(color: kGrayLight),
                    SizedBox(height: 10.h),
                    Text(
                      "Description",
                      style: appStyle(15, kDark, FontWeight.normal),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      widget.food["description"],
                      maxLines: 2,
                      style: appStyle(11, kDark, FontWeight.normal),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: width * 0.7,
                      height: 15.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.food["foodCalories"].length,
                        itemBuilder: (ctx, i) {
                          final tag = widget.food["foodCalories"][i];
                          return Container(
                            margin: EdgeInsets.only(right: 5.w),
                            decoration: BoxDecoration(
                                color: kSecondaryLight,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.r))),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(2.h),
                                child: ReusableText(
                                    text: tag,
                                    style: appStyle(8, kGray, FontWeight.w400)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    if (widget.food
                            .containsKey("isAllergicIngredientsAvailable") &&
                        widget.food["isAllergicIngredientsAvailable"] ==
                            true) ...[
                      _buildAllergicIngredientsCard(context, setState),
                      SizedBox(height: 20.h),
                    ],
                    if (widget.food.containsKey("isSizesAvailable") &&
                        widget.food["isSizesAvailable"] == true) ...[
                      _buildSizeCard(context, _selectedSizeIndex, setState),
                      SizedBox(height: 20.h),
                    ],
                    if (widget.food.containsKey("isAddonAvailable") &&
                        widget.food["isAddonAvailable"] == true) ...[
                      _buildAddOnCard(context, setState),
                      SizedBox(height: 20.h),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 45.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: kPrimary)),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                      totalPrice -= double.parse(widget
                                          .food["price"]
                                          .toStringAsFixed(1));
                                    }
                                  });
                                },
                              ),
                              Text(quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                    totalPrice += double.parse(widget
                                        .food["price"]
                                        .toStringAsFixed(1));
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF976E38),
                                Color(0xFFF8E79F),
                                Color(0xFF976E38),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              cartItems.add(
                                addToCart(
                                  {
                                    "foodName": widget.food["title"],
                                    "discountAmount": 0,
                                    "couponCode": "",
                                    "foodId": widget.food["docId"],
                                    "quantity": quantity,
                                    "img": widget.food["image"],
                                    "totalPrice": finalPrice,
                                    "subTotalPrice": finalPrice,
                                    "baseTotalPrice": finalPrice,
                                    "quantityPrice": finalPrice,
                                    "foodPrice": widget.food["price"],
                                    "time": widget.food["time"].toString(),
                                    "resId": widget.food["resId"],
                                    "foodCalories": widget.food["foodCalories"],
                                    "isVeg": widget.food["isVeg"],
                                    "userId": currentUId,
                                    "selectedSize": selectedSizeName,
                                    "selectedSizePrice": selectedSizePrice ?? 0,
                                    "selectedAddOns": selectedAddOns,
                                    "selectedAddOnsPrice": selectedAddOnPrices,
                                    "selectedAllergicIngredients":
                                        _selectedAllergicOns,
                                    "added_by": DateTime.now(),
                                  },
                                  widget.food["docId"],
                                ).then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Item added to cart... view your item"),
                                      duration: Duration(seconds: 4),
                                      action: SnackBarAction(
                                        label: 'View',
                                        onPressed: () {
                                          Get.to(() => CheckoutScreen());
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Text(
                                "Add to cart ₹${calculateTotalPrice(quantity, selectedAddOnPrices).toStringAsFixed(1)} ",
                                style: appStyle(16, kDark, FontWeight.w500)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addToWishlist(
      BuildContext context, String foodId, String currentUserUid) async {
    // Add logic to add the book to the wishlist collection in Firestore
    final DocumentReference wishDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection("Wishlists")
        .doc();

    final wldId = wishDocRef.id;
    final wishListData = {
      'userId': currentUserUid,
      'foodId': foodId,
      'wishId': wldId,
      "timestamp": DateTime.now(),
    };

    await wishDocRef.set(wishListData).then((value) {
      showToastMessage("Wishlist", "Food added to wishlist", kSuccess);
    }).onError((error, stackTrace) {
      showToastMessage("Wishlist", "Something went wrong", kRed);
    });
  }

  void removeFromWishlist(BuildContext context, String foodId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection("Wishlists")
        .where('userId', isEqualTo: currentUId)
        .where('foodId', isEqualTo: foodId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
        log('Food removed from wishlist $foodId');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Food removed from wishlist'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove book from wishlist: $error'),
      ));
    });
  }

  Widget _buildAllergicIngredientsCard(BuildContext context, setState) {
    if (widget.food.containsKey("allergic")) {
      List<dynamic> allergicIngredients = widget.food["allergic"];
      return Card(
        color: kWhite,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Allergic Ingredients",
                  style: appStyle(16, kDark, FontWeight.normal)),
              SizedBox(height: 5.h),
              Column(
                children: allergicIngredients.map<Widget>((ingredient) {
                  final ingredientName = ingredient.toString();
                  final isChecked =
                      _selectedAllergicOns.contains(ingredientName);
                  return _buildAllergicIngredient(
                      ingredientName, isChecked, setState);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(); // Placeholder for when there are no allergic ingredients
    }
  }

  Widget _buildSizeCard(BuildContext context, int selectedIndex, setState) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Items")
          .doc(widget.food["docId"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var sizes = data["sizes"] as List<dynamic>;
          // Set default size if no size is selected
          if (selectedSizeName == null && sizes.isNotEmpty) {
            selectedSizeName = sizes[0]["title"];
            selectedSizePrice = double.parse(sizes[0]["price"].toString());
          }
          return Card(
            color: kWhite,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Size",
                        style: appStyle(18, kDark, FontWeight.normal),
                      ),
                    ],
                  ),
                  ReusableText(
                    text: "Select any 1 option",
                    style: appStyle(13, kGray, FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(sizes.length, (index) {
                        var sizeData = sizes.reversed.toList()[index];
                        var sizeId = sizeData["sizeId"];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("sizes")
                              .doc(sizeId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              var sizeDocument =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              var title = sizeDocument["title"];
                              var images = sizeDocument["image"];
                              var price = sizeData["price"];
                              var isSelected = selectedIndex == index;
                              double foodPrice =
                                  double.parse(widget.food["price"].toString());
                              double sizePrice = double.parse(price.toString());

                              return GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   selectedSizeIndex = index;
                                  // });
                                  if (mounted) {
                                    setState(() {
                                      selectedSizeIndex = index;
                                      selectedSizeName = title;
                                      selectedSizePrice =
                                          double.parse(price.toString());
                                    });
                                  }
                                },
                                child: Container(
                                  width: 158.w,
                                  height: 120.h,
                                  margin: EdgeInsets.only(right: 8.w),
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: isSelected ? kOffWhite : kWhite,
                                    border: Border.all(color: kGray),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isSelected)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: kWhite,
                                            size: 20.0.sp,
                                          ),
                                        ),
                                      Row(
                                        children: [
                                          Text(
                                            title,
                                            style: appStyle(
                                                14,
                                                isSelected ? kDark : kDark,
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹${(foodPrice + sizePrice).toStringAsFixed(1)}",
                                        style: appStyle(
                                          12,
                                          isSelected ? kDark : kDark,
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.network(
                                          images,
                                          color: isSelected ? kDark : kDark,
                                          height: 38.h,
                                          width: 40.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAddOnCard(BuildContext context, setState) {
    if (widget.food.containsKey("addOns")) {
      if (_addOnDocuments == null) {
        return Container(); // Return empty container while loading
      }

      return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add On", style: appStyle(16, kDark, FontWeight.normal)),
              ReusableText(
                  text: "Select any 1 option",
                  style: appStyle(13, kGray, FontWeight.w500)),
              Column(
                children: _addOnDocuments!.map<Widget>((document) {
                  final addOnData = document.data() as Map<String, dynamic>;
                  final title = addOnData["name"];
                  final price = addOnData["price"];
                  double foodPrice =
                      double.parse(widget.food["price"].toString());
                  final isSelected = selectedAddOns.contains(title);
                  return _buildAddonTile(
                      title, price!, foodPrice, isSelected, setState);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Future<List<DocumentSnapshot>> _fetchAddOnsData(
      List<dynamic> addOnIds) async {
    List<DocumentSnapshot> addOnDocuments = [];
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("AddOns")
          .where(FieldPath.documentId, whereIn: addOnIds)
          .get();
      addOnDocuments = snapshot.docs;
    } catch (error) {
      print("Error fetching add-ons: $error");
    }
    return addOnDocuments;
  }

  Widget _buildAddonTile(
      String title, num price, double foodPrice, bool isSelected, setState) {
    return ListTile(
      title: Text(
        title,
        style: appStyle(14, kDark, FontWeight.normal),
      ),
      subtitle: Text(
        "₹${price.toString()}",
        style: appStyle(12, kGray, FontWeight.normal),
      ),
      trailing: Checkbox(
        value: isSelected,
        activeColor: kSecondary,
        onChanged: (bool? value) {
          setState(() {
            if (value != null) {
              toggleAddOn(title, price, setState);
            }
          });
        },
      ),
    );
  }

  Widget _buildAllergicIngredient(
      String ingredientName, bool isChecked, setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ingredientName),
        Checkbox(
          value: isChecked,
          activeColor: kRed,
          onChanged: (bool? value) {
            setState(() {
              if (value != null) {
                toggleAllergicIngredient(ingredientName, setState);
              }
            });
          },
        ),
      ],
    );
  }

  void toggleAllergicIngredient(String title, setState) {
    if (_selectedAllergicOns.contains(title)) {
      _selectedAllergicOns.remove(title);
    } else {
      _selectedAllergicOns.add(title);
    }
    setState(() {});
  }

  void toggleAddOn(String title, num price, setState) {
    if (_selectedAddOns.contains(title)) {
      _selectedAddOns.remove(title);
      selectedAddOnPrices.remove(title);
    } else {
      _selectedAddOns.add(title);
      selectedAddOnPrices[title] = price;
    }
    setState(() {});
  }
}
