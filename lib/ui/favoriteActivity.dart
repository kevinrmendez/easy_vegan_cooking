import 'package:easy_vegan_cooking/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:provider/provider.dart';

import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/components/MyGridTile.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

import '../models/Recipe.dart';
import '../RecipeModel.dart';
import '../apikeys.dart';

class FavoriteActivity extends StatefulWidget {
  // GridActivity({Key key, this.title}) : super(key: key);

  @override
  _FavoriteActivityState createState() => _FavoriteActivityState();
}

class _FavoriteActivityState extends State<FavoriteActivity> {
  List<Recipe> recipes;
  var localDbrecipes;

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
    return Scaffold(
        drawer: AppDrawer(),
        appBar: WidgetUtils.appBar(title: 'Favorite recipes'),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Recipe>>(
                stream: favoriteServices.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  }
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: EmptyListTitle(
                          'Favorite', 'Add your favorite recipes here'),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: favoriteServices.currentList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          Recipe recipeItem = snapshot.data[index];
                          // recipes = snapshot.data;

                          return Container(
                            child: MyGridTile(recipe: recipeItem),
                          );
                        });
                  }
                },
              ),
            ),
            AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.BANNER,
            ),
          ],
        )
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Expanded(child: Consumer<RecipeModel>(
        //       builder: (context, recipeModel, child) {
        //         recipes = recipeModel.recipes;
        //         return recipes.isNotEmpty
        //             ? GridView.count(
        //                 crossAxisCount: 1,
        //                 childAspectRatio: 1.2,
        //                 padding: const EdgeInsets.all(4.0),
        //                 crossAxisSpacing: 4.0,
        //                 children: recipes.map((recipe) {
        //                   return Container(
        //                     child: MyGridTile(recipe: recipe),
        //                   );
        //                 }).toList())
        //             : EmptyListTitle(
        //                 'Favorite', 'Add your favorite recipes here');
        //       },
        //     )),
        //     AdmobBanner(
        //       adUnitId: getBannerAdUnitId(),
        //       adSize: AdmobBannerSize.BANNER,
        //     ),
        //   ],
        // ),
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
