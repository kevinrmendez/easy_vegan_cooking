import 'package:easy_vegan_cooking/components/imageComponent.dart';
import 'package:flutter/material.dart';
// import 'package:swipedetector/swipedetector.dart';

import '../Recipe.dart';

class ImageActivity extends StatefulWidget {
  final Recipe recipe;
  ImageActivity({this.recipe});
  @override
  ImageActivityState createState() => ImageActivityState();
}

class ImageActivityState extends State<ImageActivity> {
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
        body: Center(
      child: ImageComponent(
        recipe: widget.recipe,
      ),
    ));
  }
}
