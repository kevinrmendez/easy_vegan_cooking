import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:easy_vegan_cooking/components/FoodPicture.dart';
import 'package:easy_vegan_cooking/components/SubtitleWidget.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:swipedetector/swipedetector.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'CartModel.dart';
import 'Ingredient.dart';
import 'Recipe.dart';
import 'apikeys.dart';
import 'appState.dart';

class ImageActivity extends StatefulWidget {
  final Recipe recipe;
  ImageActivity({this.recipe});
  @override
  ImageActivityState createState() => ImageActivityState();
}

class ImageActivityState extends State<ImageActivity> {
  bool downloading;
  int index;
  String progressString;
  List<Ingredient> ingredientList = List();

  void _showAd() async {
    _counter++;
    if (_counter % 4 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  List<Widget> labels(List<String> labels) {
    List<Widget> list = List();
    labels.forEach((labelText) {
      var label = new Label(
        text: labelText,
      );

      list.add(label);
    });
    return list;
  }

  List<Widget> steps(List<String> steps) {
    List<Widget> list = List();
    var stepNumber = 1;
    steps.forEach((step) {
      var row = Step(
        stepNumber: stepNumber,
        step: step,
      );
      list.add(row);
      stepNumber++;
    });
    return list;
  }

  @override
  void initState() {
    // index = data.indexOf(widget.recipe);
    downloading = false;
    // _saveImages = true;
    // index = _getNumber();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildLayout() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(
                    // A fixed-height child.
                    color: const Color(0xff808000), // Yellow
                    height: 120.0,
                  ),
                  Expanded(
                    // A flexible child that will grow to fit the viewport but
                    // still be at least as big as necessary to fit its contents.
                    child: Container(
                      color: const Color(0xff800000), // Red
                      height: 120.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = AppState.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: http.get(widget.recipe.image),
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('no connection founded, please try again');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Column(
                                  children: <Widget>[
                                    FoodPicture(recipe: widget.recipe),

                                    // Image.network(
                                    //   widget.recipe["image"],
                                    //   // fit: BoxFit.fitHeight,
                                    // ),

                                    Text(
                                      widget.recipe.title,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              _smallText(
                                                  'Cooks in ${widget.recipe.time} minutes'),
                                              _smallText(
                                                  'Serves ${widget.recipe.serves}'),
                                              _smallText(
                                                  'Difficulty ${widget.recipe.difficulty}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IngredientList(
                                ingredientData: widget.recipe.ingredients,
                              ),
                              Card(
                                child: Column(
                                  children: <Widget>[
                                    SubtitleWidget('Instructions'),
                                    Column(
                                      children: steps(widget.recipe.steps),
                                    ),
                                  ],
                                ),
                              ),
                              widget.recipe.instructions != null
                                  ? Card(
                                      child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: <Widget>[
                                          SubtitleWidget(
                                            'More information',
                                          ),
                                          Text(widget.recipe.instructions),
                                        ],
                                      ),
                                    ))
                                  : SizedBox(),
                              widget.recipe.nutrition != null
                                  ? Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: <Widget>[
                                            SubtitleWidget('Nutritional value'),
                                            Text(
                                                "Carbs: ${widget.recipe.nutrition["carbs"]}"),
                                            Text(
                                                "Fat: ${widget.recipe.nutrition["fat"]}"),
                                            Text(
                                                "Protein: ${widget.recipe.nutrition["protein"]}"),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Card(
                                child: Row(
                                  children: labels(widget.recipe.labels),
                                ),
                              )
                            ],
                          ),
                        ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(text),
    );
  }
}

class Label extends StatelessWidget {
  final String text;

  const Label({
    this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AccentColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }
}

class Step extends StatefulWidget {
  final String step;
  final int stepNumber;
  const Step({
    this.step,
    this.stepNumber,
    Key key,
  }) : super(key: key);

  @override
  _StepState createState() => _StepState();
}

class _StepState extends State<Step> {
  bool isChecked;
  @override
  void initState() {
    isChecked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Text(
              "${widget.stepNumber}",
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 30),
            ),
          ),
          Text(
            "${widget.step}",
          ),
          Opacity(
              opacity: isChecked ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.check),
              ))
        ],
      )),
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
    );
  }
}

class IngredientCheckbox extends StatefulWidget {
  final Ingredient ingredient;
  const IngredientCheckbox({
    this.ingredient,
    Key key,
  }) : super(key: key);

  @override
  _IngredientCheckboxState createState() => _IngredientCheckboxState();
}

class _IngredientCheckboxState extends State<IngredientCheckbox> {
  bool isChecked;

  @override
  void initState() {
    isChecked = widget.ingredient.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool value) {
        widget.ingredient.isChecked = value;
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}

class IngredientList extends StatefulWidget {
  final List ingredientData;
  const IngredientList({Key key, this.ingredientData}) : super(key: key);

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  List<Ingredient> ingredientList = [];
  bool isShoppingCartEmpty;
  List<Widget> ingredientsWidget(List<Ingredient> ingredients) {
    List<Widget> list = List();

    ingredientList.forEach((item) {
      var row = Row(
        children: <Widget>[
          // IngredientCheckbox(
          //   ingredient: item,
          // ),
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              setState(() {
                item.isChecked = value;
              });
            },
          ),
          Text(item.name)
        ],
      );
      list.add(row);
    });
    return list;
  }

  // bool isChecked;

  Container shoppingCartButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: PrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        color:
            // Theme.of(context).primaryColor,
            Colors.white,
        onPressed: () {
          ingredientList.forEach((ingredient) {
            if (ingredient.isChecked) {
              Provider.of<CartModel>(context, listen: false).add(ingredient);
              setState(() {
                ingredient.isChecked = false;
                isShoppingCartEmpty = false;
              });
            }
          });
          if (!isShoppingCartEmpty) {
            final snackBar = SnackBar(
              content: Text('ingredients added to shopping cart'),
              backgroundColor: AccentColor,
            );
            Scaffold.of(context).showSnackBar(snackBar);
            isShoppingCartEmpty = true;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    widget.ingredientData.forEach((item) {
      Ingredient ingredient = Ingredient(name: item, isChecked: false);
      ingredientList.add(ingredient);
    });
    isShoppingCartEmpty = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          SubtitleWidget(
            'Ingredients',
          ),
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Column(
                children: ingredientsWidget(ingredientList),
              ),
              shoppingCartButton(context)
            ],
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

AdmobReward rewardAd = AdmobReward(
  adUnitId: getRewardBasedVideoAdUnitId(),
);

getRewardBasedVideoAdUnitId() {
  return apikeys["adMobRewarded"];
}

int _counter = 0;
