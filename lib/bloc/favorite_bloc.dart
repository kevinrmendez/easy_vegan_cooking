import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/repository/favorite_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteService {
  final FavoriteRepository _favoriteRecipeRepository = FavoriteRepository();
  static List<Recipe> dbFavoriteRecipes;

  BehaviorSubject<List<Recipe>> _favoriteRecipeList =
      BehaviorSubject.seeded([]);
  // BehaviorSubject.seeded([dbFavoriteRecipes] == null ? <List<Food>>[] : dbFavoriteRecipes);

  Stream get stream => _favoriteRecipeList.stream;

  List<Recipe> get currentList => _favoriteRecipeList.value;

  FavoriteService() {
    _getFavoriteRecipes();
  }

  void _getFavoriteRecipes() async {
    dbFavoriteRecipes = await _favoriteRecipeRepository.getAllFavoriteRecipes();
    _favoriteRecipeList.add(dbFavoriteRecipes);
    print("DB DATA");
    dbFavoriteRecipes.forEach((element) {
      print(element.title);
    });
  }

  add(Recipe recipe) async {
    var isRecipeInDb =
        await _favoriteRecipeRepository.checkIFFavoriteRecipeExist(recipe);
    if (!isRecipeInDb) {
      _favoriteRecipeList.value.add(recipe);
      _favoriteRecipeList.add(List<Recipe>.from(currentList));
      await _favoriteRecipeRepository.insertFavoriteRecipe(recipe);
      _getFavoriteRecipes();
    }
  }

  remove(Recipe recipe) async {
    _favoriteRecipeList.value
        .removeWhere((recipeItem) => recipeItem.title == recipe.title);
    _favoriteRecipeList.add(List<Recipe>.from(currentList));
    await _favoriteRecipeRepository.deleteFavoriteRecipeById(recipe);
    _getFavoriteRecipes();
  }

  // getFoodId(Recipe recipe) async {
  //   int id = await _favoriteRecipeRepository.getFavoriteRecipeId(recipe);
  //   return id;
  // }

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

FavoriteService favoriteServices = FavoriteService();
