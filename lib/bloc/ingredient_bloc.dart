import 'package:rxdart/rxdart.dart';

import 'package:easy_vegan_cooking/models/Ingredient.dart';
import 'package:easy_vegan_cooking/repository/ingredient_repository.dart';

class IngredientService {
  final IngredientRepository _ingredientRepository = IngredientRepository();
  static List<Ingredient> dbIngredients;

  BehaviorSubject<List<Ingredient>> _ingredientList =
      BehaviorSubject.seeded([]);

  Stream get stream => _ingredientList.stream;

  List<Ingredient> get currentList => _ingredientList.value;

  IngredientService() {
    _getIngredients();
  }

  void _getIngredients() async {
    dbIngredients = await _ingredientRepository.getAllIngredients();
    _ingredientList.add(dbIngredients);
    print("DB DATA");
    dbIngredients.forEach((element) {
      print(element.name);
    });
  }

  add(Ingredient ingredient) async {
    var isIngredientInDb =
        await _ingredientRepository.checkIFIngredientExist(ingredient);
    if (!isIngredientInDb) {
      _ingredientList.value.add(ingredient);
      _ingredientList.add(List<Ingredient>.from(currentList));
      await _ingredientRepository.insertIngredient(ingredient);
      _getIngredients();
    }
  }

  remove(Ingredient ingredient) async {
    _ingredientList.value.removeWhere(
        (ingredientItem) => ingredientItem.name == ingredient.name);
    _ingredientList.add(List<Ingredient>.from(currentList));
    await _ingredientRepository.deleteIngredientById(ingredient);
    _getIngredients();
  }

  // getFoodId(Recipe recipe) async {
  //   int id = await _ingredientRepository.getIngredientRecipeId(recipe);
  //   return id;
  // }

  update(Ingredient ingredient) async {
    await _ingredientRepository.updateIngredient(ingredient);
    _getIngredients();
  }

  void orderIngredientsAscending() {
    List<Ingredient> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    _ingredientList.add(orderList);
  }

  void orderIngredientsDescending() {
    List<Ingredient> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    List<Ingredient> reversedList = orderList.reversed.toList();
    _ingredientList.add(reversedList);
  }

  void deleteAll() {
    _ingredientRepository.deleteAllIngredients();
    _getIngredients();
  }
}

IngredientService ingredientServices = IngredientService();
