import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;

  Restaurant({required this.id, required this.name});

  // Factory method to create Restaurant object from Firestore snapshot
  factory Restaurant.fromSnapshot(DocumentSnapshot snapshot) {
    return Restaurant(
      id: snapshot.id,
      name: snapshot['res_name'],
    );
  }
}
