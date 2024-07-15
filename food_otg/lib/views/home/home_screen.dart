import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_otg/views/checkout/checkout_functionality.dart';
import 'package:food_otg/views/home/widgets/category_list_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/constants.dart';
import '../../services/collection_refrences.dart';
import '../../utils/app_styles.dart';
import 'dart:developer';
import 'package:food_otg/common/reusable_text.dart';
import 'package:food_otg/utils/toast_msg.dart';
import 'package:food_otg/views/address/address_management_screen.dart';
import 'package:food_otg/views/profile/profile_screen.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  // bool _showMenu = false;
  String searchText = '';
  String appbarTitle = "";
  bool searchingRestaurants = false;
  bool restaurantInRange = false;
  bool firstTimeAppLaunch = true; // Boolean flag to track first app launch
  bool isLocationSet = false;
  double userLat = 0.0;
  double userLong = 0.0;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    checkIfLocationIsSet();
    fetchNearByRestaurantsLocation();
  }

  Future<void> checkIfLocationIsSet() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('isLocationSet') &&
            data['isLocationSet'] == true) {
          // Location is already set, fetch the current address
          fetchCurrentAddress();
        } else {
          // Location is not set, fetch and update current location
          fetchUserCurrentLocationAndUpdateToFirebase();
        }
      } else {
        // Document doesn't exist, fetch and update current location
        fetchUserCurrentLocationAndUpdateToFirebase();
      }
    } catch (e) {
      log("Error checking location set status: $e");
    }
  }

  Future<void> fetchCurrentAddress() async {
    try {
      QuerySnapshot addressSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUId)
          .collection("Addresses")
          .where('isAddressSelected', isEqualTo: true)
          .get();

      if (addressSnapshot.docs.isNotEmpty) {
        var addressData =
            addressSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          appbarTitle = addressData['address'];
        });
      }
    } catch (e) {
      log("Error fetching current address: $e");
    }
  }

  //====================== Fetching user current location =====================
  void fetchUserCurrentLocationAndUpdateToFirebase() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      showToastMessage(
        "Location Error",
        "Please enable location Services",
        kRed,
      );
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if location permissions are granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      showToastMessage(
        "Error",
        "Please grant location permission in app settings",
        kRed,
      );
      // Open app settings to grant permission
      await loc.Location().requestPermission();
      permissionGranted = await location.hasPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    currentLocation = await location.getLocation();

    // Get the address from latitude and longitude
    String address = await _getAddressFromLatLng(
      "LatLng(${currentLocation!.latitude}, ${currentLocation!.longitude})",
    );
    print(address);

    // Update the app bar with the current address
    setState(() {
      appbarTitle = address;
      log(appbarTitle);
      log(currentLocation!.latitude.toString());
      log(currentLocation!.longitude.toString());
      // Update the Firestore document with the current location
      saveUserLocation(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
        appbarTitle,
      );
    });
  }

  void saveUserLocation(double latitude, double longitude, String userAddress) {
    FirebaseFirestore.instance.collection('Users').doc(currentUId).set({
      'isLocationSet': true,
    }, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection("Addresses")
        .add({
      'address': userAddress,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'addressType': "Current",
      "isAddressSelected": true,
    });
  }

//=========================== Fetch Restaurant location ==========================

  Future<void> fetchNearByRestaurantsLocation() async {
    setState(() {
      searchingRestaurants = true;
    });

    int delaySeconds =
        firstTimeAppLaunch ? 4 : 3; // Determine delay based on first app launch

    await Future.delayed(Duration(seconds: delaySeconds)); // Introduce delay

    bool restaurantFound = false;
    bool hasAddresses = false;

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUId)
          .collection("Addresses")
          .where("isAddressSelected", isEqualTo: true)
          .get();

      // Check if the user has any selected addresses
      if (userSnapshot.docs.isNotEmpty) {
        hasAddresses = true;
        for (var addressDoc in userSnapshot.docs) {
          double userLatitude = addressDoc.data()['location']['latitude'];
          double userLongitude = addressDoc.data()['location']['longitude'];
          setState(() {
            userLat = userLatitude;
            userLong = userLongitude;
            log("User Lat Data: " + userLat.toString());
            log("User Lng Data: " + userLong.toString());
          });

          final restaurantsSnapshot = await FirebaseFirestore.instance
              .collection('Restaurants')
              .where("active", isEqualTo: true)
              .get();

          // Loop through each restaurant document
          for (var restaurantDoc in restaurantsSnapshot.docs) {
            double restaurantLatitude =
                restaurantDoc.data()['locationLatLng'].latitude;
            double restaurantLongitude =
                restaurantDoc.data()['locationLatLng'].longitude;

            double distance = calculateDistance(userLatitude, userLongitude,
                restaurantLatitude, restaurantLongitude);

            log("User Lat Long " +
                userLatitude.toString() +
                " " +
                userLongitude.toString());
            log("Restaurant Lat Long " +
                restaurantLatitude.toString() +
                " " +
                restaurantLongitude.toString());

            log("Total distance in km ${distance.toStringAsFixed(2)} km");

            if (distance <= 5) {
              log("Restaurant is within 5km range");
              restaurantFound = true;
              break; // Exit the inner loop if a nearby restaurant is found
            }
          }

          if (restaurantFound) {
            break; // Exit the outer loop if a nearby restaurant is found
          }
        }
      }

      setState(() {
        searchingRestaurants = false;
        restaurantInRange = restaurantFound;
      });

      if (!hasAddresses) {
        showToastMessage("No Addresses", "Please select an address.", kRed);
      } else if (!restaurantFound) {
        showToastMessage("Not Found", "No Restaurant available near.", kRed);
      }

      // Update firstTimeAppLaunch flag after first app launch
      firstTimeAppLaunch = false;
    } catch (e) {
      log("Error fetching restaurant location: $e");
      setState(() {
        searchingRestaurants = false;
      });
      showToastMessage("Error", "Failed to fetch restaurants", kRed);
    }
  }

  _onAddressChanged() {
    setState(() {
      searchingRestaurants = true;
    });
    fetchNearByRestaurantsLocation(); // Call fetchNearByRestaurantsLocation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kPrimary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: GestureDetector(
          onTap: () async {
            var selectedAddress = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressManagementScreen(
                  userLat: userLat,
                  userLng: userLong,
                ),
              ),
            );

            if (selectedAddress != null) {
              setState(() {
                appbarTitle = selectedAddress['address'];
              });
// Update the selected address in Firestore
              // Update the selected address in Firestore
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUId)
                  .collection('Addresses')
                  .get()
                  .then((querySnapshot) {
                WriteBatch batch = FirebaseFirestore.instance.batch();

                for (var doc in querySnapshot.docs) {
                  log("Selected Address Id : " +
                      selectedAddress["id"].toString());
                  // Update all addresses to set isAddressSelected to false
                  batch.update(doc.reference, {'isAddressSelected': false});
                }

                // Update the selected address to set isAddressSelected to true
                batch.update(
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUId)
                      .collection('Addresses')
                      .doc(selectedAddress["id"]),
                  {'isAddressSelected': true},
                );

                // Commit the batch write
                batch.commit().then((value) {
                  _onAddressChanged();
                });
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            height: 90.h,
            width: MediaQuery.of(context).size.width,
            color: kOffWhite,
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on, color: kSecondary, size: 35.sp),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h, left: 5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                                text: "Deliver to",
                                style:
                                    appStyle(12, kSecondary, FontWeight.bold)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                appbarTitle.isEmpty
                                    ? "Fetching Addresses....."
                                    : appbarTitle,
                                overflow: TextOverflow.ellipsis,
                                style: appStyle(10, kDark, FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => ProfileScreen(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 900)),
                    child: CircleAvatar(
                      radius: 19.r,
                      backgroundColor: kSecondary,
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(currentUId)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final profileImageUrl = data['profilePicture'] ?? '';
                          final userName = data['userName'] ?? '';

                          if (profileImageUrl.isEmpty) {
                            return Text(
                              userName.isNotEmpty ? userName[0] : '',
                              style: appStyle(20, kWhite, FontWeight.bold),
                            );
                          } else {
                            return ClipOval(
                              child: Image.network(
                                profileImageUrl,
                                width:
                                    38.r, // Set appropriate size for the image
                                height: 38.r,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchNearByRestaurantsLocation();
        },
        child: searchingRestaurants
            ? Center(child: CircularProgressIndicator())
            : restaurantInRange
                ? Stack(
                    children: [
                      Stack(
                        children: [
                          //our body section
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTopSearchBar(),
                                  SizedBox(height: 2.h),
                                  buildImageSlider(),
                                  SizedBox(height: 5.h),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Text("Tasty food near to you",
                                        style: AppFontStyles.font18Style
                                            .copyWith(
                                                color: kDark,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  // SizedBox(height: 5.h),
                                  CategoryListWidget(searchText: searchText),
                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "At present, we are not serviceable in your area. We wish to be there very soon. Thank you!",
                        style: appStyle(17, kDark, FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
      ),
    );
  }

  /**-------------------------- Build Top Search Bar ----------------------------------**/
  Widget buildTopSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.h),
          border: Border.all(color: kGrayLight),
          boxShadow: [
            BoxShadow(
              color: kLightWhite,
              spreadRadius: 0.2,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search by Category",
              prefixIcon: Icon(Icons.search),
              prefixStyle: appStyle(14, kDark, FontWeight.w200)),
        ),
      ),
    );
  }

  /**--------------------------- Build Carousel Slider ----------------------------**/
  Widget buildImageSlider() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("homeSliders")
          .where("active", isEqualTo: true)
          .orderBy("priority")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final sliderDocs = snapshot.data!.docs;
          return Container(
            height: 160.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: CarouselSlider(
              items: sliderDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    data['img'],
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return _buildPlaceholder(); // Display placeholder while loading
                      }
                    },
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: true,
                autoPlay: true,
                aspectRatio: 16 / 6.4,
                viewportFraction: 1,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child:
          CircularProgressIndicator(), // You can use any widget as a placeholder
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 160.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 120.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //================= Convert latlang to actual address =========================
  Future<String> _getAddressFromLatLng(String latLngString) async {
    // Assuming latLngString format is 'LatLng(x.x, y.y)'
    final coords = latLngString.split(', ');
    final latitude = double.parse(coords[0].split('(').last);
    final longitude = double.parse(coords[1].split(')').first);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      final Placemark pm = placemarks.first;
      return "${pm.name}, ${pm.locality}, ${pm.administrativeArea}";
    }
    return '';
  }
}
