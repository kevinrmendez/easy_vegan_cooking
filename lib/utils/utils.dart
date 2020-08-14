import 'package:easy_vegan_cooking/models/Recipe.dart';

class Utils {
  static Recipe recipeBuilder(data) {
    return Recipe(
        image: data["image"],
        title: data["title"],
        category: data["category"],
        difficulty: data["difficulty"],
        suggestions: data["suggestions"],
        time: data["time"],
        serves: data["serves"],
        ingredients: data["ingredients"],
        steps: data["steps"],
        labels: data["labels"],
        nutrition: data["nutrition"],
        attribution: data["attribution"],
        isFavorite: 0);
  }
}
