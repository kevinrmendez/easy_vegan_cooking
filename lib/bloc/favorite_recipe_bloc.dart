import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/repository/favorite_recipe_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteRecipeService {
  final FavoriteRecipeRepository _favoriteRecipeRepository =
      FavoriteRecipeRepository();
  static List<Recipe> dbFavoriteRecipes;

  BehaviorSubject<List<Recipe>> _favoriteRecipeList =
      BehaviorSubject.seeded([]);
  // BehaviorSubject.seeded([dbFavoriteRecipes] == null ? <List<Food>>[] : dbFavoriteRecipes);

  Stream get stream => _favoriteRecipeList.stream;

  List<Recipe> get currentList => _favoriteRecipeList.value;

  FoodService() {
    _getFavoriteRecipes();
  }

  void _getFavoriteRecipes() async {
    dbFavoriteRecipes = await _favoriteRecipeRepository.getAllFavoriteRecipes();
    _favoriteRecipeList.add(dbFavoriteRecipes);
  }

  add(Recipe recipe) async {
    _favoriteRecipeRepository.insertFavoriteRecipe(recipe);
    _favoriteRecipeList.value.add(recipe);
    _favoriteRecipeList.add(List<Recipe>.from(currentList));

    _getFavoriteRecipes();
  }

  remove(int id, [int index]) async {
    _favoriteRecipeList.value.removeWhere((recipe) => recipe.id == id);
    _favoriteRecipeList.add(List<Recipe>.from(currentList));
    _favoriteRecipeRepository.deleteFavoriteRecipeById(id);

    _getFavoriteRecipes();
  }

  getFoodId(Recipe recipe) async {
    int id = await _favoriteRecipeRepository.getFavoriteRecipeId(recipe);
    return id;
  }

  update(Recipe recipe) async {
    await _favoriteRecipeRepository.updateFavoriteRecipe(recipe);
    _getFavoriteRecipes();
  }

  void orderFavoriteRecipesAscending() {
    List<Recipe> orderList = currentList;
    orderList.sort((a, b) => a.title.compareTo(b.title));
    _favoriteRecipeList.add(orderList);
  }

  void orderFavoriteRecipesDescending() {
    List<Recipe> orderList = currentList;
    orderList.sort((a, b) => a.title.compareTo(b.title));
    List<Recipe> reversedList = orderList.reversed.toList();
    _favoriteRecipeList.add(reversedList);
  }
}

FavoriteRecipeService favoriteRecipeServices = FavoriteRecipeService();
