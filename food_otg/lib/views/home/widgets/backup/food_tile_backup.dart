// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:food_otg/common/dashed_divider.dart';
// import 'package:food_otg/common/reusable_text.dart';
// import 'package:food_otg/controllers/food_tile_controller.dart';
// import 'package:food_otg/functions/add_to_cart.dart';
// import 'package:food_otg/services/collection_refrences.dart';
// import 'package:food_otg/utils/app_styles.dart';
// import 'package:food_otg/views/checkout/checkout_screen.dart';
// import 'package:get/get.dart';
// import '../../../common/custom_circle_icon_button.dart';
// import '../../../constants/constants.dart';

// class FoodTileWidget extends StatefulWidget {
//   const FoodTileWidget({Key? key, required this.food, required this.id});

//   final dynamic food;
//   final String id;

//   @override
//   State<FoodTileWidget> createState() => _FoodTileWidgetState();
// }

// class _FoodTileWidgetState extends State<FoodTileWidget> {
//   // final foodTileController = Get.put(FoodTileController());

//   int _selectedSizeIndex = 0;
//   Set<String> _selectedAddOns = {};
//   Set<String> _selectedAllergicOns = {};

//   int get selectedSizeIndex => _selectedSizeIndex;
//   Set<String> get selectedAddOns => _selectedAddOns;
//   Set<String> get selectedAllergicOns => _selectedAllergicOns;

//   set selectedSizeIndex(int index) {
//     _selectedSizeIndex = index;
//     setState(() {});
//   }

//   void toggleAddOn(String title) {
//     if (_selectedAddOns.contains(title)) {
//       _selectedAddOns.remove(title);
//     } else {
//       _selectedAddOns.add(title);
//     }
//     setState(() {});
//     ();
//   }

//   void toggleAllergicIngredient(String title) {
//     if (_selectedAllergicOns.contains(title)) {
//       _selectedAllergicOns.remove(title);
//     } else {
//       _selectedAllergicOns.add(title);
//     }
//     setState(() {});
//     ();
//   }

//   double calculateTotalPrice(dynamic food) {
//     double sizePrice = food["sizes"][_selectedSizeIndex]["price"];
//     double addOnsPrice = _selectedAddOns.length > 0
//         ? _selectedAddOns
//             .map((title) =>
//                 food["addOns"].firstWhere((addOn) => addOn["title"] == title))
//             .map<double>((addOn) => addOn["price"])
//             .reduce((value, element) => value + element)
//         : 0;
//     return sizePrice + addOnsPrice;
//   }

