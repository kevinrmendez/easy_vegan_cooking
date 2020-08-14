import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/dao/favorite_recipe_dao.dart';

class FavoriteRecipeRepository {
  final foodDao = FavoriteRecipeDao();

  Future getAllFavoriteRecipes({String query}) =>
      foodDao.getFavoriteRecipes(query: query);

  Future getFavoriteRecipeId(Recipe recipe) =>
      foodDao.getFavoriteRecipeId(recipe);

  Future insertFavoriteRecipe(Recipe recipe) =>
      foodDao.createFavoriteRecipe(recipe);

  Future updateFavoriteRecipe(Recipe recipe) =>
      foodDao.updateFavoriteRecipe(recipe);

  Future deleteFavoriteRecipeById(int id) => foodDao.deleteFavoriteRecipe(id);

  Future deleteAllFavoriteRecipes() => foodDao.deleteAllFavoriteRecipes();
}
