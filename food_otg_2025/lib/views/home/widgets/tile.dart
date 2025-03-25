// Widget _buildSizeCard(BuildContext context, int selectedIndex) {
//   return Card(
//     color: kWhite,
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Size",
//             style: appStyle(18, kDark, FontWeight.normal),
//           ),
//           ReusableText(
//             text: "Select any 1 option",
//             style: appStyle(13, kGray, FontWeight.w500),
//           ),
//           SizedBox(height: 10.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(widget.food["sizes"].length, (index) {
//                 final size = widget.food["sizes"][index];
//                 final isSelected = selectedIndex == index;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       foodTileController.selectedSizeIndex = index;
//                     });
//                   },
//                   child: Container(
//                     width: 158.w,
//                     height: 105.h,
//                     margin: EdgeInsets.only(right: 8.w),
//                     padding: EdgeInsets.only(left: 8, right: 8, top: 8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: isSelected ? kOffWhite : kWhite,
//                       border: Border.all(color: kGray),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // if (isSelected)
//                         //   Align(
//                         //     alignment: Alignment.centerRight,
//                         //     child: Icon(
//                         //       Icons.check_circle,
//                         //       color: kWhite,
//                         //       size: 20.0.sp,
//                         //     ),
//                         //   ),
//                         Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               // size["title"],
//                               size,
//                               style: appStyle(
//                                   14,
//                                   isSelected ? kDark : kDark,
//                                   isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                             ),
//                             SizedBox(width: 12.w),
//                             Text(
//                               "",
//                               // "${[size["inches"] + "  inches"]}",
//                               style: appStyle(
//                                   11,
//                                   isSelected ? kDark : kDark,
//                                   isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                             ),
//                           ],
//                         ),
//                         // SizedBox(height: 5.h),
//                         Text(
//                           "",
//                           // "₹${size["price"].toStringAsFixed(2)}",
//                           style: appStyle(
//                               12,
//                               isSelected ? kDark : kDark,
//                               isSelected
//                                   ? FontWeight.bold
//                                   : FontWeight.normal),
//                         ),
//                         // Align(
//                         //   alignment: Alignment.centerRight,
//                         //   child: Image.asset(
//                         //     size["image"],
//                         //     color: isSelected ? kDark : kDark,
//                         //     height: 40.h,
//                         //     width: 50.w,
//                         //     fit: BoxFit.cover,
//                         //   ),
//                         // ),
//                         // SizedBox(height: 5.h),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildAddOnCard(BuildContext context) {
//   return Card(
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Add On", style: appStyle(16, kDark, FontWeight.normal)),
//           ReusableText(
//               text: "Select any 2 option",
//               style: appStyle(13, kGray, FontWeight.w500)),
//           Column(
//             children: widget.food["addOns"].map<Widget>((addOn) {
//               // final title = addOn["title"];
//               // final price = addOn["price"];
//               final title = addOn;
//               final isSelected =
//                   foodTileController.selectedAddOns.contains(title);
//               // return _buildSelectItem(title, price, isSelected);
//               return _buildSelectItem(title, isSelected);
//             }).toList(),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildSelectItem(String title, bool isSelected) {
//   return StatefulBuilder(
//     builder: (BuildContext context, StateSetter setState) {
//       return CheckboxListTile(
//         title: Text(title, style: appStyle(14, kDark, FontWeight.normal)),
//         // subtitle: Text("₹${price.toStringAsFixed(2)}",
//         //     style: appStyle(12, kGray, FontWeight.normal)),
//         value: isSelected,
//         activeColor: kRed,
//         onChanged: (value) {
//           setState(() {
//             if (value != null) {
//               foodTileController.toggleAddOn(title);
//             }
//           });
//         },
//         controlAffinity: ListTileControlAffinity.trailing,
//       );
//     },
//   );
// }

