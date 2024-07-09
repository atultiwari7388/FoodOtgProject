import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../manageManager/pick_location_from_map.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key});

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _resNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longtitudeController = TextEditingController();
  double? selectedLat;
  double? selectedLng;

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
      _longtitudeController.text = selectedLng.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: kDark,
          title: Text("Add Restaurant",
              style: appStyle(18, kSecondary, FontWeight.normal)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(left: 450, right: 450, top: 50),
            decoration: BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kDark)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTextFormField(_contactController, "Enter Contact "),
                const SizedBox(height: 10),
                buildTextFormField(
                    _locationController, "Enter Location Address"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: buildTextFormField(
                            _latitudeController, "Enter latitude")),
                    const SizedBox(width: 40),
                    Expanded(
                      child: buildTextFormField(
                          _longtitudeController, "Enter longtitude"),
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
                    onPress: _addRestaurantToFirebase,
                    h: 45,
                    w: 400)
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: kDark,
          title: Text("Add Restaurant",
              style: appStyle(18, kSecondary, FontWeight.normal)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kDark)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTextFormField(_contactController, "Enter Contact "),
                const SizedBox(height: 10),
                buildTextFormField(
                    _locationController, "Enter Location Address"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: buildTextFormField(
                            _latitudeController, "Enter latitude")),
                    const SizedBox(width: 40),
                    Expanded(
                      child: buildTextFormField(
                          _longtitudeController, "Enter longtitude"),
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
                    onPress: _addRestaurantToFirebase,
                    h: 45,
                    w: 400)
              ],
            ),
          ),
        ),
      );
    }
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: appStyle(18, kDark, FontWeight.normal)),
    );
  }

  Future<void> _addRestaurantToFirebase() async {
    String contact = "+91${_contactController.text}";
    String location = _locationController.text;
    String resName = _resNameController.text;
    double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(_longtitudeController.text) ?? 0.0;
    try {
      CollectionReference restaurantsRef =
          FirebaseFirestore.instance.collection('Restaurants');

      QuerySnapshot snapshot = await restaurantsRef.get();
      int count = snapshot.size + 1; // Number of existing documents + 1

      // Generate the ID with the format "FR" followed by 5-digit number
      String id = 'FR${count.toString().padLeft(5, '0')}';

      await restaurantsRef.add({
        "active": true,
        'contact': contact,
        'res_name': resName,
        "locationLatLng": GeoPoint(latitude, longitude),
        'locationAddress': location,
        "image": "",
        "id": id,
        'created_at': Timestamp.now(),
      }).then((_) {
        // Success handling
        Navigator.pop(context);
      }).catchError((error) {
        // Error handling
        log('Error setting restaurant details: $error');
        // Show error message or handle the error appropriately
      });
    } catch (error) {
      // Handle error
      log('Failed to create account and add restaurant details: $error');
      // You can show an error message here
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
