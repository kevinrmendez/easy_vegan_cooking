import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:easy_vegan_cooking/activity/recipeActivity.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';

import '../Recipe.dart';
import '../components/AppDrawer.dart';
import '../helpers.dart';

class LabelFilterActivity extends StatefulWidget {
  final String label;
  LabelFilterActivity({Key key, this.label}) : super(key: key);

  @override
  _LabelFilterActivityState createState() => _LabelFilterActivityState();
}

class _LabelFilterActivityState extends State<LabelFilterActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                              Recipe recipe = Utils.recipeBuilder(document);
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
                                          builder: (context) => RecipeActivity(
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
