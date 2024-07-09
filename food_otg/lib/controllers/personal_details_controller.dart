import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_services.dart';
import '../utils/toast_msg.dart';
import '../views/entry_point.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  bool isVegetarian = false;
  bool isNonVegetarian = false;
  bool isVegan = false;
  bool isButtonEnabled = false;

  List<String> selectedInterests = []; // List to store selected interests

  void updateUserProfile() async {
    isLoading = true;
    update();
    try {
      // Extracting selected interests and storing them in a list
      if (isVegetarian) selectedInterests.add('Veg');
      if (isNonVegetarian) selectedInterests.add('Non-Veg');
      if (isVegan) selectedInterests.add('Vegan');

      await DatabaseServices(uid: auth.currentUser!.uid.toString())
          .savingUserData(
        auth.currentUser!.email ?? emailAddressController.text.toString(),
        auth.currentUser!.displayName ?? nameController.text.toString(),
        auth.currentUser!.phoneNumber ?? phoneNumberController.text.toString(),
        "",
        //profilePicture
        "",
        //gender
        selectedInterests,
        "",
        //dob
        "", //anniversary
      )
          .then((value) async {
        isLoading = false;
        update();
        showToastMessage("Success", "Account created.", Colors.green);
        Get.offAll(() => DashboardScreen());
      }).onError((error, stackTrace) {
        isLoading = false;
        update();
        showToastMessage("Error", error.toString(), Colors.red);
      });
    } catch (e) {
      isLoading = false;
      update();
      showToastMessage("Error", e.toString(), Colors.red);
    }
  }
}
