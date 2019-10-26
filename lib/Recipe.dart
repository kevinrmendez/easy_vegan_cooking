class Recipe {
  final String image;
  final String title;
  final String category;
  final String difficulty;
  final String instructions;
  final int time;
  final int serves;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> labels;
  final Map<String, int> nutrition;
  bool isFavorite;

  Recipe(
      {this.image,
      this.title,
      this.category,
      this.difficulty,
      this.instructions,
      this.time,
      this.serves,
      this.ingredients,
      this.steps,
      this.labels,
      this.nutrition,
      this.isFavorite});

  @override
  String toString() {
    print(
        "RECIPE:: title:$title, category:$category, difficulty: $difficulty, time: $time,serves:$serves, ingredients: $ingredients,steps: $steps,isFavorite: $isFavorite");
    return super.toString();
  }
}
