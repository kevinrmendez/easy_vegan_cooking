import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:swipedetector/swipedetector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:easy_vegan_cooking/components/FoodPicture.dart';
import 'package:easy_vegan_cooking/components/SubtitleWidget.dart';
import 'package:easy_vegan_cooking/main.dart';

import '../CartModel.dart';
import '../Ingredient.dart';
import '../Recipe.dart';
import '../apikeys.dart';
import 'CartActivity.dart';
import 'labelFilterActivity.dart';

class ImageActivity extends StatefulWidget {
  final Recipe recipe;
  ImageActivity({this.recipe});
  @override
  ImageActivityState createState() => ImageActivityState();
}

class ImageActivityState extends State<ImageActivity> {
  int index;
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

  List<Widget> labels(List labels) {
    List<Widget> list = List();
    labels.forEach((labelText) {
      var label = Label(
        text: labelText,
      );
      list.add(label);
    });
    return list;
  }

  List<Widget> steps(List steps) {
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

  Widget _contentMargin({List<Widget> children}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Column(children: children),
    );
  }

  List<Widget> _buildNutritionInfo(List data) {
    List<Widget> nutritionList = List();
    data.forEach((item) {
      var row = Row(
        children: <Widget>[
          Text(
            item["name"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(item["amount"].toString()),
        ],
      );
      nutritionList.add(row);
    });
    return nutritionList;
  }

  @override
  Widget build(BuildContext context) {
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

                                    Container(
                                      margin:
                                          EdgeInsetsDirectional.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                widget.recipe.title,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                              _recipeDetail(
                                                  'Cooks in:',
                                                  ' ${widget.recipe.time} minutes',
                                                  Icons.access_time),
                                              _recipeDetail(
                                                  'Serves:',
                                                  '${widget.recipe.serves}',
                                                  FontAwesomeIcons.utensils),
                                              _recipeDetail(
                                                  'Difficulty: ',
                                                  '${widget.recipe.difficulty}',
                                                  FontAwesomeIcons.brain),
                                              // _smallText(
                                              //     'Difficulty ${widget.recipe.difficulty}'),
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
                                    SubtitleWidget("Instructions"),
                                    Column(
                                      children: steps(widget.recipe.steps),
                                    ),
                                  ],
                                ),
                              ),
                              widget.recipe.suggestions != null &&
                                      widget.recipe.suggestions != ""
                                  ? Card(
                                      child: _contentMargin(children: [
                                      SubtitleWidget(
                                        "Chef's Suggestions",
                                      ),
                                      Text(widget.recipe.suggestions),
                                    ]))
                                  : SizedBox(),
                              widget.recipe.nutrition != null
                                  ? Card(
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            SubtitleWidget('Nutritional value'),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // children: <Widget>[
                                              //   Text(
                                              //       "Carbs: ${widget.recipe.nutrition["carbs"]}"),
                                              //   Text(
                                              //       "Fat: ${widget.recipe.nutrition["fat"]}"),
                                              //   Text(
                                              //       "Protein: ${widget.recipe.nutrition["protein"]}"),
                                              // ],
                                              children: _buildNutritionInfo(
                                                  widget.recipe.nutrition),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Card(
                                  child: _contentMargin(children: [
                                SubtitleWidget('Related tags'),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: labels(widget.recipe.labels),
                                ),
                              ])),
                              AdmobBanner(
                                adUnitId: getBannerAdUnitId(),
                                adSize: AdmobBannerSize.BANNER,
                              ),
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

  Widget _smallText(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(detail)
        ],
      ),
    );
  }

  Widget _recipeDetail(String title, String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 11,
          ),
          _smallText(title, text),
        ],
      ),
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
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
              color: AccentColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(8),
          child: Text(
            "#$text",
            style: TextStyle(color: Colors.white),
          )),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabelFilterActivity(
                      label: text,
                    )));

        print('tag printed');
      },
    );
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
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            ),
          ),
          Flexible(
            child: Container(
              child: Text(
                "${widget.step}",
              ),
            ),
          ),
          Opacity(
              opacity: isChecked ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: AccentColor,
                ),
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
      var row = Container(
          // margin: EdgeInsets.symmetric(vertical: 40),
          // color: Colors.red,
          height: 30,
          child: Row(
            children: <Widget>[
              Checkbox(
                value: item.isChecked,
                onChanged: (value) {
                  setState(() {
                    item.isChecked = value;
                  });
                },
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  child: Text(
                    item.name,
                    overflow: TextOverflow.visible,
                    // style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          ));
      list.add(row);
    });
    return list;
  }

  Container shoppingCartButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
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
              duration: Duration(seconds: 5),
              content: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartActivity()),
                    );
                  },
                  child: Text('ingredients added to shopping cart')),
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SubtitleWidget(
                        'Ingredients',
                      ),
                    ],
                  ),
                  Positioned(right: 0, child: shoppingCartButton(context)),
                ],
              ),
            ),
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ingredientsWidget(ingredientList),
                ),
              ],
            ),
          ],
        ),
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
