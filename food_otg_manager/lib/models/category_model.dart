import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryItems {
  final String id;
  final String name;

  CategoryItems({required this.id, required this.name});

  factory CategoryItems.fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryItems(
      id: snapshot.id,
      name: snapshot['categoryName'],
    );
  }
}
