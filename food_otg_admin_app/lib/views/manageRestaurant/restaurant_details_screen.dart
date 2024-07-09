import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/views/manageRestaurant/edit_restaurant_sccreen.dart';
import 'package:get/get.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String resName;
  final String id;
  final Map<String, dynamic> resData;
  const RestaurantDetailsScreen({
    super.key,
    required this.resName,
    required this.resData,
    required this.id,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.resName} Details"),
        actions: [
          IconButton(
              onPressed: () {
                log("Restaurant Id is ${widget.id}");
                Get.to(
                  () => EditRestaurantScreen(
                      resName: widget.resName,
                      resData: widget.resData,
                      id: widget.id),
                );
              },
              icon: const Icon(Icons.edit)),
          const SizedBox(width: 120),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display restaurant name
            Text(
              "Restaurant Name: ${widget.resName}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Display other details
            _buildDetailRow("Location", widget.resData["locationAddress"]),
            _buildDetailRow("Phone", widget.resData["contact"]),
            _buildDetailRow("Res Id", widget.resData["id"]),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
