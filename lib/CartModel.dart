import 'package:flutter/material.dart';

import 'models/Ingredient.dart';
import 'dart:collection';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Ingredient> _cartIngredients = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Ingredient> get ingredients =>
      UnmodifiableListView(_cartIngredients);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Ingredient ingredient) {
    _cartIngredients.add(ingredient);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(Ingredient ingredient) {
    _cartIngredients.removeAt(ingredients.indexOf(ingredient));
    notifyListeners();
  }

  void removeAll() {
    _cartIngredients.clear();
    notifyListeners();
  }
}
