class Ingredient {
  final String name;

  bool isChecked;

  Ingredient({this.name, this.isChecked});

  @override
  String toString() {
    print("Ingredient:: name:$name, isFavorite: $isChecked");
    return super.toString();
  }
}
