import 'dart:async';

import 'package:easy_vegan_cooking/components/imageComponent.dart';
import 'package:easy_vegan_cooking/components/imageComponent2.dart';
import 'package:easy_vegan_cooking/components/imageComponentParallax.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Recipe.dart';
import '../components/AppDrawer.dart';

class RecipeOfDayActivity extends StatefulWidget {
  RecipeOfDayActivity({Key key}) : super(key: key);

  @override
  _RecipeOfDayActivityState createState() => _RecipeOfDayActivityState();
}

class _RecipeOfDayActivityState extends State<RecipeOfDayActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;

  @override
  void initState() {
    recipesRef = FirebaseDatabase.instance.reference();
    super.initState();
  }

  @override
  void dispose() {
    _recipesSubscription..cancel();
    super.dispose();
  }

  Recipe _recipeBuilder(data) {
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
        isFavorite: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Recipe of the Day'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance.reference().limitToLast(1),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Recipe recipe = _recipeBuilder(snapshot.value);
                  return ImageComponent2(
                    // return ImageComponentParallax(
                    recipe: recipe,
                  );
                },
              ),
            ),
            // AdmobBanner(
            //   adUnitId: getBannerAdUnitId(),
            //   adSize: AdmobBannerSize.BANNER,
            // ),
          ],
        ),
      ),
    );
  }
}
