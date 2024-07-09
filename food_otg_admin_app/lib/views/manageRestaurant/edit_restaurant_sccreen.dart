import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:food_otg_admin_app/utils/toast_msg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/custom_gradient_button.dart';
import '../../constants/constants.dart';
import '../manageManager/pick_location_from_map.dart';
import 'package:http/http.dart' as http;

class EditRestaurantScreen extends StatefulWidget {
  final String resName;
  final String id;
  final Map<String, dynamic> resData;
  const EditRestaurantScreen({
    super.key,
    required this.resName,
    required this.resData,
    required this.id,
  });

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _resNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _isLoading = false;
  bool _isUploading = false;
  double? selectedLat;
  double? selectedLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchResturantDetails();
  }

  fetchResturantDetails() async {
    try {
      setState(() {
        _isLoading = true; // Add this line
      });
      DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(widget.id)
          .get();

      log("res id is ${widget.id}");

      if (itemSnapshot.exists) {
        setState(() {
          // Update controller values with fetched data
          _contactController.text = itemSnapshot.get("contact");
          _resNameController.text = itemSnapshot.get("res_name");
          _locationController.text = itemSnapshot.get("locationAddress");
          _latitudeController.text =
              itemSnapshot.get("locationLatLng").latitude.toString();
          _longitudeController.text =
              itemSnapshot.get("locationLatLng").longitude.toString();
          setState(() {
            _isLoading = false;
          });
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Set isLoading to false even in case of error
      });
      log(e.toString());
      showToastMessage("Error", e.toString(), kRed);
    }
  }

  Future<void> selectAddressFromMap() async {
    LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectLocationScreen(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        selectedLat = selectedLocation.latitude;
        selectedLng = selectedLocation.longitude;
      });
      String address = await getAddressFromLatLng(selectedLat!, selectedLng!);
      _locationController.text = address;
      _latitudeController.text = selectedLat.toString();
      _longitudeController.text = selectedLng.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: kDark,
        title: Text(
          "Edit Restaurant",
          style: appStyle(18, kSecondary, FontWeight.normal),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: kIsWeb
                    ? const EdgeInsets.only(left: 450, right: 450, top: 50)
                    : const EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                  color: kLightWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextFormField(_contactController, "Enter Contact"),
                    const SizedBox(height: 10),
                    buildTextFormField(
                        _locationController, "Enter Location Address"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: buildTextFormField(
                              _latitudeController, "Enter Latitude"),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: buildTextFormField(
                              _longitudeController, "Enter Longitude"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildTextFormField(_resNameController, "Restaurant Name"),
                    const SizedBox(height: 50),
                    CustomGradientButton(
                      text: "Select Address From Map",
                      onPress: selectAddressFromMap,
                      h: 45,
                      w: 250,
                    ),
                    const SizedBox(height: 50),
                    CustomGradientButton(
                      text: "Submit",
                      onPress: _updateRestaurantInFirebase,
                      h: 45,
                      w: 400,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: appStyle(18, kDark, FontWeight.normal),
      ),
    );
  }

  Future<void> _updateRestaurantInFirebase() async {
    setState(() {
      _isUploading = true;
    });
    String contact = "+91${_contactController.text}";
    String location = _locationController.text;
    String resName = _resNameController.text;
    double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(_longitudeController.text) ?? 0.0;
    try {
      await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(widget.id)
          .update({
        "active": true,
        'contact': contact,
        'res_name': resName,
        "locationLatLng": GeoPoint(latitude, longitude),
        'locationAddress': location,
        "image": "",
        'created_at': Timestamp.now(),
      }).then((_) {
        setState(() {
          _isUploading = false;
        });
        // Success handling
        Navigator.pop(context);
      }).catchError((error) {
        setState(() {
          _isUploading = false;
        });
        // Error handling
        log('Error setting restaurant details: $error');
        // Show error message or handle the error appropriately
      });
    } catch (error) {
      setState(() {
        _isUploading = false;
      });
      log('Failed to update restaurant details: $error');
      // Show error message or handle the error appropriately
    }
  }
}

Future<String> getAddressFromLatLng(double lat, double lng) async {
  final String apiKey = "AIzaSyBLlQfAkdkka1mJYL-H0GPYvdUWeT4o9Uw";
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    }
  }
  return 'Address not found';
}
