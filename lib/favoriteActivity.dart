import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/imageActivity.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';

import 'Recipe.dart';
import 'RecipeModel.dart';
import 'apikeys.dart';
import 'components/AppDrawer.dart';
import 'data.dart';

import 'gridActivity.dart';

class FavoriteActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);

  @override
  _FavoriteActivityState createState() => _FavoriteActivityState();
}

class _FavoriteActivityState extends State<FavoriteActivity> {
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    // var recipes = AppState.of(context).recipes;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Favorite vegan recipes'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Consumer<RecipeModel>(
            builder: (context, recipeModel, child) {
              List<Recipe> recipes = recipeModel.recipes;
              return recipes.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: recipes.map((recipe) {
                        return GestureDetector(
                            child: GridTile(
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                ),
                                imageUrl: recipe.image,
                                placeholder: (context, url) => Container(
                                  constraints: BoxConstraints(
                                      maxHeight: 30, maxWidth: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    new Icon(Icons.error),
                              ),
                              footer: GridTileBar(
                                title: Text(recipe.title),
                              ),
                            ),
                            onTap: () async {
                              // String url = recipe["image"];
                              // print('URL');
                              // print(url);
                              _showAd();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageActivity(
                                          recipe: recipe,
                                        )),
                              );
                            });
                      }).toList())
                  : EmptyListTitle('Your favorite recipe list is empty');
            },
          )),
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
