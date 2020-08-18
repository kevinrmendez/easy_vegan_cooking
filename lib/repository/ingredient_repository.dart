import 'package:easy_vegan_cooking/dao/ingredient_dao.dart';
import 'package:easy_vegan_cooking/models/Ingredient.dart';

class IngredientRepository {
  final ingredientDao = IngredientDao();

  Future getAllIngredients({String query}) =>
      ingredientDao.getAllSortedByTImeStamp();

  Future insertIngredient(Ingredient ingredient) =>
      ingredientDao.insert(ingredient);

  Future checkIFIngredientExist(Ingredient ingredient) =>
      ingredientDao.checkIfIngredientExist(ingredient);

  Future updateIngredient(Ingredient ingredient) =>
      ingredientDao.update(ingredient);

  Future deleteIngredientById(Ingredient ingredient) =>
      ingredientDao.delete(ingredient);

  Future deleteAllIngredients() => ingredientDao.deleteAllIngredients();
}
