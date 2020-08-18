// import 'dart:async';

// import 'package:easy_vegan_cooking/database/database.dart';
// import 'package:easy_vegan_cooking/models/Recipe.dart';

// class FavoriteRecipeDao {
//   final dbProvider = FoodDatabase.dbProvider;

//   Future<int> createFavoriteRecipe(Recipe favoriteRecipe) async {
//     final db = await dbProvider.database;
//     var result = db.insert(favoriteRecipesTable, favoriteRecipe.toJson());
//     return result;
//   }

//   Future<List<Recipe>> getFavoriteRecipes(
//       {List<String> columns, String query}) async {
//     final db = await dbProvider.database;

//     List<Map<String, dynamic>> result;
//     if (query != null) {
//       if (query.isNotEmpty)
//         result = await db.query(favoriteRecipesTable,
//             columns: columns, where: 'title LIKE ?', whereArgs: ["%$query%"]);
//     } else {
//       result = await db.query(favoriteRecipesTable, columns: columns);
//     }

//     List<Recipe> favoriteRecipes = result.isNotEmpty
//         ? result.map((item) => Recipe.fromJson(item)).toList()
//         : [];
//     return favoriteRecipes;
//   }

//   Future<int> getFavoriteRecipeId(Recipe recipe) async {
//     final db = await dbProvider.database;

//     List<Map<String, dynamic>> result;
//     if (recipe != null) {
//       result = await db.query(favoriteRecipesTable,
//           where: 'title = ?', whereArgs: ["${recipe.title}"]);
//     } else {
//       result = await db.query(favoriteRecipesTable);
//     }
//     Recipe favoriteRecipefromDb = Recipe.fromJson(result[0]);
//     return favoriteRecipefromDb.id;
//   }

//   Future<int> updateFavoriteRecipe(Recipe favoriteRecipe) async {
//     final db = await dbProvider.database;

//     var result = await db.update(favoriteRecipesTable, favoriteRecipe.toJson(),
//         where: "id = ?", whereArgs: [favoriteRecipe.id]);

//     return result;
//   }

//   Future<int> deleteFavoriteRecipe(int id) async {
//     final db = await dbProvider.database;
//     var result =
//         await db.delete(favoriteRecipesTable, where: 'id = ?', whereArgs: [id]);

//     return result;
//   }

//   Future deleteAllFavoriteRecipes() async {
//     final db = await dbProvider.database;
//     var result = await db.delete(
//       favoriteRecipesTable,
//     );

//     return result;
//   }
// }
