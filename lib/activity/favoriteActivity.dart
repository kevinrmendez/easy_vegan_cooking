import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:provider/provider.dart';

import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/components/MyGridTile.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

import '../Recipe.dart';
import '../RecipeModel.dart';
import '../apikeys.dart';

class FavoriteActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);

  @override
  _FavoriteActivityState createState() => _FavoriteActivityState();
}

class _FavoriteActivityState extends State<FavoriteActivity>
    with WidgetsBindingObserver {
  List<Recipe> recipes;
  var localDbrecipes;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      // recipes.forEach((item) {
      //   print(item);
      // });
      // var json = jsonEncode(recipes.map((e) => e.toJson()).toList());
      // print('JSON: $json');
      // storage.setItem('recipes', json);
      // storage.setItem('name', 'kevin');
    }
    if (state == AppLifecycleState.resumed) {
      // localDbrecipes = storage.getItem('recipes');
      // var name = storage.getItem('name');
      // print('NAME: $name');
      // print('LOCALDBRECIPES: $localDbrecipes');
      // print('RECIPES: $recipes');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    // var recipes = AppState.of(context).recipes;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: WidgetUtils.appBar(title: 'Favorite recipes'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Consumer<RecipeModel>(
            builder: (context, recipeModel, child) {
              recipes = recipeModel.recipes;
              return recipes.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 1.2,
                      padding: const EdgeInsets.all(4.0),
                      crossAxisSpacing: 4.0,
                      children: recipes.map((recipe) {
                        return Container(
                          child: MyGridTile(recipe: recipe),
                        );
                      }).toList())
                  : EmptyListTitle(
                      'Favorite', 'Add your favorite recipes here');
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
