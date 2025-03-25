// // import 'dart:developer';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:food_otg/common/reusable_text.dart';
// // import 'package:food_otg/services/collection_refrences.dart';
// // import 'package:food_otg/utils/app_styles.dart';
// // import 'package:food_otg/utils/toast_msg.dart';
// // import 'package:food_otg/views/address/address_management_screen.dart';
// // import 'package:food_otg/views/profile/profile_screen.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:get/get.dart';
// // import '../constants/constants.dart';
// // import 'package:location/location.dart' as loc;
// // import 'package:location/location.dart';

// // class CustomAppBar extends StatefulWidget {
// //   const CustomAppBar({super.key});

// //   @override
// //   State<CustomAppBar> createState() => _CustomAppBarState();
// // }

// // class _CustomAppBarState extends State<CustomAppBar> {
// //   String appbarTitle = "";
// //   bool isLocationSet = false;
// //   double? userLat;
// //   double? userLong;
// //   LocationData? currentLocation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     checkIfLocationIsSet();
// //   }

// //   Future<void> checkIfLocationIsSet() async {
// //     try {
// //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
// //           .collection('Users')
// //           .doc(currentUId)
// //           .get();

// //       if (userDoc.exists && userDoc.data() != null) {
// //         var data = userDoc.data() as Map<String, dynamic>;
// //         if (data.containsKey('isLocationSet') &&
// //             data['isLocationSet'] == true) {
// //           // Location is already set, fetch the current address
// //           fetchCurrentAddress();
// //         } else {
// //           // Location is not set, fetch and update current location
// //           fetchUserCurrentLocationAndUpdateToFirebase();
// //         }
// //       } else {
// //         // Document doesn't exist, fetch and update current location
// //         fetchUserCurrentLocationAndUpdateToFirebase();
// //       }
// //     } catch (e) {
// //       log("Error checking location set status: $e");
// //     }
// //   }

// //   Future<void> fetchCurrentAddress() async {
// //     try {
// //       QuerySnapshot addressSnapshot = await FirebaseFirestore.instance
// //           .collection('Users')
// //           .doc(currentUId)
// //           .collection("Addresses")
// //           .where('isAddressSelected', isEqualTo: true)
// //           .get();

// //       if (addressSnapshot.docs.isNotEmpty) {
// //         var addressData =
// //             addressSnapshot.docs.first.data() as Map<String, dynamic>;
// //         setState(() {
// //           appbarTitle = addressData['address'];
// //         });
// //       }
// //     } catch (e) {
// //       log("Error fetching current address: $e");
// //     }
// //   }

// //   //====================== Fetching user current location =====================
// //   void fetchUserCurrentLocationAndUpdateToFirebase() async {
// //     loc.Location location = loc.Location();
// //     bool serviceEnabled;
// //     PermissionStatus permissionGranted;

