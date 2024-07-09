// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:food_otg_admin_app/models/category.dart';
// // import 'package:food_otg_admin_app/models/sub_category.dart';
// // import 'package:food_otg_admin_app/models/restaurant.dart';
// // import '../../common/custom_gradient_button.dart';
// //
// // class BackupEditItemScreen extends StatefulWidget {
// //   final String itemId;
// //
// //   const BackupEditItemScreen({Key? key, required this.itemId}) : super(key: key);
// //
// //   @override
// //   _BackupEditItemScreenState createState() => _BackupEditItemScreenState();
// // }
// //
// // class _BackupEditItemScreenState extends State<BackupEditItemScreen> {
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _foodCaloriesController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();
// //   final TextEditingController _priceController = TextEditingController();
// //   final TextEditingController _oldPriceController = TextEditingController();
// //   final TextEditingController _timeController = TextEditingController();
// //   final TextEditingController _priorityController = TextEditingController();
// //
// //   bool _isAddonAvailable = false;
// //   bool _isSizesAvailable = false;
// //   bool _isAllergicIngredientsAvailable = false;
// //   bool _isVeg = false;
// //   List<String> _selectedRestaurantIds = [];
// //   List<String> _selectedSizes = [];
// //   List<String> _selectedAllergic = [];
// //   List<String> _selectedAddOns = [];
// //
// //   late List<Restaurant> _restaurants;
// //   String? _selectedCategoryId;
// //   late List<CategoryItems> _categories;
// //   String? _selectedSubCategoryId;
// //   late List<SubCategory> _subCategories;
// //   bool _isUploading = false;
// //   bool _isItemLoading = false;
// //   bool _isLoadingRestaurants = false;
// //   bool _isLoadingCategory = false;
// //   bool _isLoadingSubCategory = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadItemData();
// //     _loadRestaurants();
// //     _loadCategory();
// //     _loadSubCategory();
// //   }
// //
// //   Future<void> _loadItemData() async {
// //     try {
// //       setState(() {
// //         _isItemLoading = true; // Add this line
// //       });
// //       DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
// //           .collection('Items')
// //           .doc(widget.itemId)
// //           .get();
// //
// //       if (itemSnapshot.exists) {
// //         setState(() {
// //           _titleController.text = itemSnapshot.get('title');
// //
// //           _foodCaloriesController.text =
// //               (itemSnapshot.get('foodCalories') as List).join(',');
// //           _descriptionController.text = itemSnapshot.get('description');
// //           _priceController.text = itemSnapshot.get('price').toString();
// //           _oldPriceController.text = itemSnapshot.get('oldPrice').toString();
// //           _timeController.text = itemSnapshot.get('time');
// //           _isAddonAvailable = itemSnapshot.get('isAddonAvailable');
// //           _isSizesAvailable = itemSnapshot.get('isSizesAvailable');
// //           _isAllergicIngredientsAvailable =
// //               itemSnapshot.get('isAllergicIngredientsAvailable');
// //           _isVeg = itemSnapshot.get('isVeg');
// //           _selectedRestaurantIds = List<String>.from(itemSnapshot.get('resId'));
// //           _selectedSizes = List<String>.from(itemSnapshot.get('sizes'));
// //           _selectedAllergic = List<String>.from(itemSnapshot.get('allergic'));
// //           _selectedAddOns = List<String>.from(itemSnapshot.get('addOns'));
// //           _selectedCategoryId = itemSnapshot.get('categoryId');
// //           _selectedSubCategoryId = itemSnapshot.get('subCategoryId');
// //           _priorityController.text = itemSnapshot.get('priority').toString();
// //           _isItemLoading = false;
// //         });
// //       }
// //     } catch (error) {
// //       log('Failed to load item data: $error');
// //     }
// //   }
// //
// //   Future<void> _loadRestaurants() async {
// //     try {
// //       setState(() {
// //         _isLoadingRestaurants = true; // Add this line
// //       });
// //       QuerySnapshot snapshot =
// //       await FirebaseFirestore.instance.collection('Restaurants').get();
// //
// //       setState(() {
// //         _restaurants =
// //             snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();
// //
// //         _isLoadingRestaurants = false;
// //       });
// //     } catch (error) {
// //       log('Failed to load restaurants: $error');
// //     }
// //   }
// //
// //   Future<void> _loadCategory() async {
// //     // setState(() {
// //     //   _isLoadingCategory = true; // Add this line
// //     // });
// //     try {
// //       QuerySnapshot snapshot =
// //       await FirebaseFirestore.instance.collection('Categories').get();
// //
// //       setState(() {
// //         _categories = snapshot.docs
// //             .map((doc) => CategoryItems.fromSnapshot(doc))
// //             .toList();
// //
// //         // _isLoadingCategory = false;
// //       });
// //     } catch (error) {
// //       log('Failed to load category: $error');
// //     }
// //   }
// //
// //   Future<void> _loadSubCategory() async {
// //     // setState(() {
// //     //   _isLoadingSubCategory = true; // Add this line
// //     // });
// //     try {
// //       QuerySnapshot snapshot =
// //       await FirebaseFirestore.instance.collection('SubCategories').get();
// //
// //       setState(() {
// //         _subCategories =
// //             snapshot.docs.map((doc) => SubCategory.fromSnapshot(doc)).toList();
// //
// //         // _isLoadingSubCategory = false;
// //       });
// //     } catch (error) {
// //       log('Failed to load category: $error');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Edit Item'),
// //       ),
// //       body: _isUploading
// //           ? const Center(child: CircularProgressIndicator())
// //           : _isLoadingRestaurants
// //           ? const Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text('Title:'),
// //             TextField(controller: _titleController),
// //             const SizedBox(height: 16),
// //             const Text('Food Calories (Comma Separated):'),
// //             TextField(controller: _foodCaloriesController),
// //             const SizedBox(height: 16),
// //             const Text('Description:'),
// //             TextField(controller: _descriptionController),
// //             const SizedBox(height: 16),
// //             const Text('Price:'),
// //             TextField(controller: _priceController),
// //             const SizedBox(height: 16),
// //             const Text('Old Price:'),
// //             TextField(controller: _oldPriceController),
// //             const SizedBox(height: 16),
// //             const Text('Time:'),
// //             TextField(controller: _timeController),
// //             const Text('Priority:'),
// //             TextField(controller: _priorityController),
// //             const SizedBox(height: 16),
// //             const Text('Is Veg:'),
// //             Checkbox(
// //               value: _isVeg,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _isVeg = value ?? false;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //             const Text('Restaurants:'),
// //             Column(
// //               children: _restaurants.map((restaurant) {
// //                 return CheckboxListTile(
// //                   title: Text(restaurant.name),
// //                   value:
// //                   _selectedRestaurantIds.contains(restaurant.id),
// //                   onChanged: (value) {
// //                     setState(() {
// //                       if (value != null && value) {
// //                         _selectedRestaurantIds.add(restaurant.id);
// //                       } else {
// //                         _selectedRestaurantIds.remove(restaurant.id);
// //                       }
// //                     });
// //                   },
// //                 );
// //               }).toList(),
// //             ),
// //             const SizedBox(height: 16),
// //             const Text('Categories:'),
// //             DropdownButtonFormField<String>(
// //               value: _selectedCategoryId,
// //               items: _categories.map((category) {
// //                 return DropdownMenuItem<String>(
// //                   value: category.id,
// //                   child: Text(category.name),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedCategoryId = value;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //             const Text('Sub Categories:'),
// //             DropdownButtonFormField<String>(
// //               value: _selectedSubCategoryId,
// //               items: _subCategories.map((subCategory) {
// //                 return DropdownMenuItem<String>(
// //                   value: subCategory.id,
// //                   child: Text(subCategory.name),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   _selectedSubCategoryId = value;
// //                 });
// //               },
// //             ),
// //             const SizedBox(height: 16),
// //             CustomGradientButton(
// //               text: "Update Item",
// //               onPress: _updateItem,
// //               h: 45,
// //               w: 250,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _updateItem() async {
// //     setState(() {
// //       _isUploading = true;
// //     });
// //
// //     List<String> resId = _selectedRestaurantIds;
// //     bool isVeg = _isVeg;
// //     String categoryId = _selectedCategoryId ?? '';
// //     String subCategoryId = _selectedSubCategoryId ?? '';
// //     String title = _titleController.text;
// //     List<String> foodCalories = _foodCaloriesController.text
// //         .split(',')
// //         .map((calorie) => calorie.trim())
// //         .toList();
// //     String description = _descriptionController.text;
// //     num price = num.tryParse(_priceController.text) ?? 0;
// //     num priority = num.tryParse(_priorityController.text) ?? 0;
// //     num oldPrice = num.tryParse(_oldPriceController.text) ?? 0;
// //     String time = _timeController.text;
// //
// //     try {
// //       await FirebaseFirestore.instance
// //           .collection('Items')
// //           .doc(widget.itemId)
// //           .update({
// //         'title': title,
// //         'foodCalories': foodCalories,
// //         'description': description,
// //         'price': price,
// //         'oldPrice': oldPrice,
// //         'time': time,
// //         'isVeg': isVeg,
// //         "priority": priority,
// //         'resId': resId,
// //         'categoryId': categoryId,
// //         'subCategoryId': subCategoryId,
// //       });
// //
// //       setState(() {
// //         _isUploading = false;
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Item updated successfully!'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //
// //       // Navigate back to previous screen
// //       Navigator.pop(context);
// //     } catch (e) {
// //       setState(() {
// //         _isUploading = false;
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Failed to update item: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// // }
//
//
//
//
//
//
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:food_otg_admin_app/models/category.dart';
// import 'package:food_otg_admin_app/models/sub_category.dart';
// import 'package:food_otg_admin_app/models/restaurant.dart';
// import '../../common/custom_gradient_button.dart';
//
// class BackupEditItemScreen extends StatefulWidget {
//   final String itemId;
//
//   const BackupEditItemScreen({Key? key, required this.itemId}) : super(key: key);
//
//   @override
//   _BackupEditItemScreenState createState() => _BackupEditItemScreenState();
// }
//
// class _BackupEditItemScreenState extends State<BackupEditItemScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _foodCaloriesController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _oldPriceController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _priorityController = TextEditingController();
//
//   bool _isAddonAvailable = false;
//   bool _isSizesAvailable = false;
//   bool _isAllergicIngredientsAvailable = false;
//   bool _isVeg = false;
//   List<String> _selectedRestaurantIds = [];
//   List<String> _selectedSizes = [];
//   List<String> _selectedAllergic = [];
//   List<String> _selectedAddOns = [];
//
//   late List<Restaurant> _restaurants;
//   String? _selectedCategoryId;
//   late List<CategoryItems> _categories;
//   String? _selectedSubCategoryId;
//   late List<SubCategory> _subCategories;
//   bool _isUploading = false;
//   bool _isItemLoading = false;
//   bool _isLoadingRestaurants = false;
//   bool _isLoadingCategory = false;
//   bool _isLoadingSubCategory = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadItemData();
//     _loadRestaurants();
//     _loadCategory();
//     _loadSubCategory();
//   }
//
//   Future<void> _loadItemData() async {
//     try {
//       setState(() {
//         _isItemLoading = true; // Add this line
//       });
//       DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
//           .collection('Items')
//           .doc(widget.itemId)
//           .get();
//
//       if (itemSnapshot.exists) {
//         setState(() {
//           _titleController.text = itemSnapshot.get('title');
//
//           _foodCaloriesController.text =
//               (itemSnapshot.get('foodCalories') as List).join(',');
//           _descriptionController.text = itemSnapshot.get('description');
//           _priceController.text = itemSnapshot.get('price').toString();
//           _oldPriceController.text = itemSnapshot.get('oldPrice').toString();
//           _timeController.text = itemSnapshot.get('time');
//           _isAddonAvailable = itemSnapshot.get('isAddonAvailable');
//           _isSizesAvailable = itemSnapshot.get('isSizesAvailable');
//           _isAllergicIngredientsAvailable =
//               itemSnapshot.get('isAllergicIngredientsAvailable');
//           _isVeg = itemSnapshot.get('isVeg');
//           _selectedRestaurantIds = List<String>.from(itemSnapshot.get('resId'));
//           _selectedSizes = List<String>.from(itemSnapshot.get('sizes'));
//           _selectedAllergic = List<String>.from(itemSnapshot.get('allergic'));
//           _selectedAddOns = List<String>.from(itemSnapshot.get('addOns'));
//           _selectedCategoryId = itemSnapshot.get('categoryId');
//           _selectedSubCategoryId = itemSnapshot.get('subCategoryId');
//           _priorityController.text = itemSnapshot.get('priority').toString();
//           _isItemLoading = false;
//         });
//       }
//     } catch (error) {
//       log('Failed to load item data: $error');
//     }
//   }
//
//   Future<void> _loadRestaurants() async {
//     try {
//       setState(() {
//         _isLoadingRestaurants = true; // Add this line
//       });
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('Restaurants').get();
//
//       setState(() {
//         _restaurants =
//             snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();
//
//         _isLoadingRestaurants = false;
//       });
//     } catch (error) {
//       log('Failed to load restaurants: $error');
//     }
//   }
//
//   Future<void> _loadCategory() async {
//     setState(() {
//       _isLoadingCategory = true; // Add this line
//     });
//     try {
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('Categories').get();
//
//       setState(() {
//         _categories = snapshot.docs
//             .map((doc) => CategoryItems.fromSnapshot(doc))
//             .toList();
//         _getSelectedCategoryName();
//         _isLoadingCategory = false;
//         log("Loading Categories $_categories");
//       });
//     } catch (error) {
//       log('Failed to load category: $error');
//     }
//   }
//
//   String _getSelectedCategoryName() {
//     final selectedCategory = _categories.firstWhere(
//           (category) => category.id == _selectedCategoryId,
//       orElse: () => CategoryItems(id: '', name: ''),
//     );
//     return selectedCategory.name;
//   }
//
//   Future<void> _loadSubCategory() async {
//     setState(() {
//       _isLoadingSubCategory = true; // Add this line
//     });
//     try {
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('SubCategories').get();
//
//       setState(() {
//         _subCategories =
//             snapshot.docs.map((doc) => SubCategory.fromSnapshot(doc)).toList();
//
//         _isLoadingSubCategory = false;
//         log("Loading Sub Categories $_subCategories");
//       });
//     } catch (error) {
//       log('Failed to load category: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Item'),
//       ),
//       body: _isUploading
//           ? const Center(child: CircularProgressIndicator())
//           : _isLoadingRestaurants
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Title:'),
//             TextField(controller: _titleController),
//             const SizedBox(height: 16),
//             const Text('Food Calories (Comma Separated):'),
//             TextField(controller: _foodCaloriesController),
//             const SizedBox(height: 16),
//             const Text('Description:'),
//             TextField(controller: _descriptionController),
//             const SizedBox(height: 16),
//             const Text('Price:'),
//             TextField(controller: _priceController),
//             const SizedBox(height: 16),
//             const Text('Old Price:'),
//             TextField(controller: _oldPriceController),
//             const SizedBox(height: 16),
//             const Text('Time:'),
//             TextField(controller: _timeController),
//             const Text('Priority:'),
//             TextField(controller: _priorityController),
//             const SizedBox(height: 16),
//             const Text('Is Veg:'),
//             Checkbox(
//               value: _isVeg,
//               onChanged: (value) {
//                 setState(() {
//                   _isVeg = value ?? false;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             const Text('Restaurants:'),
//             Column(
//               children: _restaurants.map((restaurant) {
//                 return CheckboxListTile(
//                   title: Text(restaurant.name),
//                   value:
//                   _selectedRestaurantIds.contains(restaurant.id),
//                   onChanged: (value) {
//                     setState(() {
//                       if (value != null && value) {
//                         _selectedRestaurantIds.add(restaurant.id);
//                       } else {
//                         _selectedRestaurantIds.remove(restaurant.id);
//                       }
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//             const Text('Categories:'),
//             DropdownButtonFormField<String>(
//               value: _selectedCategoryId,
//               items: _categories.map((category) {
//                 log("Category Name : ${category.name}");
//                 return DropdownMenuItem<String>(
//                   value: category.id,
//                   child: Text(category.name),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategoryId = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             const Text('Sub Categories:'),
//             DropdownButtonFormField<String>(
//               value: _selectedSubCategoryId,
//               items: _subCategories.map((subCategory) {
//                 log("Sub Category Name : ${subCategory.name}");
//
//                 return DropdownMenuItem<String>(
//                   value: subCategory.id,
//                   child: Text(subCategory.name),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedSubCategoryId = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             CustomGradientButton(
//               text: "Update Item",
//               onPress: _updateItem,
//               h: 45,
//               w: 250,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _updateItem() async {
//     setState(() {
//       _isUploading = true;
//     });
//
//     List<String> resId = _selectedRestaurantIds;
//     bool isVeg = _isVeg;
//     String categoryId = _selectedCategoryId ?? '';
//     String subCategoryId = _selectedSubCategoryId ?? '';
//     String title = _titleController.text;
//     List<String> foodCalories = _foodCaloriesController.text
//         .split(',')
//         .map((calorie) => calorie.trim())
//         .toList();
//     String description = _descriptionController.text;
//     num price = num.tryParse(_priceController.text) ?? 0;
//     num priority = num.tryParse(_priorityController.text) ?? 0;
//     num oldPrice = num.tryParse(_oldPriceController.text) ?? 0;
//     String time = _timeController.text;
//
//     try {
//       await FirebaseFirestore.instance
//           .collection('Items')
//           .doc(widget.itemId)
//           .update({
//         'title': title,
//         'foodCalories': foodCalories,
//         'description': description,
//         'price': price,
//         'oldPrice': oldPrice,
//         'time': time,
//         'isVeg': isVeg,
//         "priority": priority,
//         'resId': resId,
//         'categoryId': categoryId,
//         'subCategoryId': subCategoryId,
//       });
//
//       setState(() {
//         _isUploading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Item updated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       // Navigate back to previous screen
//       Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update item: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_otg_admin_app/models/category.dart';
import 'package:food_otg_admin_app/models/sub_category.dart';
import 'package:food_otg_admin_app/models/restaurant.dart';
import '../../common/custom_gradient_button.dart';

