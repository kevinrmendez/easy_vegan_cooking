import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/dao/favorite_dao.dart';

class FavoriteRepository {
  final foodDao = FavoriteDao();

  Future getAllFavoriteRecipes({String query}) =>
      foodDao.getAllSortedByTImeStamp();

  // Future getFavoriteRecipeId(Recipe recipe) =>
  //     foodDao.getFavoriteRecipeId(recipe);

  Future insertFavoriteRecipe(Recipe recipe) => foodDao.insert(recipe);

  Future updateFavoriteRecipe(Recipe recipe) => foodDao.update(recipe);

  Future deleteFavoriteRecipeById(String title) => foodDao.delete(title);

  // Future deleteAllFavoriteRecipes() => foodDao.deleteAllFavoriteRecipes();
}