// //     // Check if location services are enabled
// //     serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       showToastMessage(
// //         "Location Error",
// //         "Please enable location Services",
// //         kRed,
// //       );
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) {
// //         return;
// //       }
// //     }

// //     // Check if location permissions are granted
// //     permissionGranted = await location.hasPermission();
// //     if (permissionGranted == loc.PermissionStatus.denied) {
// //       showToastMessage(
// //         "Error",
// //         "Please grant location permission in app settings",
// //         kRed,
// //       );
// //       // Open app settings to grant permission
// //       await loc.Location().requestPermission();
// //       permissionGranted = await location.hasPermission();
// //       if (permissionGranted != loc.PermissionStatus.granted) {
// //         return;
// //       }
// //     }

// //     // Get the current location
// //     currentLocation = await location.getLocation();

// //     // Get the address from latitude and longitude
// //     String address = await _getAddressFromLatLng(
// //       "LatLng(${currentLocation!.latitude}, ${currentLocation!.longitude})",
// //     );
// //     print(address);

// //     // Update the app bar with the current address
// //     setState(() {
// //       appbarTitle = address;
// //       log(appbarTitle);
// //       log(currentLocation!.latitude.toString());
// //       log(currentLocation!.longitude.toString());
// //       userLat = currentLocation!.latitude;
// //       userLong = currentLocation!.longitude;
// //       log(userLat.toString());
// //       log(userLong.toString());
// //       // Update the Firestore document with the current location
// //       saveUserLocation(
// //         currentLocation!.latitude!,
// //         currentLocation!.longitude!,
// //         appbarTitle,
// //       );
// //     });
// //   }

// //   void saveUserLocation(double latitude, double longitude, String userAddress) {
// //     FirebaseFirestore.instance.collection('Users').doc(currentUId).set({
// //       'isLocationSet': true,
// //     }, SetOptions(merge: true));

// //     FirebaseFirestore.instance
// //         .collection('Users')
// //         .doc(currentUId)
// //         .collection("Addresses")
// //         .add({
// //       'address': userAddress,
// //       'location': {
// //         'latitude': latitude,
// //         'longitude': longitude,
// //       },
// //       'addressType': "Current",
// //       "isAddressSelected": true,
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () async {
// //         var selectedAddress = await Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => AddressManagementScreen(
// //               userLat: userLat ?? 30.6599315,
// //               userLng: userLong ?? 76.8481318,
// //             ),
// //           ),
// //         );

// //         if (selectedAddress != null) {
// //           setState(() {
// //             appbarTitle = selectedAddress['address'];
// //           });
// // // Update the selected address in Firestore
// //           // Update the selected address in Firestore
// //           FirebaseFirestore.instance
// //               .collection('Users')
// //               .doc(currentUId)
// //               .collection('Addresses')
// //               .get()
// //               .then((querySnapshot) {
// //             WriteBatch batch = FirebaseFirestore.instance.batch();

// //             for (var doc in querySnapshot.docs) {
// //               // Update all addresses to set isAddressSelected to false
// //               batch.update(doc.reference, {'isAddressSelected': false});
// //             }

// //             // Update the selected address to set isAddressSelected to true
// //             batch.update(
// //               FirebaseFirestore.instance
// //                   .collection('Users')
// //                   .doc(currentUId)
// //                   .collection('Addresses')
// //                   .doc(selectedAddress['id']),
// //               {'isAddressSelected': true},
// //             );

// //             // Commit the batch write
// //             batch.commit();
// //           });
// //         }
// //       },
// //       child: Container(
// //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
// //         height: 90.h,
// //         width: MediaQuery.of(context).size.width,
// //         color: kOffWhite,
// //         child: Container(
// //           margin: EdgeInsets.only(top: 10.h),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   Icon(Icons.location_on, color: kSecondary, size: 35.sp),
// //                   Padding(
// //                     padding: EdgeInsets.only(bottom: 4.h, left: 5.w),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.end,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         ReusableText(
// //                             text: "Deliver to",
// //                             style: appStyle(12, kSecondary, FontWeight.bold)),
// //                         SizedBox(
// //                           width: MediaQuery.of(context).size.width * 0.65,
// //                           child: Text(
// //                             appbarTitle.isEmpty
// //                                 ? "Fetching Addresses....."
// //                                 : appbarTitle,
// //                             overflow: TextOverflow.ellipsis,
// //                             style: appStyle(10, kDark, FontWeight.normal),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               GestureDetector(
// //                 onTap: () => Get.to(() => ProfileScreen(),
// //                     transition: Transition.cupertino,
// //                     duration: const Duration(milliseconds: 900)),
// //                 child: CircleAvatar(
// //                   radius: 19.r,
// //                   backgroundColor: kSecondary,
// //                   child: StreamBuilder<DocumentSnapshot>(
// //                     stream: FirebaseFirestore.instance
// //                         .collection('Users')
// //                         .doc(currentUId)
// //                         .snapshots(),
// //                     builder: (BuildContext context,
// //                         AsyncSnapshot<DocumentSnapshot> snapshot) {
// //                       if (snapshot.hasError) {
// //                         return Text('Error: ${snapshot.error}');
// //                       }

// //                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                         return CircularProgressIndicator();
// //                       }

// //                       final data =
// //                           snapshot.data!.data() as Map<String, dynamic>;
// //                       final profileImageUrl = data['profilePicture'] ?? '';
// //                       final userName = data['userName'] ?? '';

// //                       if (profileImageUrl.isEmpty) {
// //                         return Text(
// //                           userName.isNotEmpty ? userName[0] : '',
// //                           style: appStyle(20, kWhite, FontWeight.bold),
// //                         );
// //                       } else {
// //                         return ClipOval(
// //                           child: Image.network(
// //                             profileImageUrl,
// //                             width: 38.r, // Set appropriate size for the image
// //                             height: 38.r,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   String getTimeOfDay() {
// //     DateTime now = DateTime.now();
// //     int hour = now.hour;

// //     if (hour >= 0 && hour < 12) {
// //       return " 🌞 ";
// //     } else if (hour >= 12 && hour < 16) {
// //       return " ⛅ ";
// //     } else {
// //       return " 🌙 ";
// //     }
// //   }

// //   //================= Convert latlang to actual address =========================
// //   Future<String> _getAddressFromLatLng(String latLngString) async {
// //     // Assuming latLngString format is 'LatLng(x.x, y.y)'
// //     final coords = latLngString.split(', ');
// //     final latitude = double.parse(coords[0].split('(').last);
// //     final longitude = double.parse(coords[1].split(')').first);

// //     List<Placemark> placemarks =
// //         await placemarkFromCoordinates(latitude, longitude);

// //     if (placemarks.isNotEmpty) {
// //       final Placemark pm = placemarks.first;
// //       return "${pm.name}, ${pm.locality}, ${pm.administrativeArea}";
// //     }
// //     return '';
// //   }
// // }



// // // import 'dart:developer';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:food_otg/common/reusable_text.dart';
// // // import 'package:food_otg/services/collection_refrences.dart';
// // // import 'package:food_otg/utils/app_styles.dart';
// // // import 'package:food_otg/utils/toast_msg.dart';
// // // import 'package:food_otg/views/profile/profile_screen.dart';
// // // import 'package:geocoding/geocoding.dart';
// // // import 'package:get/get.dart';
// // // import '../constants/constants.dart';
// // // import 'package:location/location.dart' as loc;
// // // import 'package:location/location.dart';

// // // class CustomAppBar extends StatefulWidget {
// // //   const CustomAppBar({super.key});

// // //   @override
// // //   State<CustomAppBar> createState() => _CustomAppBarState();
// // // }

// // // class _CustomAppBarState extends State<CustomAppBar> {
// // //   String appbarTitle = "";

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchUserCurrentLocationAndUpdateToFirebase();
// // //   }

// // //   //====================== Fetching user current location =====================
// // //   void fetchUserCurrentLocationAndUpdateToFirebase() async {
// // //     loc.Location location = loc.Location();
// // //     bool serviceEnabled;
// // //     PermissionStatus permissionGranted;

// // //     // Check if location services are enabled
// // //     serviceEnabled = await location.serviceEnabled();
// // //     if (!serviceEnabled) {
// // //       showToastMessage(
// // //           "Location Error", "Please enable location Services", kRed);
// // //       serviceEnabled = await location.requestService();
// // //       if (!serviceEnabled) {
// // //         return;
// // //       }
// // //     }

// // //     // Check if location permissions are granted
// // //     permissionGranted = await location.hasPermission();
// // //     if (permissionGranted == loc.PermissionStatus.denied) {
// // //       showToastMessage(
// // //           "Error", "Please grant location permission in app settings", kRed);
// // //       // Open app settings to grant permission
// // //       await loc.Location().requestPermission();
// // //       permissionGranted = await location.hasPermission();
// // //       permissionGranted = await location.requestPermission();
// // //       if (permissionGranted != loc.PermissionStatus.granted) {
// // //         return;
// // //       }
// // //     }

// // //     // Get the current location
// // //     loc.LocationData locationData = await location.getLocation();

// // //     // Get the address from latitude and longitude
// // //     String address = await _getAddressFromLatLng(
// // //         "LatLng(${locationData.latitude}, ${locationData.longitude})");
// // //     print(address);

// // //     // Update the app bar with the current address
// // //     setState(() {
// // //       appbarTitle = address;
// // //       log(appbarTitle);
// // //       log(locationData.latitude.toString());
// // //       log(locationData.longitude.toString());
// // //       // Update the Firestore document with the current location
// // //       saveUserLocation(
// // //           locationData.latitude!, locationData.longitude!, appbarTitle);
// // //     });
// // //   }

// // //   void saveUserLocation(double latitude, double longitude, String userAddress) {
// // //     FirebaseFirestore.instance
// // //         .collection('Users')
// // //         .doc(currentUId)
// // //         .collection("Addresses")
// // //         .add({
// // //       'address': userAddress,
// // //       'location': {
// // //         'latitude': latitude,
// // //         'longitude': longitude,
// // //       },
// // //       'addressType': "Current",
// // //       "isAddressSelected": true,
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
// // //       height: 90.h,
// // //       width: width,
// // //       color: kOffWhite,
// // //       child: Container(
// // //         margin: EdgeInsets.only(top: 10.h),
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //           crossAxisAlignment: CrossAxisAlignment.end,
// // //           children: [
// // //             Row(
// // //               crossAxisAlignment: CrossAxisAlignment.end,
// // //               children: [
// // //                 Icon(Icons.location_on, color: kSecondary, size: 35.sp),
// // //                 Padding(
// // //                   padding: EdgeInsets.only(bottom: 4.h, left: 5.w),
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.end,
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       ReusableText(
// // //                           text: "Deliver to",
// // //                           style: appStyle(12, kSecondary, FontWeight.bold)),
// // //                       SizedBox(
// // //                         width: width * 0.65,
// // //                         child: Text(
// // //                           appbarTitle.isEmpty
// // //                               ? "Fetching Addresses....."
// // //                               : appbarTitle,
// // //                           overflow: TextOverflow.ellipsis,
// // //                           style: appStyle(10, kDark, FontWeight.normal),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             GestureDetector(
// // //               onTap: () => Get.to(() => ProfileScreen(),
// // //                   transition: Transition.cupertino,
// // //                   duration: const Duration(milliseconds: 900)),
// // //               child: CircleAvatar(
// // //                 radius: 19.r,
// // //                 backgroundColor: kSecondary,
// // //                 child: StreamBuilder<DocumentSnapshot>(
// // //                   stream: FirebaseFirestore.instance
// // //                       .collection('Users')
// // //                       .doc(currentUId)
// // //                       .snapshots(),
// // //                   builder: (BuildContext context,
// // //                       AsyncSnapshot<DocumentSnapshot> snapshot) {
// // //                     if (snapshot.hasError) {
// // //                       return Text('Error: ${snapshot.error}');
// // //                     }

// // //                     if (snapshot.connectionState == ConnectionState.waiting) {
// // //                       return CircularProgressIndicator();
// // //                     }

// // //                     final data = snapshot.data!.data() as Map<String, dynamic>;
// // //                     final profileImageUrl = data['profilePicture'] ?? '';
// // //                     final userName = data['userName'] ?? '';

// // //                     if (profileImageUrl.isEmpty) {
// // //                       return Text(
// // //                         userName.isNotEmpty ? userName[0] : '',
// // //                         style: appStyle(20, kWhite, FontWeight.bold),
// // //                       );
// // //                     } else {
// // //                       return ClipOval(
// // //                         child: Image.network(
// // //                           profileImageUrl,
// // //                           width: 38.r, // Set appropriate size for the image
// // //                           height: 38.r,
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       );
// // //                     }
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   String getTimeOfDay() {
// // //     DateTime now = DateTime.now();
// // //     int hour = now.hour;

// // //     if (hour >= 0 && hour < 12) {
// // //       return " 🌞 ";
// // //     } else if (hour >= 12 && hour < 16) {
// // //       return " ⛅ ";
// // //     } else {
// // //       return " 🌙 ";
// // //     }
// // //   }

// // //   //================= Convert latlang to actual address =========================
// // //   Future<String> _getAddressFromLatLng(String latLngString) async {
// // //     // Assuming latLngString format is 'LatLng(x.x, y.y)'
// // //     final coords = latLngString.split(', ');
// // //     final latitude = double.parse(coords[0].split('(').last);
// // //     final longitude = double.parse(coords[1].split(')').first);

// // //     List<Placemark> placemarks =
// // //         await placemarkFromCoordinates(latitude, longitude);

// // //     if (placemarks.isNotEmpty) {
// // //       final Placemark pm = placemarks.first;
// // //       return "${pm.name}, ${pm.locality}, ${pm.administrativeArea}";
// // //     }
// // //     return '';
// // //   }
// // // }



// class CustomAppBar extends StatefulWidget {
//   const CustomAppBar({super.key, required this.onAddressChanged});
//   final VoidCallback onAddressChanged;

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   String appbarTitle = "";
//   bool isLocationSet = false;
//   double? userLat;
//   double? userLong;
//   LocationData? currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     checkIfLocationIsSet();
//   }

//   Future<void> checkIfLocationIsSet() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUId)
//           .get();

//       if (userDoc.exists && userDoc.data() != null) {
//         var data = userDoc.data() as Map<String, dynamic>;
//         if (data.containsKey('isLocationSet') &&
//             data['isLocationSet'] == true) {
//           // Location is already set, fetch the current address
//           fetchCurrentAddress();
//         } else {
//           // Location is not set, fetch and update current location
//           fetchUserCurrentLocationAndUpdateToFirebase();
//         }
//       } else {
//         // Document doesn't exist, fetch and update current location
//         fetchUserCurrentLocationAndUpdateToFirebase();
//       }
//     } catch (e) {
//       log("Error checking location set status: $e");
//     }
//   }

//   Future<void> fetchCurrentAddress() async {
//     try {
//       QuerySnapshot addressSnapshot = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUId)
//           .collection("Addresses")
//           .where('isAddressSelected', isEqualTo: true)
//           .get();

//       if (addressSnapshot.docs.isNotEmpty) {
//         var addressData =
//             addressSnapshot.docs.first.data() as Map<String, dynamic>;
//         setState(() {
//           appbarTitle = addressData['address'];
//         });
//       }
//     } catch (e) {
//       log("Error fetching current address: $e");
//     }
//   }

//   //====================== Fetching user current location =====================
//   void fetchUserCurrentLocationAndUpdateToFirebase() async {
//     loc.Location location = loc.Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     // Check if location services are enabled
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       showToastMessage(
//         "Location Error",
//         "Please enable location Services",
//         kRed,
//       );
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     // Check if location permissions are granted
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == loc.PermissionStatus.denied) {
//       showToastMessage(
//         "Error",
//         "Please grant location permission in app settings",
//         kRed,
//       );
//       // Open app settings to grant permission
//       await loc.Location().requestPermission();
//       permissionGranted = await location.hasPermission();
//       if (permissionGranted != loc.PermissionStatus.granted) {
//         return;
//       }
//     }

//     // Get the current location
//     currentLocation = await location.getLocation();

//     // Get the address from latitude and longitude
//     String address = await _getAddressFromLatLng(
//       "LatLng(${currentLocation!.latitude}, ${currentLocation!.longitude})",
//     );
//     print(address);

//     // Update the app bar with the current address
//     setState(() {
//       appbarTitle = address;
//       log(appbarTitle);
//       log(currentLocation!.latitude.toString());
//       log(currentLocation!.longitude.toString());
//       userLat = currentLocation!.latitude;
//       userLong = currentLocation!.longitude;
//       log(userLat.toString());
//       log(userLong.toString());
//       // Update the Firestore document with the current location
//       saveUserLocation(
//         currentLocation!.latitude!,
//         currentLocation!.longitude!,
//         appbarTitle,
//       );
//     });
//   }

//   void saveUserLocation(double latitude, double longitude, String userAddress) {
//     FirebaseFirestore.instance.collection('Users').doc(currentUId).set({
//       'isLocationSet': true,
//     }, SetOptions(merge: true));

//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUId)
//         .collection("Addresses")
//         .add({
//       'address': userAddress,
//       'location': {
//         'latitude': latitude,
//         'longitude': longitude,
//       },
//       'addressType': "Current",
//       "isAddressSelected": true,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         var selectedAddress = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AddressManagementScreen(
//               userLat: userLat ?? 30.6599315,
//               userLng: userLong ?? 76.8481318,
//             ),
//           ),
//         );

//         if (selectedAddress != null) {
//           setState(() {
//             appbarTitle = selectedAddress['address'];
//           });
// // Update the selected address in Firestore
//           // Update the selected address in Firestore
//           FirebaseFirestore.instance
//               .collection('Users')
//               .doc(currentUId)
//               .collection('Addresses')
//               .get()
//               .then((querySnapshot) {
//             WriteBatch batch = FirebaseFirestore.instance.batch();

//             for (var doc in querySnapshot.docs) {
//               // Update all addresses to set isAddressSelected to false
//               batch.update(doc.reference, {'isAddressSelected': false});
//             }

//             // Update the selected address to set isAddressSelected to true
//             batch.update(
//               FirebaseFirestore.instance
//                   .collection('Users')
//                   .doc(currentUId)
//                   .collection('Addresses')
//                   .doc(selectedAddress['id']),
//               {'isAddressSelected': true},
//             );

//             // Commit the batch write
//             batch.commit().then((value) {
//               widget.onAddressChanged();
//               setState(() {});
//             });
//           });
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
//         height: 90.h,
//         width: MediaQuery.of(context).size.width,
//         color: kOffWhite,
//         child: Container(
//           margin: EdgeInsets.only(top: 10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Icon(Icons.location_on, color: kSecondary, size: 35.sp),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 4.h, left: 5.w),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ReusableText(
//                             text: "Deliver to",
//                             style: appStyle(12, kSecondary, FontWeight.bold)),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.65,
//                           child: Text(
//                             appbarTitle.isEmpty
//                                 ? "Fetching Addresses....."
//                                 : appbarTitle,
//                             overflow: TextOverflow.ellipsis,
//                             style: appStyle(10, kDark, FontWeight.normal),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () => Get.to(() => ProfileScreen(),
//                     transition: Transition.cupertino,
//                     duration: const Duration(milliseconds: 900)),
//                 child: CircleAvatar(
//                   radius: 19.r,
//                   backgroundColor: kSecondary,
//                   child: StreamBuilder<DocumentSnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('Users')
//                         .doc(currentUId)
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<DocumentSnapshot> snapshot) {
//                       if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       }

//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       }

//                       final data =
//                           snapshot.data!.data() as Map<String, dynamic>;
//                       final profileImageUrl = data['profilePicture'] ?? '';
//                       final userName = data['userName'] ?? '';

//                       if (profileImageUrl.isEmpty) {
//                         return Text(
//                           userName.isNotEmpty ? userName[0] : '',
//                           style: appStyle(20, kWhite, FontWeight.bold),
//                         );
//                       } else {
//                         return ClipOval(
//                           child: Image.network(
//                             profileImageUrl,
//                             width: 38.r, // Set appropriate size for the image
//                             height: 38.r,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String getTimeOfDay() {
//     DateTime now = DateTime.now();
//     int hour = now.hour;

//     if (hour >= 0 && hour < 12) {
//       return " 🌞 ";
//     } else if (hour >= 12 && hour < 16) {
//       return " ⛅ ";
//     } else {
//       return " 🌙 ";
//     }
//   }

//   //================= Convert latlang to actual address =========================
//   Future<String> _getAddressFromLatLng(String latLngString) async {
//     // Assuming latLngString format is 'LatLng(x.x, y.y)'
//     final coords = latLngString.split(', ');
//     final latitude = double.parse(coords[0].split('(').last);
//     final longitude = double.parse(coords[1].split(')').first);

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);

//     if (placemarks.isNotEmpty) {
//       final Placemark pm = placemarks.first;
//       return "${pm.name}, ${pm.locality}, ${pm.administrativeArea}";
//     }
//     return '';
//   }
// }