//   List<dynamic> cartItems = [];

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<FoodTileController>(
//       init: FoodTileController(),
//       builder: (value) {
//         return Stack(
//           // clipBehavior: Clip.hardEdge,
//           children: [
//             Container(
//               margin: EdgeInsets.only(bottom: 8.h),
//               height: 96.h,
//               width: width,
//               decoration: BoxDecoration(
//                 color: kOffWhite,
//                 borderRadius: BorderRadius.circular(9.r),
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(4.r),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                       child: Stack(
//                         children: [
//                           SizedBox(
//                             height: 90.h,
//                             width: 70.w,
//                             child: Image.network(widget.food["image"],
//                                 fit: BoxFit.cover),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             child: Container(
//                               padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
//                               color: kGray.withOpacity(0.6),
//                               height: 16.h,
//                               width: width,
//                               child: RatingBarIndicator(
//                                 rating: widget.food["rating"].toDouble(),
//                                 itemCount: 5,
//                                 itemSize: 15.h,
//                                 itemBuilder: (ctx, i) =>
//                                     const Icon(Icons.star, color: Colors.amber),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         widget.food["isVeg"] == true
//                             ? Row(
//                                 children: [
//                                   Image.asset("assets/veg-2.png",
//                                       height: 20.h, width: 20.w),
//                                   Text("Veg",
//                                       style: appStyle(
//                                           7, Colors.green, FontWeight.normal))
//                                 ],
//                               )
//                             : Row(
//                                 children: [
//                                   Image.asset("assets/non-veg-2.png",
//                                       height: 20.h, width: 20.w),
//                                   SizedBox(width: 2.w),
//                                   Text("Non-Veg",
//                                       style:
//                                           appStyle(7, kRed, FontWeight.normal))
//                                 ],
//                               ),
//                         SizedBox(
//                           width: 120.w,
//                           child: Text(widget.food["title"],
//                               maxLines: 2,
//                               style: appStyle(11, kDark, FontWeight.normal)),
//                         ),
//                         ReusableText(
//                             text: "Delivery Time ${widget.food["time"]}",
//                             style: appStyle(11, kGray, FontWeight.w400)),
//                         SizedBox(
//                           width: width * 0.7,
//                           height: 15.h,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: widget.food["foodCalories"].length,
//                             itemBuilder: (ctx, i) {
//                               final tag = widget.food["foodCalories"][i];
//                               return Container(
//                                 margin: EdgeInsets.only(right: 5.w),
//                                 decoration: BoxDecoration(
//                                     color: kSecondaryLight,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(9.r))),
//                                 child: Center(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(2.h),
//                                     child: ReusableText(
//                                         text: tag,
//                                         style: appStyle(
//                                             8, kGray, FontWeight.w400)),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             //Available price
//             Positioned(
//               right: 72.w,
//               top: 9.h,
//               // top: 38.h,
//               // bottom: 0.h,
//               child: Container(
//                 width: 50.w,
//                 height: 19.h,
//                 child: Center(
//                   child: ReusableText(
//                     text: "₹${widget.food["price"].toStringAsFixed(0)}",
//                     style: appStyle(14, kDark, FontWeight.normal),
//                   ),
//                 ),
//               ),
//             ),
//             //
//             //add to cart section
//             Positioned(
//               right: 5.w,
//               top: 6.h,
//               child: GestureDetector(
//                 onTap: () {
//                   buildShowModalBottomSheet(context);
//                 },
//                 child: Container(
//                     width: 60.w,
//                     height: 30.h,
//                     decoration: BoxDecoration(
//                       // color: kSecondary,
//                       border: Border.all(color: kSecondary),
//                       borderRadius: BorderRadius.circular(7.r),
//                     ),
//                     child: Center(
//                       child: ReusableText(
//                           text: "ADD",
//                           style: appStyle(14, kSecondary, FontWeight.bold)),
//                     )),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
//     int quantity = 1; // Initial quantity
//     double totalPrice = double.parse(widget.food["price"].toStringAsFixed(1));

//     return showModalBottomSheet(
//       context: context,
//       constraints: BoxConstraints(maxHeight: 700.h),
//       isScrollControlled: true,
//       backgroundColor: kOffWhite,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 210.w,
//                           child: Text(widget.food["title"],
//                               overflow: TextOverflow.ellipsis,
//                               style: appStyle(20, kDark, FontWeight.normal)),
//                         ),
//                         Spacer(),
//                         Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomCircleIconButton(
//                                 icon: Icon(Icons.close, color: kSecondary),
//                                 onPress: () => Navigator.pop(context)),
//                             SizedBox(width: 5.w),
//                             CustomCircleIconButton(
//                                 icon: Icon(Icons.favorite_border,
//                                     color: kSecondary),
//                                 onPress: () => Navigator.pop(context)),
//                             SizedBox(width: 5.w),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     DashedDivider(color: kGrayLight),
//                     SizedBox(height: 10.h),
//                     Text(
//                       "Description",
//                       style: appStyle(15, kDark, FontWeight.normal),
//                     ),
//                     SizedBox(height: 5.h),
//                     Text(
//                       widget.food["description"],
//                       maxLines: 2,
//                       style: appStyle(11, kDark, FontWeight.normal),
//                     ),
//                     SizedBox(height: 5.h),
//                     SizedBox(
//                       width: width * 0.7,
//                       height: 15.h,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: widget.food["foodCalories"].length,
//                         itemBuilder: (ctx, i) {
//                           final tag = widget.food["foodCalories"][i];
//                           return Container(
//                             margin: EdgeInsets.only(right: 5.w),
//                             decoration: BoxDecoration(
//                                 color: kSecondaryLight,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(9.r))),
//                             child: Center(
//                               child: Padding(
//                                 padding: EdgeInsets.all(2.h),
//                                 child: ReusableText(
//                                     text: tag,
//                                     style: appStyle(8, kGray, FontWeight.w400)),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20.0.h),
//                     if (widget.food
//                             .containsKey("isAllergicIngredientsAvailable") &&
//                         widget.food["isAllergicIngredientsAvailable"] ==
//                             true) ...[
//                       _buildAllergicIngredientsCard(context),
//                       SizedBox(height: 20.h),
//                     ],
//                     if (widget.food.containsKey("isSizesAvailable") &&
//                         widget.food["isSizesAvailable"] == true) ...[
//                       _buildSizeCard(context, _selectedSizeIndex),
//                       SizedBox(height: 20.h),
//                     ],
//                     if (widget.food.containsKey("isAddonAvailable") &&
//                         widget.food["isAddonAvailable"] == true) ...[
//                       _buildAddOnCard(context),
//                       SizedBox(height: 20.h),
//                     ],
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: 45.h,
//                           width: 120.w,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12.r),
//                               border: Border.all(color: kPrimary)),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.remove),
//                                 onPressed: () {
//                                   setState(() {
//                                     if (quantity > 1) {
//                                       quantity--;
//                                       totalPrice -= double.parse(widget
//                                           .food["price"]
//                                           .toStringAsFixed(1));
//                                     }
//                                   });
//                                 },
//                               ),
//                               Text(quantity.toString()),
//                               IconButton(
//                                 icon: Icon(Icons.add),
//                                 onPressed: () {
//                                   setState(() {
//                                     quantity++;
//                                     totalPrice += double.parse(widget
//                                         .food["price"]
//                                         .toStringAsFixed(1));
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [
//                                 Color(0xFF976E38),
//                                 Color(0xFFF8E79F),
//                                 Color(0xFF976E38),
//                               ],
//                             ),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               cartItems.add(
//                                 addToCart(
//                                   {
//                                     "foodName": widget.food["title"],
//                                     "discountAmount": 0,
//                                     "couponCode": "",
//                                     "foodId": widget.food["docId"],
//                                     "quantity": quantity,
//                                     "img": widget.food["image"],
//                                     "totalPrice": totalPrice,
//                                     "foodPrice": widget.food["price"],
//                                     "resId": widget.food["resId"],
//                                     "foodCalories": widget.food["foodCalories"],
//                                     "isVeg": widget.food["isVeg"],
//                                     "added_by": DateTime.now(),
//                                     "userId": currentUId,
//                                     "isAddonAvailable":
//                                         widget.food["isAddonAvailable"],
//                                     "isSizesAvailable":
//                                         widget.food["isSizesAvailable"],
//                                     "isAllergicIngredientsAvailable": widget
//                                         .food["isAllergicIngredientsAvailable"],
//                                   },
//                                   widget.food["docId"],
//                                 ).then((value) {
//                                   Navigator.pop(context);
//                                   Get.to(() => CheckoutScreen());
//                                 }),
//                               );
//                             },
//                             child: Text(
//                                 "Add to Cart - ₹${totalPrice.toStringAsFixed(1)}",
//                                 style: appStyle(16, kDark, FontWeight.w500)),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildAllergicIngredientsCard(BuildContext context) {
//     if (widget.food.containsKey("allergic")) {
//       List<dynamic> allergicIngredients = widget.food["allergic"];
//       return Card(
//         color: kWhite,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Select Allergic Ingredients",
//                   style: appStyle(16, kDark, FontWeight.normal)),
//               SizedBox(height: 5.h),
//               Column(
//                 children: allergicIngredients.map<Widget>((ingredient) {
//                   final ingredientName = ingredient.toString();
//                   final isChecked =
//                       _selectedAllergicOns.contains(ingredientName);
//                   return _buildAllergicIngredient(ingredientName, isChecked);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return SizedBox(); // Placeholder for when there are no allergic ingredients
//     }
//   }

//   Widget _buildSizeCard(BuildContext context, int selectedIndex) {
//     List<dynamic> sizeIds = widget.food["sizes"];

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("sizes")
//           .where(FieldPath.documentId, whereIn: sizeIds)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           List<DocumentSnapshot> sizeDocuments = snapshot.data!.docs;
//           return Card(
//             color: kWhite,
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Size",
//                     style: appStyle(18, kDark, FontWeight.normal),
//                   ),
//                   ReusableText(
//                     text: "Select any 1 option",
//                     style: appStyle(13, kGray, FontWeight.w500),
//                   ),
//                   SizedBox(height: 10.h),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(sizeDocuments.length, (index) {
//                         final size =
//                             sizeDocuments[index].data() as Map<String, dynamic>;
//                         final isSelected = selectedIndex == index;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedIndex = index;
//                             });
//                           },
//                           child: Container(
//                             width: 158.w,
//                             height: 120.h,
//                             margin: EdgeInsets.only(right: 8.w),
//                             padding: EdgeInsets.only(left: 8, right: 8, top: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12.r),
//                               color: isSelected ? kOffWhite : kWhite,
//                               border: Border.all(color: kGray),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 if (isSelected)
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Icon(
//                                       Icons.check_circle,
//                                       color: kWhite,
//                                       size: 20.0.sp,
//                                     ),
//                                   ),
//                                 Row(
//                                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       size["title"],
//                                       style: appStyle(
//                                           14,
//                                           isSelected ? kDark : kDark,
//                                           isSelected
//                                               ? FontWeight.bold
//                                               : FontWeight.normal),
//                                     ),
//                                     SizedBox(width: 12.w),
//                                     Text(
//                                       "${[size["inch"] + "  inches"]}",
//                                       style: appStyle(
//                                           11,
//                                           isSelected ? kDark : kDark,
//                                           isSelected
//                                               ? FontWeight.bold
//                                               : FontWeight.normal),
//                                     ),
//                                   ],
//                                 ),
//                                 // SizedBox(height: 5.h),
//                                 Text(
//                                   "₹${size["price"].toStringAsFixed(2)}",
//                                   style: appStyle(
//                                       12,
//                                       isSelected ? kDark : kDark,
//                                       isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Image.network(
//                                     size["image"],
//                                     color: isSelected ? kDark : kDark,
//                                     height: 40.h,
//                                     width: 50.w,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 SizedBox(height: 5.h),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildAddOnCard(BuildContext context) {
//     if (widget.food.containsKey("addOns")) {
//       List<dynamic> addons = widget.food["addOns"];
//       return Card(
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Add On", style: appStyle(16, kDark, FontWeight.normal)),
//               ReusableText(
//                   text: "Select any 2 option",
//                   style: appStyle(13, kGray, FontWeight.w500)),
//               Column(
//                 children: addons.map<Widget>((addon) {
//                   final title = addon.toString();
//                   final isSelected = selectedAddOns.contains(title);
//                   return _buildSelectItem(title, isSelected);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return SizedBox(); // Placeholder for when there are no addons
//     }
//   }

//   Widget _buildSelectItem(String title, bool isSelected) {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return CheckboxListTile(
//           title: Text(title, style: appStyle(14, kDark, FontWeight.normal)),
//           value: isSelected,
//           activeColor: kRed,
//           onChanged: (value) {
//             setState(() {
//               if (value != null) {
//                 if (isSelected) {
//                   selectedAddOns.add(title);
//                 } else {
//                   selectedAddOns.remove(title);
//                 }
//               }
//             });
//           },
//           controlAffinity: ListTileControlAffinity.trailing,
//         );
//       },
//     );
//   }

//   Widget _buildAllergicIngredient(String ingredientName, bool isChecked) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(ingredientName),
//         Checkbox(
//           value: isChecked,
//           activeColor: kRed,
//           onChanged: (bool? value) {
//             setState(() {
//               if (value != null) {
//                 toggleAllergicIngredient(ingredientName);
//               }
//             });
//           },
//         ),
//       ],
//     );
//   }
// }


/// Size section

  // Widget _buildSizeCard(BuildContext context, int selectedIndex) {
  //   List<dynamic> sizeIds = widget.food["sizes"];

  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection("sizes")
  //         .where(FieldPath.documentId, whereIn: sizeIds)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         List<DocumentSnapshot> sizeDocuments = snapshot.data!.docs;
  //         return Card(
  //           color: kWhite,
  //           child: Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Size",
  //                   style: appStyle(18, kDark, FontWeight.normal),
  //                 ),
  //                 ReusableText(
  //                   text: "Select any 1 option",
  //                   style: appStyle(13, kGray, FontWeight.w500),
  //                 ),
  //                 SizedBox(height: 10.h),
  //                 SingleChildScrollView(
  //                   scrollDirection: Axis.horizontal,
  //                   child: Row(
  //                     children: List.generate(sizeDocuments.length, (index) {
  //                       final size =
  //                           sizeDocuments[index].data() as Map<String, dynamic>;
  //                       final isSelected = selectedIndex == index;
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             selectedSizeIndex = index;
  //                             // Update the total price when the size is selected
  //                             totalPrice = double.parse(
  //                                     widget.food["price"].toStringAsFixed(1)) +
  //                                 double.parse(
  //                                     size["price"].toStringAsFixed(1));
  //                           });
  //                         },
  //                         child: Container(
  //                           width: 158.w,
  //                           height: 120.h,
  //                           margin: EdgeInsets.only(right: 8.w),
  //                           padding: EdgeInsets.only(left: 8, right: 8, top: 8),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12.r),
  //                             color: isSelected ? kOffWhite : kWhite,
  //                             border: Border.all(color: kGray),
  //                           ),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               if (isSelected)
  //                                 Align(
  //                                   alignment: Alignment.centerRight,
  //                                   child: Icon(
  //                                     Icons.check_circle,
  //                                     color: kWhite,
  //                                     size: 20.0.sp,
  //                                   ),
  //                                 ),
  //                               Row(
  //                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     size["title"],
  //                                     style: appStyle(
  //                                         14,
  //                                         isSelected ? kDark : kDark,
  //                                         isSelected
  //                                             ? FontWeight.bold
  //                                             : FontWeight.normal),
  //                                   ),
  //                                 ],
  //                               ),
  //                               // SizedBox(height: 5.h),
  //                               Text(
  //                                 "₹${size["price"].toStringAsFixed(2)}",
  //                                 style: appStyle(
  //                                     12,
  //                                     isSelected ? kDark : kDark,
  //                                     isSelected
  //                                         ? FontWeight.bold
  //                                         : FontWeight.normal),
  //                               ),
  //                               Align(
  //                                 alignment: Alignment.centerRight,
  //                                 child: Image.network(
  //                                   size["image"],
  //                                   color: isSelected ? kDark : kDark,
  //                                   height: 40.h,
  //                                   width: 50.w,
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                               SizedBox(height: 5.h),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }




