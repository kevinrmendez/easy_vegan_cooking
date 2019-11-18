import 'dart:async';

import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
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

import 'categoryActivity.dart';
import 'imageActivity.dart';
import '../helpers.dart';

class GridActivity extends StatefulWidget {
  final String category;
  GridActivity({Key key, this.category}) : super(key: key);

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
  _GridActivityState createState() => _GridActivityState();
}

class _GridActivityState extends State<GridActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;

  // bool isDatabaseNotEmpty;

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
    recipesRef = FirebaseDatabase.instance.reference();
    // recipesRef.once().then((snapshot) {
    //   if (snapshot.value != null) {
    //     isDatabaseNotEmpty = true;
    //   } else {
    //     isDatabaseNotEmpty = false;
    //   }
    // });

    _recipesSubscription = recipesRef.onChildAdded.listen((event) {
      // print('Child added: ${event.snapshot.value}');
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

  Widget _cardDetailText(text, fontWeight) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: TextStyle(
              // color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 18,
              fontWeight: fontWeight),
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
        title: Text('${widget.category}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance.reference(),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Recipe recipe = _recipeBuilder(snapshot.value);
                return recipe.category == widget.category
                    ? SizeTransition(
                        sizeFactor: animation,
                        // child: GridTile(child: Text(snapshot.value["title"])),
                        child: Container(
                          // decoration: ,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: MediaQuery.of(context).size.height * .4,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              showAd();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageActivity(
                                          recipe: recipe,
                                        )),
                              );
                            },
                            child:
                                // Stack(
                                //     alignment: AlignmentDirectional.bottomEnd,
                                //     fit: StackFit.loose,
                                //     children: <Widget>[
                                //       CachedNetworkImage(
                                //         imageBuilder: (context, imageProvider) =>
                                //             Container(
                                //           decoration: BoxDecoration(
                                //               image: DecorationImage(
                                //                   image: imageProvider,
                                //                   fit: BoxFit.cover)),
                                //         ),
                                //         imageUrl: recipe.image,
                                //         placeholder: (context, url) => Container(
                                //           width: MediaQuery.of(context).size.width,
                                //           color: GreyColor,
                                //           // constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                                //           child: Column(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: <Widget>[
                                //               SizedBox(
                                //                   height: 40,
                                //                   width: 40,
                                //                   child:
                                //                       new CircularProgressIndicator()),
                                //             ],
                                //           ),
                                //         ),
                                //         errorWidget: (context, url, error) =>
                                //             Container(
                                //                 height: MediaQuery.of(context)
                                //                     .size
                                //                     .height,
                                //                 width: MediaQuery.of(context)
                                //                     .size
                                //                     .width,
                                //                 color: GreyColor,
                                //                 child: Icon(
                                //                   Icons.error,
                                //                   size: 40,
                                //                   // color: PrimaryColor,
                                //                 )),
                                //       ),
                                //       Container(
                                //         margin: EdgeInsets.all(10),
                                //         child: Column(
                                //           mainAxisAlignment: MainAxisAlignment.end,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.end,
                                //           children: <Widget>[
                                //             _cardDetailText(recipe.title),
                                //             _cardDetailText("${recipe.time} min")
                                //           ],
                                //         ),
                                //       )
                                //     ]),

                                Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .31,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover)),
                                      ),
                                      imageUrl: recipe.image,
                                      placeholder: (context, url) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .7,
                                        color: GreyColor,
                                        // constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: GreyColor,
                                              child: Icon(
                                                Icons.error,
                                                size: 40,
                                                // color: PrimaryColor,
                                              )),
                                    ),
                                    _cardDetailText(
                                        recipe.title, FontWeight.bold),
                                    _cardDetailText(
                                        "${recipe.time} min", FontWeight.normal)
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Card(
                          //     child: Column(
                          //   children: <Widget>[
                          //     Image.network(snapshot.value["image"]),
                          //     Text(snapshot.value["title"])
                          //   ],
                          // )),
                        ),
                      )
                    : SizedBox();
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
