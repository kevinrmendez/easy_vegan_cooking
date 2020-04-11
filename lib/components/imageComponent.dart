import 'package:admob_flutter/admob_flutter.dart';
import 'package:easy_vegan_cooking/activity/CartActivity.dart';
import 'package:easy_vegan_cooking/activity/labelFilterActivity.dart';
import 'package:easy_vegan_cooking/components/StepWidget.dart';
import 'package:easy_vegan_cooking/components/ingredientList.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';
import 'package:flutter/material.dart';
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
import 'RecipesSuggestions.dart';

import './../helpers.dart';

class ImageComponent extends StatefulWidget {
  final Recipe recipe;
  ImageComponent({this.recipe});
  @override
  ImageComponentState createState() => ImageComponentState();
}

class ImageComponentState extends State<ImageComponent> {
  int index;
  List<Ingredient> ingredientList = List();

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
      var row = StepWidget(
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder(
            future: http.get(widget.recipe.image),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('no connection founded, please try again');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ));
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
                                  WidgetUtils.recipeTitle(
                                      text: widget.recipe.title),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AdmobBanner(
                              adUnitId: getBannerAdUnitId(),
                              adSize: AdmobBannerSize.BANNER,
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
                                      width: MediaQuery.of(context).size.width,
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
                            SubtitleWidget(
                              "You may also like",
                            ),
                            RecipesSuggestions(
                                labels: widget.recipe.labels,
                                currentRecipe: widget.recipe),
                            SizedBox(
                              height: 70,
                            )
                            // AdmobBanner(
                            //   adUnitId: getBannerAdUnitId(),
                            //   adSize: AdmobBannerSize.BANNER,
                            // ),
                          ],
                        ),
                      ));
              }
            },
          ),
        ],
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
