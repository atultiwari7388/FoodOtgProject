// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../common/custom_gradient_button.dart';
// import '../../models/category_model.dart';
// import '../../models/subcategory_model.dart';

// class EditItemScreen extends StatefulWidget {
//   final String itemId;

//   const EditItemScreen({Key? key, required this.itemId}) : super(key: key);

//   @override
//   _EditItemScreenState createState() => _EditItemScreenState();
// }

// class _EditItemScreenState extends State<EditItemScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _foodCaloriesController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _oldPriceController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _priorityController = TextEditingController();

//   bool _isAddonAvailable = false;
//   bool _isSizesAvailable = false;
//   bool _isAllergicIngredientsAvailable = false;
//   bool _isVeg = false;

//   List<String> _selectedSizes = [];
//   List<String> _selectedAllergic = [];
//   List<String> _selectedAddOns = [];

//   String? _selectedCategoryId;
//   late List<Category> _categories;
//   String? _selectedSubCategoryId;
//   late List<SubCategory> _subCategories;
//   bool _isUploading = false;
//   bool _isItemLoading = false;
//   bool _isLoadingRestaurants = false;
//   bool _isLoadingCategory = false;
//   bool _isLoadingSubCategory = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadItemData();
//     _loadCategory();
//     _loadSubCategory();
//   }

//   Future<void> _loadItemData() async {
//     try {
//       setState(() {
//         _isItemLoading = true; // Add this line
//       });
//       DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
//           .collection('Items')
//           .doc(widget.itemId)
//           .get();

//       if (itemSnapshot.exists) {
//         setState(() {
//           _titleController.text = itemSnapshot.get('title');

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
//           // _selectedRestaurantIds = List<String>.from(itemSnapshot.get('resId'));
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

//   Future<void> _loadCategory() async {
//     setState(() {
//       _isLoadingCategory = true; // Add this line
//     });
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('Categories').get();

//       setState(() {
//         _categories =
//             snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();

//         _isLoadingCategory = false;
//       });
//     } catch (error) {
//       log('Failed to load category: $error');
//     }
//   }

//   Future<void> _loadSubCategory() async {
//     setState(() {
//       _isLoadingSubCategory = true; // Add this line
//     });
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('SubCategories').get();

//       setState(() {
//         _subCategories =
//             snapshot.docs.map((doc) => SubCategory.fromSnapshot(doc)).toList();

//         _isLoadingSubCategory = false;
//       });
//     } catch (error) {
//       log('Failed to load category: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Item'),
//       ),
//       body: _isUploading
//           ? const Center(child: CircularProgressIndicator())
//           : _isItemLoading || _isLoadingCategory || _isLoadingSubCategory
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Title:'),
//                       TextField(controller: _titleController),
//                       const SizedBox(height: 16),
//                       const Text('Food Calories (Comma Separated):'),
//                       TextField(controller: _foodCaloriesController),
//                       const SizedBox(height: 16),
//                       const Text('Description:'),
//                       TextField(controller: _descriptionController),
//                       const SizedBox(height: 16),
//                       const Text('Price:'),
//                       TextField(controller: _priceController),
//                       const SizedBox(height: 16),
//                       const Text('Old Price:'),
//                       TextField(controller: _oldPriceController),
//                       const SizedBox(height: 16),
//                       const Text('Time:'),
//                       TextField(controller: _timeController),
//                       const Text('Priority:'),
//                       TextField(controller: _priorityController),
//                       const SizedBox(height: 16),
//                       const Text('Is Veg:'),
//                       Checkbox(
//                         value: _isVeg,
//                         onChanged: (value) {
//                           setState(() {
//                             _isVeg = value ?? false;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       // const Text('Restaurants:'),
//                       // Column(
//                       //   children: _restaurants.map((restaurant) {
//                       //     return CheckboxListTile(
//                       //       title: Text(restaurant.name),
//                       //       value:
//                       //           _selectedRestaurantIds.contains(restaurant.id),
//                       //       onChanged: (value) {
//                       //         setState(() {
//                       //           if (value != null && value) {
//                       //             _selectedRestaurantIds.add(restaurant.id);
//                       //           } else {
//                       //             _selectedRestaurantIds.remove(restaurant.id);
//                       //           }
//                       //         });
//                       //       },
//                       //     );
//                       //   }).toList(),
//                       // ),
//                       // const SizedBox(height: 16),

