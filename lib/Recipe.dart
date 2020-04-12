class Recipe {
  final String image;
  final String title;
  final String category;
  final String difficulty;
  final String suggestions;
  final int time;
  final int serves;
  final List ingredients;
  final List steps;
  final List labels;
  final List nutrition;
  final Map attribution;
  bool isFavorite;

  Recipe(
      {this.image,
      this.title,
      this.category,
      this.difficulty,
      this.suggestions,
      this.time,
      this.serves,
      this.ingredients,
      this.steps,
      this.labels,
      this.nutrition,
      this.isFavorite,
      this.attribution});

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
        attributionName: ${attribution["name"]}
        attributionLink: ${attribution["link"]}
        """);
    return super.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'category': category,
      'difficulty': difficulty,
      'time': time,
      'serves': serves,
      'ingredients': ingredients,
      'steps': steps,
      'isFavorite': isFavorite,
      'labels': labels,
      'nutrition': nutrition,
      'attribution': attribution
    };
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'category': category,
        'difficulty': difficulty,
        'time': time,
        'serves': serves,
        'ingredients': ingredients,
        'steps': steps,
        'isFavorite': isFavorite,
        'labels': labels,
        'nutrition': nutrition,
        'attribution': attribution
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        title: json['title'],
        image: json['image'],
        category: json['category'],
        difficulty: json['difficulty'],
        time: json['time'],
        serves: json['serves'],
        ingredients: json['ingredients'],
        steps: json['steps'],
        isFavorite: json['isFavorite'],
        labels: json['labels'],
        nutrition: json['nutrition'],
        attribution: json['attribution']);
  }
}
