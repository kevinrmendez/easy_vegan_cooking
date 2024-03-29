import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final favoriteRecipesTable = 'FavoriteRecipes';

class FoodDatabase {
  static final FoodDatabase dbProvider = FoodDatabase();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "food.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $favoriteRecipesTable("
        "id INTEGER  PRIMARY KEY AUTOINCREMENT, "
        "title TEXT, "
        "image TEXT, "
        "category TEXT,"
        "difficulty TEXT,"
        "time INTEGER,"
        "serves INTEGER,"
        "ingredients TEXT,"
        "steps TEXT,"
        "labels TEXT,"
        "suggestions TEXT,"
        "nutrition TEXT,"
        "attribution TEXT,"
        "isFavorite INTEGER DEFAULT 0"
        ")");
  }
}
