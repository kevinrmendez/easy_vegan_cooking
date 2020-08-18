import 'dart:async';
import 'package:sembast/sembast.dart';

import 'package:easy_vegan_cooking/database/database.dart';
import 'package:easy_vegan_cooking/database/app_database.dart';
import 'package:easy_vegan_cooking/models/Recipe.dart';

class FavoriteDao {
  final dbProvider = FoodDatabase.dbProvider;

  //define store name
  static const String FAVORITE_STORE_NAME = "favorite_Store";

  //create store, passing the store name as an argument
  final _favoriteStore = intMapStoreFactory.store(FAVORITE_STORE_NAME);

  //get the db from the AppDatabase class. this db object will
  //be used through out the app to perform CRUD operations
  Future<Database> get _db async => await AppDatabase.instance.database;

  //insert _todo to store
  Future insert(Recipe recipe) async {
    await _favoriteStore.add(await _db, recipe.toJson());
  }

  //update _todo item in db
  Future update(Recipe recipe) async {
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(recipe.title));
    await _favoriteStore.update(await _db, recipe.toJson(), finder: finder);
  }

  //delete _todo item
  Future delete(Recipe recipe) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    final finder = Finder(filter: Filter.byKey(recipe.id));

    await _favoriteStore.delete(await _db, finder: finder);
  }

  //get all listem from the db
  Future<List<Recipe>> getAllSortedByTImeStamp() async {
    //sort the _todo item in order of their timestamp
    //that is entry time
    final finder = Finder(sortOrders: [SortOrder("timeStamp", false)]);

    //get the data
    final snapshot = await _favoriteStore.find(
      await _db,
      finder: finder,
    );

    //call the map operator on the data
    //this is so we can assign the correct value to the id from the store
    //After we return it as a list
    return snapshot.map((snapshot) {
      final recipe = Recipe.fromJson(snapshot.value);

      recipe.id = snapshot.key;
      return recipe;
    }).toList();
  }

  Future<bool> checkIfRecipeExist(Recipe recipe) async {
    List<Recipe> recipes = await getAllSortedByTImeStamp();
    // bool ifRecipeExists;
    if (recipes.length == 0) {
      return false;
    } else {
      return recipes.indexWhere((element) => element.title == recipe.title) ==
              -1
          ? false
          : true;
    }
  }

  deleteAllFavoriteRecipes() async {
    _favoriteStore.delete(await _db);
  }
}
