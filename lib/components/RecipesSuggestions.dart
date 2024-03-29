import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:easy_vegan_cooking/ui/recipeActivity.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';

import '../models/Recipe.dart';
import '../apikeys.dart';

class RecipesSuggestions extends StatefulWidget {
  final List labels;
  final Recipe currentRecipe;
  RecipesSuggestions({Key key, this.labels, this.currentRecipe})
      : super(key: key);

  @override
  _RecipesSuggestionsState createState() => _RecipesSuggestionsState();
}

class _RecipesSuggestionsState extends State<RecipesSuggestions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAd() async {
    _counter++;
    if (_counter % 2 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    var recipesRef = FirebaseDatabase.instance.reference();

    // recipesRef.once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });

    return Row(
      children: <Widget>[
        StreamBuilder(
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
                      print('FILTERING DATA');
                      print(recipesList[i]);

                      bool itemAdded = false;
                      widget.labels.forEach((item) {
                        if (recipesList[i]["labels"].contains(item) &&
                            itemAdded == false &&
                            recipesList[i]["title"]
                                    .contains(widget.currentRecipe.title) ==
                                false) {
                          filteredRecipes.add(recipesList[i]);
                          itemAdded = true;
                        }
                      });

                      // filteredRecipes.add(recipesList[i]);
                    }
                    if (filteredRecipes.isNotEmpty) {
                      return Expanded(
                        child: SizedBox(
                          height: 200,
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
                                          width: 300,
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
                                                      // color: Colors.white
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
                                  _showAd();
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
                                'oops no suggestions found this time',
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
    );
  }
}

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

int _counter = 0;
