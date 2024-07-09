import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/views/manageManager/edit_manager_screen.dart';
import 'package:get/get.dart';

class ManagersDetailsScreen extends StatefulWidget {
  const ManagersDetailsScreen({
    super.key,
    required this.docId,
    required this.managerName,
    required this.data,
  });
  final String docId;
  final String managerName;
  final Map<String, dynamic> data;

  @override
  State<ManagersDetailsScreen> createState() => _ManagersDetailsScreenState();
}

class _ManagersDetailsScreenState extends State<ManagersDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.managerName} details screen"),
        actions: [
          IconButton(
              onPressed: () => Get.to(
                    () => EditManagerScreen(
                      docId: widget.docId,
                      managerName: widget.managerName,
                      data: widget.data,
                    ),
                  ),
              icon: const Icon(Icons.edit)),
          const SizedBox(width: 120),
        ],
      ),
      body: Container(
        padding:
            kIsWeb ? const EdgeInsets.all(16.0) : const EdgeInsets.all(5.0),
        margin: kIsWeb
            ? const EdgeInsets.only(left: 350, right: 350, top: 50, bottom: 350)
            : const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: kLightWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDark)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${widget.data['name']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Gender: ${widget.data['gender']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Location: ${widget.data['location']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Occupation: ${widget.data['occupation']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Phone Number: ${widget.data['phoneNumber']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Restaurant Name: ${widget.data['res_name']}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
