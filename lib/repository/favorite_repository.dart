import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/dao/favorite_dao.dart';

class FavoriteRepository {
  final foodDao = FavoriteDao();

  Future getAllFavoriteRecipes({String query}) =>
      foodDao.getAllSortedByTImeStamp();

  Future insertFavoriteRecipe(Recipe recipe) => foodDao.insert(recipe);

  Future checkIFFavoriteRecipeExist(Recipe recipe) =>
      foodDao.checkIfRecipeExist(recipe);

  Future updateFavoriteRecipe(Recipe recipe) => foodDao.update(recipe);

  Future deleteFavoriteRecipeById(Recipe recipe) => foodDao.delete(recipe);

  Future deleteAllFavoriteRecipes() => foodDao.deleteAllFavoriteRecipes();
}
