import 'dart:async';
import 'package:sembast/sembast.dart';

import 'package:easy_vegan_cooking/database/database.dart';
import 'package:easy_vegan_cooking/database/app_database.dart';
import 'package:easy_vegan_cooking/models/Ingredient.dart';

class IngredientDao {
  final dbProvider = FoodDatabase.dbProvider;

  //define store name
  static const String INGREDIENT_STORE_NAME = "ingredient_Store";

  //create store, passing the store name as an argument
  final _ingredientStore = intMapStoreFactory.store(INGREDIENT_STORE_NAME);

  //get the db from the AppDatabase class. this db object will
  //be used through out the app to perform CRUD operations
  Future<Database> get _db async => await AppDatabase.instance.database;

  //insert _todo to store
  Future insert(Ingredient ingredient) async {
    await _ingredientStore.add(await _db, ingredient.toJson());
  }

  //update _todo item in db
  Future update(Ingredient ingredient) async {
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(ingredient.name));
    await _ingredientStore.update(await _db, ingredient.toJson(),
        finder: finder);
  }

// TODO:fix remove item
  //delete _todo item
  Future delete(Ingredient ingredient) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    final finder = Finder(filter: Filter.byKey(ingredient.id));

    await _ingredientStore.delete(await _db, finder: finder);
  }

  //get all listem from the db
  Future<List<Ingredient>> getAllSortedByTImeStamp() async {
    //sort the _todo item in order of their timestamp
    //that is entry time
    final finder = Finder(sortOrders: [SortOrder("timeStamp", false)]);

    //get the data
    final snapshot = await _ingredientStore.find(
      await _db,
      finder: finder,
    );

    //call the map operator on the data
    //this is so we can assign the correct value to the id from the store
    //After we return it as a list
    return snapshot.map((snapshot) {
      final ingredient = Ingredient.fromJson(snapshot.value);

      ingredient.id = snapshot.key;
      return ingredient;
    }).toList();
  }

  Future<bool> checkIfIngredientExist(Ingredient ingredient) async {
    List<Ingredient> recipes = await getAllSortedByTImeStamp();
    // bool ifRecipeExists;
    if (recipes.length == 0) {
      return false;
    } else {
      return recipes.indexWhere((element) => element.name == ingredient.name) ==
              -1
          ? false
          : true;
    }
  }

// TODO:fix remove all
  deleteAllIngredients() async {
    List<Ingredient> recipes = await getAllSortedByTImeStamp();
    recipes.forEach((element) {
      delete(element);
    });
    // _ingredientStore.delete(await _db);
  }
}
