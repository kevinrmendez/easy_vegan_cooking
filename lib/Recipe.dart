class Recipe {
  final String image;
  final String title;
  final String category;
  final String difficulty;
  final String instructions;
  final int time;
  final int serves;
  final List ingredients;
  final List steps;
  final List labels;
  final List nutrition;
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
    print("""
        RECIPE:: title:$title, 
        image: $image,
        category:$category, 
        difficulty: $difficulty, 
        time: $time,
        serves:$serves, 
        ingredients: $ingredients,
        steps: $steps,
        isFavorite: $isFavorite,
        labeLs: $labels,
        nutrition: $nutrition
        """);
    return super.toString();
  }
}
