import 'package:easy_vegan_cooking/components/imageComponentParallax.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';
import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:flutter/material.dart';
// import 'package:swipedetector/swipedetector.dart';

class RecipeActivity extends StatefulWidget {
  final Recipe recipe;
  RecipeActivity({this.recipe});
  @override
  RecipeActivityState createState() => RecipeActivityState();
}

class RecipeActivityState extends State<RecipeActivity> {
  @override
  void initState() {
    // index = data.indexOf(widget.recipe);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUtils.appBar(title: widget.recipe.title),
        body: Center(
          // child: ImageComponent(
          //   recipe: widget.recipe,
          // ),
          child: ImageComponentParallax(
            recipe: widget.recipe,
          ),
        ));
  }
}
