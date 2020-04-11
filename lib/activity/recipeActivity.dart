import 'package:easy_vegan_cooking/components/imageComponent.dart';
import 'package:easy_vegan_cooking/components/imageComponentParallax.dart';
import 'package:flutter/material.dart';
// import 'package:swipedetector/swipedetector.dart';

import '../Recipe.dart';

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
        appBar: AppBar(
          title: Text(widget.recipe.title),
        ),
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