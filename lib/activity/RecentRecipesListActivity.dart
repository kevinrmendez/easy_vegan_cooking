import 'dart:async';

import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/favoriteWidget.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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

class RecentRecipesListActivity extends StatefulWidget {
  RecentRecipesListActivity({Key key}) : super(key: key);

  @override
  _RecentRecipesListActivityState createState() =>
      _RecentRecipesListActivityState();
}

class _RecentRecipesListActivityState extends State<RecentRecipesListActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;
  void _showAd() async {
    _counter++;
    if (_counter % 3 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  @override
  void initState() {
    recipesRef = FirebaseDatabase.instance.reference();

    _recipesSubscription = recipesRef.onChildAdded.listen((event) {
      print('Child added: ${event.snapshot.value}');
    });
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

  Widget _cardDetailText(text) {
    return Flexible(
      child: Container(
        width: MediaQuery.of(context).size.width * .6,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppState appState = AppState.of(context);

    // recipesRef.once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('New vegan recipes'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.reference().limitToLast(14),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Recipe recipe = _recipeBuilder(snapshot.value);

                return SizeTransition(
                  sizeFactor: animation,
                  // child: GridTile(child: Text(snapshot.value["title"])),
                  child: Container(
                    // decoration: ,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: MediaQuery.of(context).size.height * .4,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        _showAd();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageActivity(
                                    recipe: recipe,
                                  )),
                        );
                      },
                      child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          fit: StackFit.loose,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              imageUrl: recipe.image,
                              placeholder: (context, url) => Container(
                                width: MediaQuery.of(context).size.width,
                                color: GreyColor,
                                // constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: new CircularProgressIndicator()),
                                  ],
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: GreyColor,
                                  child: Icon(
                                    Icons.error,
                                    size: 40,
                                    // color: PrimaryColor,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  _cardDetailText(recipe.title),
                                  _cardDetailText("${recipe.time} min")
                                ],
                              ),
                            )
                          ]),
                    ),
                    // Card(
                    //     child: Column(
                    //   children: <Widget>[
                    //     Image.network(snapshot.value["image"]),
                    //     Text(snapshot.value["title"])
                    //   ],
                    // )),
                  ),
                );
              },
            ),
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

String getBannerAdUnitId() {
  return apikeys["addMobBanner"];
}

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

int _counter = 0;
