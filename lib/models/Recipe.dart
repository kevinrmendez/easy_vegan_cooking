class Recipe {
  int id;
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
  int isFavorite;

  Recipe(
      {this.id,
      this.image,
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
        id: $id,
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

  // Map<String, dynamic> toMap() {
  //   return {
  //     'title': title,
  //     'image': image,
  //     'category': category,
  //     'difficulty': difficulty,
  //     'time': time,
  //     'serves': serves,
  //     'ingredients': ingredients,
  //     'steps': steps,
  //     'isFavorite': isFavorite,
  //     'labels': labels,
  //     'nutrition': nutrition,
  //     'attribution': attribution
  //   };
  // }

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'category': category,
        'difficulty': difficulty,
        'time': time,
        'serves': serves,
        'ingredients': ingredients,
        'steps': steps,
        'labels': labels,
        'nutrition': nutrition,
        'attribution': attribution,
        "suggestions": suggestions,
        'isFavorite': isFavorite,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      // id: json['id'],
      title: json['title'],
      image: json['image'],
      category: json['category'],
      difficulty: json['difficulty'],
      time: json['time'],
      serves: json['serves'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      labels: json['labels'],
      nutrition: json['nutrition'],
      attribution: json['attribution'],
      isFavorite: json['isFavorite'],
    );
  }
}

class Favorite {
  String title;
  int isFavorite;

  Favorite(title, isFavorite);

  Map<String, dynamic> toJson() => {
        'title': title,
        'favorite': isFavorite,
      };
  Map<String, dynamic> toMap() {
    return {'title': title, 'isFavorite': isFavorite};
  }

  @override
  String toString() {
    print("""
       FAVORITE:: title: $title, favorite: $isFavorite
        """);
    return super.toString();
  }
}
