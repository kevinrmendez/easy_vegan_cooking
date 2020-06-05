import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Recipe.dart';

class FavoritesDb {
  Future<Database> getDb() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'recipes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE favorites( title TEXT, isFavorite INTEGER DEFAULT 0)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertFavorite(Recipe recipe) async {
    // Get a reference to the database.
    final Database db = await getDb();
    Favorite favorite = Favorite(recipe.title, recipe.isFavorite);

    await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Favorite>> favorites() async {
    // Get a reference to the database.
    final Database db = await getDb();

    final List<Map<String, dynamic>> maps =
        await db.query('favorites', orderBy: 'title');

    // Convert the List<Map<String, dynamic> into a List<Contact>.
    return List.generate(maps.length, (i) {
      return Favorite(
        maps[i]['title'],
        maps[i]['isFavorite'],
      );
    });
  }

  // Future<Contact> getContactById(int id) async {
  //   // Get a reference to the database.
  //   List contacts = await this.contacts();
  //   Contact contact;
  //   contacts.forEach((dbContact) {
  //     if (dbContact.id == id) {
  //       contact = dbContact;
  //     }
  //   });
  //   return contact;
  // }

  Future<void> updateFavorite(Recipe recipe) async {
    // Get a reference to the database.
    Favorite favorite = Favorite(recipe.title, recipe.isFavorite);
    final db = await getDb();

    await db.update(
      'favorites',
      favorite.toMap(),
      where: "id = ?",
      whereArgs: [favorite.title],
    );
  }

  // Future<int> getId(String contactName) async {
  //   final db = await getDb();

  //   final List<Map<String, dynamic>> query = await db.query('contacts',
  //       columns: ['id', 'name'], where: 'name = ?', whereArgs: [contactName]);
  //   int id = query.first['id'];
  //   print(id);
  //   return id;
  // }

  Future<void> deleteFavorite(Recipe recipe) async {
    // Get a reference to the database.
    final db = await getDb();

    await db.delete(
      'favorites',
      where: "title = ?",
      whereArgs: [recipe.title],
    );
  }

  Future<bool> deleteAllFavorites() async {
    // Get a reference to the database.
    final db = await getDb();
    bool isDataDeleted;

    await db
        .delete(
      'favorites',
    )
        .then((rowsAffected) {
      if (rowsAffected == 0) {
        isDataDeleted = false;
      } else {
        isDataDeleted = true;
      }
    });
    return isDataDeleted;
  }
}
