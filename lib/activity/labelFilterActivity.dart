import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/favoriteWidget.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Recipe.dart';
import '../apikeys.dart';
import '../components/AppDrawer.dart';

import 'imageActivity.dart';
import '../helpers.dart';

class LabelFilterActivity extends StatefulWidget {
  final String label;
  LabelFilterActivity({Key key, this.label}) : super(key: key);
  // GridActivity() {
  //   data.shuffle();
  // }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LabelFilterActivityState createState() => _LabelFilterActivityState();
}

class _LabelFilterActivityState extends State<LabelFilterActivity> {
  // void _showAd() async {
  //   _counter++;
  //   if (_counter % 3 == 0) {
  //     interstitialAd.load();
  //   }

  //   if (await interstitialAd.isLoaded) {
  //     interstitialAd.show();
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    // AppState appState = AppState.of(context);

    var recipesRef = FirebaseDatabase.instance.reference();

    // recipesRef.once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          '#${widget.label} recipes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: recipesRef.onValue,
                builder: (context, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()),
                        ],
                      ));
                    default:
                      print("SNAPSHOT: ${snap.data.snapshot.value}");
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
                          if (recipesList[i]["labels"].contains(widget.label))
                            filteredRecipes.add(recipesList[i]);
                        }
                        return GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            padding: const EdgeInsets.all(4.0),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            children: filteredRecipes.map<Widget>((document) {
                              Recipe recipe = _recipeBuilder(document);
                              // print(recipe.toString());
                              return GestureDetector(
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    fit: StackFit.loose,
                                    children: <Widget>[
                                      GridTile(
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
                                            color: GreyColor,
                                            constraints: BoxConstraints(
                                                maxHeight: 30, maxWidth: 30),
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
                                                  color: GreyColor,
                                                  constraints: BoxConstraints(
                                                      maxHeight: 30,
                                                      maxWidth: 30),
                                                  child: Icon(Icons.error)),
                                        ),
                                        footer: GridTileBar(
                                          backgroundColor:
                                              Color.fromRGBO(0, 0, 0, 0.3),
                                          title: Text(
                                            recipe.title,
                                          ),
                                          subtitle: Text(" ${recipe.time} min"),
                                        ),
                                      ),
                                      // FavoriteWidget(
                                      //     recipe: recipe, iconSize: 20)
                                    ],
                                  ),
                                  onTap: () async {
                                    // _showAd();
                                    showAd();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageActivity(
                                                recipe: recipe,
                                              )),
                                    );
                                  });
                            }).toList());
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                  }
                }),
          ),
          AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
          ),
        ],
      ),
    );
  }
}

// String getBannerAdUnitId() {
//   return apikeys["addMobBanner"];
// }

// AdmobInterstitial interstitialAd = AdmobInterstitial(
//   adUnitId: getInterstitialAdUnitId(),
// );

// getInterstitialAdUnitId() {
//   return apikeys["addMobInterstellar"];
// }

// int _counter = 0;
