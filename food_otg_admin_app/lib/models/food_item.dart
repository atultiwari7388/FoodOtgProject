class FoodItem {
  final String id;
  final String title;
  final List<String> foodTags;
  final List<String> foodType;
  final String code;
  final bool isAvailable;
  final bool isVeg;
  final String restaurant;
  final double rating;
  final String ratingCount;
  final String description;
  final double price;
  final List<Map<String, dynamic>> additives;
  final List<Map<String, dynamic>> addOns;
  final bool isAddonAvailable;
  final List<Map<String, dynamic>> sizes;
  final bool isSizesAvailable;
  final bool isAllergicIngredientsAvailable;
  final List<Map<String, dynamic>> allergicIngredients;
  final String imageUrl;
  final String category;
  final String time;

  FoodItem({
    required this.id,
    required this.title,
    required this.foodTags,
    required this.foodType,
    required this.code,
    required this.isAvailable,
    required this.isVeg,
    required this.restaurant,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.price,
    required this.additives,
    required this.addOns,
    required this.isAddonAvailable,
    required this.sizes,
    required this.isSizesAvailable,
    required this.isAllergicIngredientsAvailable,
    required this.allergicIngredients,
    required this.imageUrl,
    required this.category,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'foodTags': foodTags,
      'foodType': foodType,
      'code': code,
      'isAvailable': isAvailable,
      'isVeg': isVeg,
      'restaurant': restaurant,
      'rating': rating,
      'ratingCount': ratingCount,
      'description': description,
      'price': price,
      'additives': additives,
      'addOns': addOns,
      'isAddonAvailable': isAddonAvailable,
      'sizes': sizes,
      'isSizesAvailable': isSizesAvailable,
      'isAllergicIngredientsAvailable': isAllergicIngredientsAvailable,
      'allergicIngredients': allergicIngredients,
      'imageUrl': imageUrl,
      'category': category,
      'time': time,
    };
  }
}