// Widget _buildAllergicIngredientsCard(BuildContext context) {
//   return Card(
//     color: kWhite,
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Select Allergic Ingredients",
//               style: appStyle(16, kDark, FontWeight.normal)),
//           SizedBox(height: 5.h),
//           Column(
//               children:
//               (widget.food as List<String>).map<Widget>((ingredientName) {
//                 final isChecked =
//                 foodTileController.selectedAllergicOns.contains(ingredientName);
//                 return _buildAllergicIngredient(ingredientName, isChecked);
//               }).toList()),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildSizeCard(BuildContext context, int selectedIndex) {
//   return Card(
//     color: kWhite,
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Size",
//             style: appStyle(18, kDark, FontWeight.normal),
//           ),
//           ReusableText(
//             text: "Select any 1 option",
//             style: appStyle(13, kGray, FontWeight.w500),
//           ),
//           SizedBox(height: 10.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(widget.food.length, (index) {
//                 final size = widget.food[index];
//                 final isSelected = selectedIndex == index;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       foodTileController.selectedSizeIndex = index;
//                     });
//                   },
//                   child: Container(
//                     width: 158.w,
//                     height: 105.h,
//                     margin: EdgeInsets.only(right: 8.w),
//                     padding: EdgeInsets.only(left: 8, right: 8, top: 8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: isSelected ? kOffWhite : kWhite,
//                       border: Border.all(color: kGray),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               size,
//                               style: appStyle(
//                                   14,
//                                   isSelected ? kDark : kDark,
//                                   isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildAddOnCard(BuildContext context) {
//   return Card(
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Add On", style: appStyle(16, kDark, FontWeight.normal)),
//           ReusableText(
//               text: "Select any 2 option",
//               style: appStyle(13, kGray, FontWeight.w500)),
//           Column(
//             children: (widget.food as List<String>).map<Widget>((addOn) {
//               final isSelected =
//               foodTileController.selectedAddOns.contains(addOn);
//               return _buildSelectItem(addOn, isSelected);
//             }).toList(),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildAllergicIngredientsCard(BuildContext context) {
//   return Card(
//     color: kWhite,
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Select Allergic Ingredients",
//               style: appStyle(16, kDark, FontWeight.normal)),
//           SizedBox(height: 5.h),
//           Column(
//               children:
//                   widget.food["allergicIngredients"].map<Widget>((data) {
//             final ingredientName = data;
//             final isChecked = foodTileController.selectedAllergicOns
//                 .contains(ingredientName);
//             return _buildAllergicIngredient(ingredientName, isChecked);
//           }).toList()),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildSizeCard(BuildContext context, int selectedIndex) {
//   return Card(
//     color: kWhite,
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Size",
//             style: appStyle(18, kDark, FontWeight.normal),
//           ),
//           ReusableText(
//             text: "Select any 1 option",
//             style: appStyle(13, kGray, FontWeight.w500),
//           ),
//           SizedBox(height: 10.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(widget.food["sizes"].length, (index) {
//                 final size = widget.food["sizes"][index];
//                 final isSelected = selectedIndex == index;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       foodTileController.selectedSizeIndex = index;
//                     });
//                   },
//                   child: Container(
//                     width: 158.w,
//                     height: 105.h,
//                     margin: EdgeInsets.only(right: 8.w),
//                     padding: EdgeInsets.only(left: 8, right: 8, top: 8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: isSelected ? kOffWhite : kWhite,
//                       border: Border.all(color: kGray),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (isSelected)
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: Icon(
//                               Icons.check_circle,
//                               color: kWhite,
//                               size: 20.0.sp,
//                             ),
//                           ),
//                         Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               // size["title"],
//                               size,
//                               style: appStyle(
//                                   14,
//                                   isSelected ? kDark : kDark,
//                                   isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                             ),
//                             SizedBox(width: 12.w),
//                             Text(
//                               "${[size["inches"] + "  inches"]}",
//                               style: appStyle(
//                                   11,
//                                   isSelected ? kDark : kDark,
//                                   isSelected
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                             ),
//                           ],
//                         ),
//                         // SizedBox(height: 5.h),
//                         Text(
//                           "",
//                           // "₹${size["price"].toStringAsFixed(2)}",
//                           style: appStyle(12, isSelected ? kDark : kDark,
//                               isSelected ? FontWeight.bold : FontWeight.normal),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Image.asset(
//                             size["image"],
//                             color: isSelected ? kDark : kDark,
//                             height: 40.h,
//                             width: 50.w,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(height: 5.h),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
  
  // Widget _buildAddOnCard(BuildContext context) {
  //   return Card(
  //     child: Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Add On", style: appStyle(16, kDark, FontWeight.normal)),
  //           ReusableText(
  //               text: "Select any 2 option",
  //               style: appStyle(13, kGray, FontWeight.w500)),
  //           Column(
  //             children: widget.food["addOns"].map<Widget>((addOn) {
  //               // final title = addOn["title"];
  //               // final price = addOn["price"];
  //               final title = addOn;
  //               final isSelected =
  //                   foodTileController.selectedAddOns.contains(title);
  //               // return _buildSelectItem(title, price, isSelected);
  //               return _buildSelectItem(title, isSelected);
  //             }).toList(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSelectItem(String title, bool isSelected) {
  //   return StatefulBuilder(
  //     builder: (BuildContext context, StateSetter setState) {
  //       return CheckboxListTile(
  //         title: Text(title, style: appStyle(14, kDark, FontWeight.normal)),
  //         // subtitle: Text("₹${price.toStringAsFixed(2)}",
  //         //     style: appStyle(12, kGray, FontWeight.normal)),
  //         value: isSelected,
  //         activeColor: kRed,
  //         onChanged: (value) {
  //           setState(() {
  //             if (value != null) {
  //               foodTileController.toggleAddOn(title);
  //             }
  //           });
  //         },
  //         controlAffinity: ListTileControlAffinity.trailing,
  //       );
  //     },
  //   );
  // }