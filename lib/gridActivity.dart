import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'Recipe.dart';
import 'apikeys.dart';
import 'components/AppDrawer.dart';
import 'data.dart';

import 'imageActivity.dart';

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

  List<Recipe> _dataConverter(data) {
    List<Recipe> recipeList = [];
    data.forEach((data) {
      Recipe recipe = Recipe(
          image: data["image"],
          title: data["title"],
          category: data["category"],
          difficulty: data["difficulty"],
          instructions: data["instructions"],
          time: data["time"],
          serves: data["serves"],
          ingredients: data["ingredients"],
          steps: data["steps"],
          labels: data["labels"],
          nutrition: data["nutrition"],
          isFavorite: false);
      recipeList.add(recipe);
    });

    return recipeList;
  }

  @override
  Widget build(BuildContext context) {
    var filteredData =
        data.where((recipe) => recipe["category"] == widget.category);
    var recipes = _dataConverter(filteredData);
    recipes.forEach((recipe) {
      print("RECIPES");
      print(recipe.toString());
    });
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Vegan recipes for ${widget.category}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: recipes.map((recipe) {
                  return GestureDetector(
                      child: GridTile(
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                          imageUrl: recipe.image,
                          placeholder: (context, url) => Container(
                            constraints:
                                BoxConstraints(maxHeight: 30, maxWidth: 30),
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
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                        footer: GridTileBar(
                          title: Text(recipe.title),
                          subtitle: Text(" ${recipe.time} min"),
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
                }).toList()),
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