//                       const Text('Categories:'),
//                       DropdownButtonFormField<String>(
//                         value: _selectedCategoryId,
//                         items: _categories.map((category) {
//                           return DropdownMenuItem<String>(
//                             value: category.id,
//                             child: Text(category.name),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedCategoryId = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Sub Categories:'),
//                       DropdownButtonFormField<String>(
//                         value: _selectedSubCategoryId,
//                         items: _subCategories.map((subCategory) {
//                           return DropdownMenuItem<String>(
//                             value: subCategory.id,
//                             child: Text(subCategory.name),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedSubCategoryId = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       CustomGradientButton(
//                         text: "Update Item",
//                         onPress: _updateItem,
//                         h: 45,
//                         w: 250,
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   void _updateItem() async {
//     setState(() {
//       _isUploading = true;
//     });

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
//         // 'resId': resId,
//         'categoryId': categoryId,
//         'subCategoryId': subCategoryId,
//       });

//       setState(() {
//         _isUploading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Item updated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Navigate back to previous screen
//       Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });

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
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_otg_manager/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/custom_gradient_button.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../models/restaurant.dart';
import '../../models/subcategory_model.dart';
import '../../utils/app_style.dart';

class EditItemScreen extends StatefulWidget {
  final String itemId;

  const EditItemScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _foodCaloriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  String? newDownloadUrl;

  bool _isAddonAvailable = false;
  bool _isSizesAvailable = false;
  bool _isAllergicIngredientsAvailable = false;
  bool _isVeg = false;
  List<String> _selectedRestaurantIds = [];
  List<String> _selectedSizes = [];
  Map<String, String> sizePrices = {};
  List<String> _selectedAllergic = [];
  List<String> _selectedAddOns = [];
  List<XFile> _itemImage = [];
  final ImagePicker _picker = ImagePicker();

  // late List<Restaurant> _restaurants;
  String? _selectedCategoryId;
  late List<CategoryItems> _categories;
  String? _selectedSubCategoryId;
  late List<SubCategory> _subCategories;
  bool _isUploading = false;
  bool _isItemLoading = false;
  // bool _isLoadingRestaurants = false;
  bool _isLoadingCategory = false;
  bool _isLoadingSubCategory = false;

  @override
  void initState() {
    super.initState();
    _loadItemData();
    // _loadRestaurants();
    _loadCategory();
    _loadSubCategory();
    _loadSizes();
  }

  Future<void> _loadItemData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Items')
          .doc(widget.itemId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          _titleController.text = data['title'] ?? '';
          _foodCaloriesController.text =
              (data['foodCalories'] as List<dynamic>).join(', ');
          _descriptionController.text = data['description'] ?? '';
          _priceController.text = data['price'].toString();
          _oldPriceController.text = data['oldPrice'].toString();
          _timeController.text = data['time'] ?? '';
          _isAddonAvailable = data['isAddonAvailable'] ?? false;
          _isSizesAvailable = data['isSizesAvailable'] ?? false;
          _isAllergicIngredientsAvailable =
              data['isAllergicIngredientsAvailable'] ?? false;
          _isVeg = data['isVeg'] ?? false;
          _selectedRestaurantIds.addAll(List<String>.from(data['resId'] ?? []));
          _selectedCategoryId = data['categoryId'];
          _selectedSubCategoryId = data['subCategoryId'];
          _selectedSizes.addAll(
              List<String>.from(data['sizes'].map((size) => size['sizeId'])));
          sizePrices = Map.fromEntries((data['sizes'] as List<dynamic>).map(
              (size) => MapEntry(size['sizeId'], size['price'].toString())));
          _selectedAddOns.addAll(List<String>.from(data['addOns'] ?? []));
          _selectedAllergic.addAll(List<String>.from(data['allergic'] ?? []));
          newDownloadUrl = data['image'];
        });
      }
    } catch (error) {
      log('Failed to load item data: $error');
    }
  }

  // Future<void> _loadRestaurants() async {
  //   try {
  //     setState(() {
  //       _isLoadingRestaurants = true;
  //     });
  //     QuerySnapshot snapshot =
  //         await FirebaseFirestore.instance.collection('Restaurants').get();

  //     setState(() {
  //       _restaurants =
  //           snapshot.docs.map((doc) => Restaurant.fromSnapshot(doc)).toList();
  //       _isLoadingRestaurants = false;
  //     });
  //   } catch (error) {
  //     log('Failed to load restaurants: $error');
  //     setState(() {
  //       _isLoadingRestaurants = false;
  //     });
  //   }
  // }

  Future<void> _loadCategory() async {
    setState(() {
      _isLoadingCategory = true;
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Categories').get();

      setState(() {
        _categories = snapshot.docs
            .map((doc) => CategoryItems.fromSnapshot(doc))
            .toList();
        _isLoadingCategory = false;
        log("Loading Categories $_categories");
      });
    } catch (error) {
      log('Failed to load category: $error');
      setState(() {
        _isLoadingCategory = false;
      });
    }
  }

  Future<void> _loadSubCategory() async {
    setState(() {
      _isLoadingSubCategory = true;
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
      setState(() {
        _isLoadingSubCategory = false;
      });
    }
  }

  Future<List<Size>> _loadSizes() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('sizes').get();

      return snapshot.docs.map((doc) => Size.fromSnapshot(doc)).toList();
    } catch (error) {
      log('Failed to load sizes: $error');
      return [];
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
                          final sizePrice = sizePrices[sizeId];
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
                                      // Remove the price for the unselected size
                                      sizePrices.remove(sizeId);
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
                                      labelText: 'Price for $sizeTitle',
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    controller: TextEditingController(
                                      text: sizePrice,
                                    ),
                                    onChanged: (value) {
                                      sizePrices[sizeId] = value;
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

  Widget _buildAddOnSection() {
    return _isAddonAvailable
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AddOns :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Adjust the height according to your needs
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AddOns')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final addOnDocs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: addOnDocs.length,
                        itemBuilder: (context, index) {
                          final addOnDoc = addOnDocs[index];
                          final addOnData =
                              addOnDoc.data() as Map<String, dynamic>;
                          final addOnId = addOnDoc.id;
                          final addOnTitle = addOnData['name'] as String?;
                          return CheckboxListTile(
                            title: Text(addOnTitle ?? ''),
                            value: _selectedAddOns.contains(addOnId),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedAddOns.add(addOnId);
                                } else {
                                  _selectedAddOns.remove(addOnId);
                                }
                              });
                            },
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

  Widget _buildAllergicSection() {
    return _isAllergicIngredientsAvailable
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Allergic :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Adjust the height according to your needs
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('allergicIngredients')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sizesDocs = snapshot.data!.docs;
                      final titles = <String>[];
                      sizesDocs.forEach((sizeDoc) {
                        final sizeData = sizeDoc.data() as Map<String, dynamic>;
                        if (sizeData.containsKey('items')) {
                          final sizeItemsRaw = sizeData['items'] as List?;
                          if (sizeItemsRaw != null) {
                            final sizeItems =
                                sizeItemsRaw.cast<Map<String, dynamic>>();
                            sizeItems.forEach((sizeItem) {
                              final title = sizeItem['title'] as String?;
                              if (title != null &&
                                  title.isNotEmpty &&
                                  !titles.contains(title)) {
                                titles.add(title);
                              }
                            });
                          }
                        }
                      });
                      return ListView.builder(
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          final data = titles[index];
                          return CheckboxListTile(
                            title: Text(data),
                            value: _selectedAllergic.contains(data),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedAllergic.add(data);
                                } else {
                                  _selectedAllergic.remove(data);
                                }
                              });
                            },
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

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _itemImage.isEmpty
            ? (newDownloadUrl != null
                ? Image.network(newDownloadUrl!)
                : const Icon(Icons.image, size: 50, color: Colors.grey))
            : Image.file(File(_itemImage.first.path)),
      ),
    );
  }

  Future<void> _selectImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _itemImage = [pickedFile];
        });
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: kDark,
        title: Text("Edit Item"),
      ),
      body: _isLoadingCategory || _isLoadingSubCategory
          ? const Center(child: CircularProgressIndicator())
          : _isUploading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: kIsWeb
                        ? const EdgeInsets.only(left: 450, right: 450, top: 50)
                        : const EdgeInsets.only(left: 10, right: 10, top: 10),
                    decoration: BoxDecoration(
                      color: kLightWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                            child: ReusableText(
                                text: "Edit Item",
                                style: appStyle(20, kDark, FontWeight.bold))),
                        const SizedBox(height: 20),
                        const Text(
                          'Item Name:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _titleController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Image:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        _buildImageSection(),
                        const SizedBox(height: 20),
                        const Text(
                          'Food Calories: (Add comma separated)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _foodCaloriesController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Sale Price:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _priceController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'MRP:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _oldPriceController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Time:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: _timeController,
                        ),
                        const SizedBox(height: 20),
                        const Text('Restaurants:'),
                        // Column(
                        //   children: _restaurants.map((restaurant) {
                        //     return CheckboxListTile(
                        //       title: Text(restaurant.name),
                        //       value: _selectedRestaurantIds
                        //           .contains(restaurant.id),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           if (value != null && value) {
                        //             _selectedRestaurantIds.add(restaurant.id);
                        //           } else {
                        //             _selectedRestaurantIds
                        //                 .remove(restaurant.id);
                        //           }
                        //         });
                        //       },
                        //     );
                        //   }).toList(),
                        // ),
                        // const SizedBox(height: 20),
                        const Text(
                          'Categories:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          hint: const Text('Select Categories'),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value!;
                            });
                          },
                          items: _categories.map((CategoryItems category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Sub Categories:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedSubCategoryId,
                          hint: const Text('Select Sub Categories'),
                          onChanged: (value) {
                            setState(() {
                              _selectedSubCategoryId = value!;
                            });
                          },
                          items: _subCategories.map((SubCategory subCategory) {
                            return DropdownMenuItem<String>(
                              value: subCategory.id,
                              child: Text(subCategory.name),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text("Addon Available"),
                          value: _isAddonAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isAddonAvailable = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Sizes Available"),
                          value: _isSizesAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isSizesAvailable = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Allergic Ingredients Available"),
                          value: _isAllergicIngredientsAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isAllergicIngredientsAvailable = value!;
                            });
                          },
                        ),
                        _buildSizesSection(),
                        SizedBox(height: 5),
                        _buildAddOnSection(),
                        SizedBox(height: 5),
                        _buildAllergicSection(),
                        const SizedBox(height: 20),
                        CustomGradientButton(
                          text: "Edit Item",
                          onPress: _updateItem,
                          h: 45,
                          w: 250,
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  void _updateItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Extract data from form fields and variables
      String title = _titleController.text;
      List<String> foodCalories = _foodCaloriesController.text.split(',');
      String description = _descriptionController.text;
      num price = num.tryParse(_priceController.text) ?? 0;
      num oldPrice = num.tryParse(_oldPriceController.text) ?? 0;
      String time = _timeController.text;
      bool isAddonAvailable = _isAddonAvailable;
      bool isAllergicIngredientsAvailable = _isAllergicIngredientsAvailable;

      // Initialize variables for image handling
      String? itemImageUrl;

      // Check if an image is selected
      if (_itemImage.isNotEmpty) {
        // Upload the image to Firebase Storage
        final DateTime now = DateTime.now();
        final itemImageFile = File(_itemImage.first.path);
        final itemImageName = 'front_${now.microsecondsSinceEpoch}.jpg';
        final Reference frontStorageRef = FirebaseStorage.instance
            .ref()
            .child('item_images')
            .child("images")
            .child(itemImageName);
        await frontStorageRef.putFile(itemImageFile);
        itemImageUrl = await frontStorageRef.getDownloadURL();
      }

      // Update item data in Firestore
      DocumentReference itemRef =
          FirebaseFirestore.instance.collection('Items').doc(widget.itemId);

      // Update basic item details
      await itemRef.update({
        'title': title,
        'foodCalories': foodCalories.map((calorie) => calorie.trim()).toList(),
        'description': description,
        'price': price,
        'oldPrice': oldPrice,
        'time': time,
        'isAddonAvailable': isAddonAvailable,
        'isSizesAvailable': _isSizesAvailable,
        'isAllergicIngredientsAvailable': isAllergicIngredientsAvailable,
        'image': itemImageUrl, // Update image URL if available
      });

      // Update prices for each size if sizes are available
      if (_isSizesAvailable) {
        Map<String, dynamic> sizesData = {};
        _selectedSizes.forEach((sizeId) {
          sizesData[sizeId] = {
            'price': sizePrices[sizeId] ?? '0',
          };
        });

        await itemRef.update({
          'sizes': sizesData,
        });
      }

      setState(() {
        _isUploading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Close the screen
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _uploadImage() async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('item_images')
          .child(_itemImage.first.path);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(File(_itemImage.first.path));

      // Await the completion of the upload task
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (error) {
      print('Failed to upload image: $error');
      return null;
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
