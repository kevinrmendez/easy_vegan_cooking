import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/activity/recipeActivity.dart';

import 'package:easy_vegan_cooking/main.dart';

class HorizontalNewRecipesList extends StatefulWidget {
  final int listSize = 10;
  final String category = "ensaladas";
  @override
  HorizontalNewRecipesListState createState() =>
      HorizontalNewRecipesListState();
}

class HorizontalNewRecipesListState extends State<HorizontalNewRecipesList> {
  var recipesRef = FirebaseDatabase.instance.reference();

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
        attribution: data["attribution"],
        isFavorite: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: recipesRef.onValue,
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 300,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  ],
                )),
              );
            default:
              // print("SNAPSHOT: ${snap.data.snapshot.value}");
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                DataSnapshot snapshot = snap.data.snapshot;
                // print("SNAPSHOT: ${snapshot.value}");
                List filteredRecipes = [];
                List recipesList = snapshot.value.toList();
                for (var i = 0; i < recipesList.length; i++) {
                  // print('FILTERING DATA');
                  // print(recipesList[i]);

                  bool itemAdded = false;
                  // widget.labels.forEach((item) {
                  //   if (recipesList[i]["labels"].contains(item) &&
                  //       itemAdded == false &&
                  //       recipesList[i]["title"]
                  //               .contains(widget.currentRecipe.title) ==
                  //           false) {
                  //     filteredRecipes.add(recipesList[i]);
                  //     itemAdded = true;
                  //   }
                  // });
                  filteredRecipes.add(recipesList[i]);
                  itemAdded = true;

                  // filteredRecipes.add(recipesList[i]);
                }
                if (filteredRecipes.isNotEmpty) {
                  filteredRecipes = filteredRecipes.reversed.toList();
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredRecipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        Recipe recipe = _recipeBuilder(filteredRecipes[index]);
                        // return Text(recipe.title);
                        return GestureDetector(
                          child: Card(
                            child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                fit: StackFit.loose,
                                children: <Widget>[
                                  Container(
                                    width: 300,
                                    child: Card(
                                      child: CachedNetworkImage(
                                        // height: 300,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ),
                                        imageUrl: recipe.image,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 300,
                                          color: GreyColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child:
                                                      new CircularProgressIndicator()),
                                            ],
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                height: 300,
                                                color: GreyColor,
                                                constraints: BoxConstraints(
                                                    maxHeight: 30,
                                                    maxWidth: 30),
                                                child: Icon(Icons.error)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    width: 300,
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.fromLTRB(0, 7, 6, 7),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            recipe.title,
                                            style: TextStyle(
                                                // color: Colors.white
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          Text(" ${recipe.time} min",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  // color: Colors.white
                                                  fontSize: 16,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipeActivity(
                                          recipe: recipe,
                                        )));
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Lo sentimos, no encontramos ninguna sugerencia por el momento',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
          }
        });
  }
}
