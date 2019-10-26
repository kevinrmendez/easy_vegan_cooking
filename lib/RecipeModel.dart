import 'package:flutter/material.dart';

import 'Recipe.dart';
import 'dart:collection';

class RecipeModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Recipe> _recipes = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Recipe> get recipes => UnmodifiableListView(_recipes);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Recipe recipe) {
    _recipes.add(recipe);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(Recipe recipe) {
    _recipes.removeAt(recipes.indexOf(recipe));
    notifyListeners();
  }
}
