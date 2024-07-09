import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/common/custom_gradient_button.dart';

class EditManagerScreen extends StatefulWidget {
  final String docId;
  final String managerName;
  final Map<String, dynamic> data;
  const EditManagerScreen({
    super.key,
    required this.docId,
    required this.managerName,
    required this.data,
  });

  @override
  State<EditManagerScreen> createState() => _EditManagerScreenState();
}

class _EditManagerScreenState extends State<EditManagerScreen> {
  // Define controllers for managing text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _restaurantNameController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize text field controllers with existing data
    _nameController.text = widget.data['name'];
    _genderController.text = widget.data['gender'];
    _locationController.text = widget.data['location'];
    _occupationController.text = widget.data['occupation'];
    _phoneNumberController.text = widget.data['phoneNumber'];
    _restaurantNameController.text = widget.data['res_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.managerName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _occupationController,
              decoration: InputDecoration(labelText: 'Occupation'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _restaurantNameController,
              decoration: InputDecoration(labelText: 'Restaurant Name'),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     _updateManagerDetails();
            //   },
            //   child: Text('Save Changes'),
            // ),
            CustomGradientButton(
                text: "Update",
                onPress: () => _updateManagerDetails(),
                h: 50,
                w: 220),
          ],
        ),
      ),
    );
  }

  void _updateManagerDetails() {
    // Update manager details in Firestore
    FirebaseFirestore.instance.collection('Managers').doc(widget.docId).update({
      'name': _nameController.text,
      'gender': _genderController.text,
      'location': _locationController.text,
      'occupation': _occupationController.text,
      'phoneNumber': _phoneNumberController.text,
      'res_name': _restaurantNameController.text,
    }).then((value) {
      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Manager details updated successfully')),
      );
      // You can also navigate back to the previous screen if needed
      Navigator.pop(context);
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update manager details')),
      );
    });
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _genderController.dispose();
    _locationController.dispose();
    _occupationController.dispose();
    _phoneNumberController.dispose();
    _restaurantNameController.dispose();
    super.dispose();
  }
}
