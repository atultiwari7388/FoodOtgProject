import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';
import 'package:food_otg_admin_app/common/reusable_text.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/models/restaurant.dart';
import 'package:food_otg_admin_app/utils/appStyle.dart';

class AddManager extends StatefulWidget {
  const AddManager({super.key});

  @override
  State<AddManager> createState() => _AddManagerState();
}

class _AddManagerState extends State<AddManager> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longtitudeController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  List<Restaurant> _restaurants = []; // List to store restaurants data
  String? _selectedRestaurantId; // Selected restaurant ID

  @override
  void initState() {
    super.initState();
    // Load restaurants data when the screen initializes
    _loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: kDark,
          title: Text("Add Manager",
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
                const SizedBox(height: 20),
                Center(
                    child: ReusableText(
                        text: "Add Manager",
                        style: appStyle(20, kDark, FontWeight.bold))),
                const SizedBox(height: 20),
                buildTextFormField(_emailController, "Email"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: Text('Select Gender',
                      style: appStyle(18, kDark, FontWeight.normal)),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                buildTextFormField(_nameController, "Name"),
                const SizedBox(height: 10),
                buildTextFormField(_phoneNumberController, "Phone Number"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedRestaurantId,
                  hint: Text('Select Restaurant',
                      style: appStyle(18, kDark, FontWeight.normal)),
                  onChanged: (value) {
                    setState(() {
                      _selectedRestaurantId = value!;
                    });
                  },
                  items: _restaurants.map((Restaurant restaurant) {
                    return DropdownMenuItem<String>(
                      value: restaurant.id,
                      child: Text(restaurant.name),
                    );
                  }).toList(),
                ),
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
                buildTextFormField(_occupationController, "Occupation"),
                const SizedBox(height: 10),
                buildTextFormField(
                    _passwordController, "Enter Manager Password"),
                const SizedBox(height: 50),
                CustomGradientButton(
                    text: "Submit",
                    onPress: _addManagerToFireStore,
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
          title: Text("Add Manager",
              style: appStyle(18, kSecondary, FontWeight.normal)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kDark)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                    child: ReusableText(
                        text: "Add Manager",
                        style: appStyle(20, kDark, FontWeight.bold))),
                const SizedBox(height: 20),
                buildTextFormField(_emailController, "Email"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: Text('Select Gender',
                      style: appStyle(18, kDark, FontWeight.normal)),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                buildTextFormField(_nameController, "Name"),
                const SizedBox(height: 10),
                buildTextFormField(_phoneNumberController, "Phone Number"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedRestaurantId,
                  hint: Text('Select Restaurant',
                      style: appStyle(18, kDark, FontWeight.normal)),
                  onChanged: (value) {
                    setState(() {
                      _selectedRestaurantId = value!;
                    });
                  },
                  items: _restaurants.map((Restaurant restaurant) {
                    return DropdownMenuItem<String>(
                      value: restaurant.id,
                      child: Text(restaurant.name),
                    );
                  }).toList(),
                ),
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
                buildTextFormField(_occupationController, "Occupation"),
                const SizedBox(height: 10),
                buildTextFormField(
                    _passwordController, "Enter Manager Password"),
                const SizedBox(height: 50),
                CustomGradientButton(
                    text: "Submit",
                    onPress: _addManagerToFireStore,
                    h: 45,
                    w: 120)
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

  Future<void> _loadRestaurants() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Restaurants').get();

      setState(() {
        _restaurants =
            snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();
      });
    } catch (error) {
      log('Failed to load restaurants: $error');
      // Handle error
    }
  }

  Future<void> _addManagerToFireStore() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String location = _locationController.text;

    String occupation = _occupationController.text;
    String gender = _selectedGender!;
    String resId = _selectedRestaurantId.toString();
    String restaurantName = _restaurants
        .firstWhere((restaurant) => restaurant.id == _selectedRestaurantId)
        .name; // Get selected restaurant name

    // Parsing latitude and longitude to double
    double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(_longtitudeController.text) ?? 0.0;

    try {
      // Create a new account with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the signed-in user
      User? user = userCredential.user;

      if (user != null) {
        // If user creation is successful, add manager details to Firestore
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('Managers').doc(user.uid);

        await docRef.set({
          "active": true,
          'email': email,
          'gender': gender,
          'name': name,
          'phoneNumber': phoneNumber,
          'res_name': restaurantName,
          "resId": resId,
          "locationLatLng": GeoPoint(latitude, longitude),
          'location': location,
          'occupation': occupation,
          "profilePicture": "",
          "specialDates": "",
          "uid": user.uid,
          'created_at': Timestamp.now(),
        }).then((_) {
          // Success handling
          Navigator.pop(context);
        }).catchError((error) {
          // Error handling
          log('Error setting manager details: $error');
          // Show error message or handle the error appropriately
        });

        log('Manager details added successfully with UID: ${user.uid}');
      } else {
        // Handle case where user is null
        log('User is null after creating account');
      }
    } catch (error) {
      // Handle error
      log('Failed to create account and add manager details: $error');
      // You can show an error message here
    }
  }
}
