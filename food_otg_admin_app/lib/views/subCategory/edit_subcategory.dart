import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_otg_admin_app/constants/constants.dart';
import 'package:food_otg_admin_app/utils/toast_msg.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/custom_gradient_button.dart';

class EditSubCategoryScreen extends StatefulWidget {
  const EditSubCategoryScreen({
    super.key,
    required this.subCatId,
    required this.data,
  });

  final String subCatId;
  final Map<String, dynamic> data;

  @override
  State<EditSubCategoryScreen> createState() => _EditSubCategoryScreenState();
}

class _EditSubCategoryScreenState extends State<EditSubCategoryScreen> {
  final TextEditingController _subCatNameController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  String? _currentImageUrl;
  String? _newImageUrl; // Added for tracking the new image URL
  late XFile _catImage = XFile('');
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _subCatNameController.text = widget.data['subCatName'];
    _priorityController.text = widget.data['priority'].toString();
    _currentImageUrl = widget.data['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Sub Category Screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: kIsWeb
              ? EdgeInsets.only(left: 450, right: 450, top: 50)
              : EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
              color: kLightWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kDark)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _catImage.path.isNotEmpty
                  ? Image.file(
                      File(_catImage.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      _currentImageUrl!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kSecondary),
                onPressed: _replaceImage,
                child: Text(_catImage.path.isNotEmpty
                    ? "Image Selected"
                    : "Replace Image"),
              ),
              TextField(
                controller: _subCatNameController,
                decoration:
                    const InputDecoration(labelText: 'Sub Category Name'),
              ),
              TextField(
                controller: _priorityController,
                decoration: const InputDecoration(labelText: 'Priority'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              CustomGradientButton(
                text: "Update Sub Category",
                onPress: _updateCategoryToFirebase,
                h: 45,
                w: 220,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Sub Category"),
          content: Text("Are you sure you want to delete this sub category?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                _deleteSubCategory();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSubCategory() async {
    try {
      // Delete the image from storage if it exists
      if (_currentImageUrl != null) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(_currentImageUrl!);
          await ref.delete();
        } catch (e) {
          log("Error deleting image: $e");
        }
      }

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection("SubCategories")
          .doc(widget.subCatId)
          .delete();

      showToastMessage(
        "Success",
        "Sub Category deleted successfully!",
        Colors.green,
      );
      Navigator.pop(context);
    } catch (e) {
      log("Error deleting sub category: $e");
      showToastMessage(
        "Error",
        "Failed to delete sub category",
        Colors.red,
      );
    }
  }

  void _updateCategoryToFirebase() async {
    String subCatName = _subCatNameController.text;
    int priority = int.tryParse(_priorityController.text) ?? 0;

    try {
      Map<String, dynamic> updateData = {
        'subCatName': subCatName,
        'priority': priority,
        'updated_at': DateTime.now(),
      };

      // If a new image URL is available, add it to the update data
      if (_newImageUrl != null) {
        updateData['imageUrl'] = _newImageUrl;
      }

      await FirebaseFirestore.instance
          .collection("SubCategories")
          .doc(widget.subCatId)
          .update(updateData)
          .then((value) {
        log('Category updated successfully with ID: ${widget.subCatId}');
        showToastMessage(
          "Success",
          "Category Updated successfully!",
          Colors.green,
        );
        Navigator.pop(context);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _replaceImage() async {
    final DateTime now = DateTime.now();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final itemImageFile = File(pickedFile.path);
      final itemImageName = 'front_${now.microsecondsSinceEpoch}.jpg';
      final Reference frontStorageRef = FirebaseStorage.instance
          .ref()
          .child('SubCategoriesImages')
          .child("img")
          .child(itemImageName);
      await frontStorageRef.putFile(itemImageFile);
      final String categoryImageUrl = await frontStorageRef.getDownloadURL();

      setState(() {
        _catImage = pickedFile; // Store the picked file
        _newImageUrl = categoryImageUrl;
      });
    }
  }
}
