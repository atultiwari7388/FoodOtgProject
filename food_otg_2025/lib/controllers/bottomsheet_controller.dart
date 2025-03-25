import 'package:get/get.dart';

class BottomSheetController extends GetxController {
  var quantity = 1.obs;
  var totalPrice = 0.0.obs;
  var selectedAllergicIngredients = <String, bool>{}.obs;
  var selectedSizeIndex = 0.obs;
  var food;

  void setFood(Map<dynamic, dynamic> foodData) {
    food = foodData;
    // Initialize total price with the price of the food
    totalPrice.value = double.parse(food["price"].toStringAsFixed(1));
  }

  void incrementQuantity() {
    quantity++;
    totalPrice.value += double.parse(food["price"]
        .toStringAsFixed(1)); // Use .value to access the underlying value
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      totalPrice.value -= double.parse(food["price"]
          .toStringAsFixed(1)); // Use .value to access the underlying value
    }
  }

  void toggleAllergicIngredient(String title, bool isChecked) {
    selectedAllergicIngredients[title] = isChecked;
    update();
  }

  bool isAllergicIngredientSelected(String title) {
    return selectedAllergicIngredients[title] ?? false;
  }

  void setSelectedSizeIndex(int index) {
    selectedSizeIndex.value =
        index; // Use .value to access the underlying value
    update();
  }

  double calculateTotalPrice() {
    double price = double.parse(food["price"].toStringAsFixed(1));

    // Add price of selected allergic ingredients
    for (var entry in selectedAllergicIngredients.entries) {
      if (entry.value) {
        final allergicFood = food["allergicIngredients"].firstWhere(
          (food) => food["title"] == entry.key,
          orElse: () => null,
        );

        if (allergicFood != null) {
          price += allergicFood["price"];
        }
      }
    }

    // Add price of selected size
    price += food["sizes"][selectedSizeIndex.value]
        ["price"]; // Use .value to access the underlying value

    return price * quantity.value;
  }
}
