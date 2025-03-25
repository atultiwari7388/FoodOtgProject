import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_otg_2025/constants/constants.dart';
import 'package:food_otg_2025/services/collection_refrences.dart';
import 'package:food_otg_2025/utils/toast_msg.dart';

Future<void> addToCart(Map<String, dynamic> foodItem, String docId) async {
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;
  // Check if user is authenticated
  if (user != null) {
    // Reference to the user's cart collection
    CollectionReference cartCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUId)
        .collection('cart');
    // Add the food item details to the cart
    await cartCollection.doc(docId).set(foodItem).then((value) {
      showToastMessage("Cart", "Item added to cart", kSuccess);
    });
  } else {
    // User not authenticated, handle accordingly
    log('User not authenticated');
  }
}
