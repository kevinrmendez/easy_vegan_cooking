import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/ui/recipeActivity.dart';

import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

class HorizontalRecipeDay extends StatefulWidget {
  final int listSize = 10;
  @override
  HorizontalRecipeDayState createState() => HorizontalRecipeDayState();
}

class HorizontalRecipeDayState extends State<HorizontalRecipeDay> {
  var recipesRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          WidgetUtils.boldTitle('Recipe of the day'),
          StreamBuilder(
              stream: recipesRef.onValue,
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      height: 400,
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
                        // bool itemAdded = false;
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
                        // itemAdded = true;
                      }
                      if (filteredRecipes.isNotEmpty) {
                        filteredRecipes = filteredRecipes.reversed.toList();
                        filteredRecipes =
                            filteredRecipes.getRange(0, 1).toList();
                        return SizedBox(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredRecipes.length,
                            itemBuilder: (BuildContext context, int index) {
                              Recipe recipe =
                                  Utils.recipeBuilder(filteredRecipes[index]);
                              // return Text(recipe.title);
                              return GestureDetector(
                                child: Card(
                                  child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Card(
                                            child: CachedNetworkImage(
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
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      height: 300,
                                                      color: GreyColor,
                                                      constraints:
                                                          BoxConstraints(
                                                              maxHeight: 30,
                                                              maxWidth: 30),
                                                      child: Icon(Icons.error)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                            color: Colors.white,
                                            padding:
                                                EdgeInsets.fromLTRB(0, 7, 6, 7),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  'Lo sentimos, intente de nuevo',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                }
              }),
        ],
      ),
    );
  }
}
