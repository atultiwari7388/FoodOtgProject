import 'package:get/get.dart';

class FoodTileController extends GetxController {
  int _selectedSizeIndex = 0;
  Set<String> _selectedAddOns = {};
  Set<String> _selectedAllergicOns = {};

  int get selectedSizeIndex => _selectedSizeIndex;
  Set<String> get selectedAddOns => _selectedAddOns;
  Set<String> get selectedAllergicOns => _selectedAllergicOns;

  set selectedSizeIndex(int index) {
    _selectedSizeIndex = index;
    update();
  }

  void toggleAddOn(String title) {
    if (_selectedAddOns.contains(title)) {
      _selectedAddOns.remove(title);
    } else {
      _selectedAddOns.add(title);
    }
    update();
  }

  void toggleAllergicIngredient(String title) {
    if (_selectedAllergicOns.contains(title)) {
      _selectedAllergicOns.remove(title);
    } else {
      _selectedAllergicOns.add(title);
    }
    update();
  }

  double calculateTotalPrice(dynamic food) {
    double sizePrice = food["sizes"][_selectedSizeIndex]["price"];
    double addOnsPrice = _selectedAddOns.length > 0
        ? _selectedAddOns
            .map((title) =>
                food["addOns"].firstWhere((addOn) => addOn["title"] == title))
            .map<double>((addOn) => addOn["price"])
            .reduce((value, element) => value + element)
        : 0;
    return sizePrice + addOnsPrice;
  }
}