class BackupEditItemScreen extends StatefulWidget {
  final String itemId;

  const BackupEditItemScreen({Key? key, required this.itemId})
      : super(key: key);

  @override
  _BackupEditItemScreenState createState() => _BackupEditItemScreenState();
}

class _BackupEditItemScreenState extends State<BackupEditItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _foodCaloriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  bool _isAddonAvailable = false;
  bool _isSizesAvailable = false;
  bool _isAllergicIngredientsAvailable = false;
  bool _isVeg = false;
  List<String> _selectedRestaurantIds = [];
  List<String> _selectedSizes = [];
  List<String> _selectedAllergic = [];
  List<String> _selectedAddOns = [];

  late List<Restaurant> _restaurants;
  String? _selectedCategoryId;
  late List<CategoryItems> _categories;
  String? _selectedSubCategoryId;
  late List<SubCategory> _subCategories;
  bool _isUploading = false;
  bool _isItemLoading = false;
  bool _isLoadingRestaurants = false;
  bool _isLoadingCategory = false;
  bool _isLoadingSubCategory = false;

  @override
  void initState() {
    super.initState();
    _loadItemData();
    _loadRestaurants();
    _loadCategory();
    _loadSubCategory();
    _loadSizes();
  }

  Future<void> _loadItemData() async {
    try {
      setState(() {
        _isItemLoading = true; // Add this line
      });
      DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .doc(widget.itemId)
          .get();

      if (itemSnapshot.exists) {
        setState(() {
          _titleController.text = itemSnapshot.get('title');

          _foodCaloriesController.text =
              (itemSnapshot.get('foodCalories') as List).join(',');
          _descriptionController.text = itemSnapshot.get('description');
          _priceController.text = itemSnapshot.get('price').toString();
          _oldPriceController.text = itemSnapshot.get('oldPrice').toString();
          _timeController.text = itemSnapshot.get('time');
          _isAddonAvailable = itemSnapshot.get('isAddonAvailable');
          _isSizesAvailable = itemSnapshot.get('isSizesAvailable');
          _isAllergicIngredientsAvailable =
              itemSnapshot.get('isAllergicIngredientsAvailable');
          _isVeg = itemSnapshot.get('isVeg');
          _selectedRestaurantIds = List<String>.from(itemSnapshot.get('resId'));
          _selectedSizes = List<String>.from(itemSnapshot.get('sizes'));
          _selectedAllergic = List<String>.from(itemSnapshot.get('allergic'));
          _selectedAddOns = List<String>.from(itemSnapshot.get('addOns'));
          _selectedCategoryId = itemSnapshot.get('categoryId');
          _selectedSubCategoryId = itemSnapshot.get('subCategoryId');
          _priorityController.text = itemSnapshot.get('priority').toString();
          _isItemLoading = false;
        });
      }
    } catch (error) {
      log('Failed to load item data: $error');
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      setState(() {
        _isLoadingRestaurants = true; // Add this line
      });
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Restaurants').get();

      setState(() {
        _restaurants =
            snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();

        _isLoadingRestaurants = false;
      });
    } catch (error) {
      log('Failed to load restaurants: $error');
    }
  }

  Future<void> _loadCategory() async {
    setState(() {
      _isLoadingCategory = true; // Add this line
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Categories').get();

      setState(() {
        _categories = snapshot.docs
            .map((doc) => CategoryItems.fromSnapshot(doc))
            .toList();
        _getSelectedCategoryName();
        _isLoadingCategory = false;
        log("Loading Categories $_categories");
      });
    } catch (error) {
      log('Failed to load category: $error');
    }
  }

  String _getSelectedCategoryName() {
    final selectedCategory = _categories.firstWhere(
      (category) => category.id == _selectedCategoryId,
      orElse: () => CategoryItems(id: '', name: ''),
    );
    return selectedCategory.name;
  }

  Future<void> _loadSubCategory() async {
    setState(() {
      _isLoadingSubCategory = true; // Add this line
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('SubCategories').get();

      setState(() {
        _subCategories =
            snapshot.docs.map((doc) => SubCategory.fromSnapshot(doc)).toList();

        _isLoadingSubCategory = false;
        log("Loading Sub Categories $_subCategories");
      });
    } catch (error) {
      log('Failed to load category: $error');
    }
  }

  Future<List<Size>> _loadSizes() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('sizes').get();

      return snapshot.docs.map((doc) => Size.fromSnapshot(doc)).toList();
    } catch (error) {
      log('Failed to load sizes: $error');
      return []; // Return an empty list in case of error
    }
  }

  Widget _buildSizesSection() {
    return _isSizesAvailable
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sizes:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Adjust the height according to your needs
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sizes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sizesDocs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: sizesDocs.length,
                        itemBuilder: (context, index) {
                          final sizeDoc = sizesDocs[index];
                          final sizeData =
                              sizeDoc.data() as Map<String, dynamic>;
                          final sizeId = sizeDoc.id;
                          final sizeTitle = sizeData['title'] as String?;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text(sizeTitle ?? ''),
                                value: _selectedSizes.contains(sizeId),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _selectedSizes.add(sizeId);
                                    } else {
                                      _selectedSizes.remove(sizeId);
                                    }
                                  });
                                },
                              ),
                              // Text field section
                              if (_selectedSizes.contains(sizeId))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText:
                                            'Enter price for $sizeTitle'),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) {
                                      // You can handle price changes here
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          )
        : Container(); // Empty container if sizes are not available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : _isLoadingRestaurants
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title:'),
                      TextField(controller: _titleController),
                      const SizedBox(height: 16),
                      const Text('Food Calories (Comma Separated):'),
                      TextField(controller: _foodCaloriesController),
                      const SizedBox(height: 16),
                      const Text('Description:'),
                      TextField(controller: _descriptionController),
                      const SizedBox(height: 16),
                      const Text('Price:'),
                      TextField(controller: _priceController),
                      const SizedBox(height: 16),
                      const Text('Old Price:'),
                      TextField(controller: _oldPriceController),
                      const SizedBox(height: 16),
                      const Text('Time:'),
                      TextField(controller: _timeController),
                      const Text('Priority:'),
                      TextField(controller: _priorityController),
                      const SizedBox(height: 16),
                      const Text('Is Veg:'),
                      Checkbox(
                        value: _isVeg,
                        onChanged: (value) {
                          setState(() {
                            _isVeg = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Restaurants:'),
                      Column(
                        children: _restaurants.map((restaurant) {
                          return CheckboxListTile(
                            title: Text(restaurant.name),
                            value:
                                _selectedRestaurantIds.contains(restaurant.id),
                            onChanged: (value) {
                              setState(() {
                                if (value != null && value) {
                                  _selectedRestaurantIds.add(restaurant.id);
                                } else {
                                  _selectedRestaurantIds.remove(restaurant.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Categories:'),
                      DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        items: _categories.map((category) {
                          log("Category Name : ${category.name}");
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Sub Categories:'),
                      DropdownButtonFormField<String>(
                        value: _selectedSubCategoryId,
                        items: _subCategories.map((subCategory) {
                          log("Sub Category Name : ${subCategory.name}");

                          return DropdownMenuItem<String>(
                            value: subCategory.id,
                            child: Text(subCategory.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubCategoryId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSizesSection(),
                      const SizedBox(height: 16),
                      CustomGradientButton(
                        text: "Update Item",
                        onPress: _updateItem,
                        h: 45,
                        w: 250,
                      ),
                    ],
                  ),
                ),
    );
  }

  void _updateItem() async {
    setState(() {
      _isUploading = true;
    });

    List<String> resId = _selectedRestaurantIds;
    bool isVeg = _isVeg;
    String categoryId = _selectedCategoryId ?? '';
    String subCategoryId = _selectedSubCategoryId ?? '';
    String title = _titleController.text;
    List<String> foodCalories = _foodCaloriesController.text
        .split(',')
        .map((calorie) => calorie.trim())
        .toList();
    String description = _descriptionController.text;
    num price = num.tryParse(_priceController.text) ?? 0;
    num priority = num.tryParse(_priorityController.text) ?? 0;
    num oldPrice = num.tryParse(_oldPriceController.text) ?? 0;
    String time = _timeController.text;

    try {
      await FirebaseFirestore.instance
          .collection('Items')
          .doc(widget.itemId)
          .update({
        'title': title,
        'foodCalories': foodCalories,
        'description': description,
        'price': price,
        'oldPrice': oldPrice,
        'time': time,
        'isVeg': isVeg,
        "priority": priority,
        'resId': resId,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
      });

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to previous screen
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class Size {
  final String id;
  final String title;

  Size({
    required this.id,
    required this.title,
  });

  factory Size.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Size(
      id: snapshot.id,
      title: data['title'] ?? '',
    );
  }
}
