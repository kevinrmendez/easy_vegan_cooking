class Ingredient {
  int id;
  final String name;
  bool isChecked;

  Ingredient({this.id, this.name, this.isChecked});

  @override
  String toString() {
    print("Ingredient:: name:$name, isChecked: $isChecked");
    return super.toString();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      // id: json['id'],
      name: json['name'],
      isChecked: json['isChecked'],
    );
  }
}
