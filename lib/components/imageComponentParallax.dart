import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

import 'package:url_launcher/url_launcher.dart';

import 'package:easy_vegan_cooking/components/SubtitleWidget.dart';
import 'package:easy_vegan_cooking/main.dart';

import '../CartModel.dart';
import '../Ingredient.dart';
import '../Recipe.dart';
import 'RecipesSuggestions.dart';

import './../helpers.dart';
import 'favoriteWidget.dart';
import 'package:share/share.dart';

void _shareRecipe(Recipe recipe) {
  Share.share("""
         Hi, 
         I would like to share you this delicious easy vegan recipe: ${recipe.title},
         you can read the full recipe from the app:
          https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking  
         """);
}

class ImageComponentParallax extends StatefulWidget {
  final Recipe recipe;
  ImageComponentParallax({this.recipe});
  @override
  ImageComponentParallaxState createState() => ImageComponentParallaxState();
}

class ImageComponentParallaxState extends State<ImageComponentParallax> {
  ScrollController _controller = ScrollController();

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
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .5,
            floating: true,
            pinned: true,
            leading: SizedBox(),
            backgroundColor: Color.fromRGBO(255, 255, 255, 0),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox(),
            ),
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: SizedBox(),
                // Container(
                //     padding: EdgeInsets.all(10),
                //     width: MediaQuery.of(context).size.width * .7,
                //     color: PrimaryColor,
                //     child: Text(
                //       widget.recipe.title,
                //       style: TextStyle(fontSize: 20),
                //       textAlign: TextAlign.center,
                //     )),
                // Container(
                //   // constraints: BoxConstraints(maxWidth: 200),
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     color: Color.fromRGBO(153, 204, 0, 0.5),
                //     child: Text(widget.recipe.title,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16.0,
                //             fontWeight: FontWeight.bold)),
                //   ),
                // ),
                background: FoodPictureParallax(
                  recipe: widget.recipe,
                )),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.BANNER,
            ),
            WidgetUtils.recipeTitle(
                text: widget.recipe.title, context: context),
            Container(
              margin: EdgeInsetsDirectional.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FavoriteWidget(recipe: widget.recipe, iconSize: 35.0),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      // color: Theme.of(context).accentColor,
                      color: RedColors,
                      size: 35,
                    ),
                    onPressed: () {
                      _shareRecipe(widget.recipe);
                      print('share');
                    },
                  ),
                ],
              ),
            ),
            Container(
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom: BorderSide(color: Colors.black, width: 2))),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _recipeDetail('Cooks in:',
                          ' ${widget.recipe.time} minutes', Icons.access_time),
                      _recipeDetail('Serves:', '${widget.recipe.serves}',
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
            IngredientList(
              ingredientData: widget.recipe.ingredients,
            ),
            Card(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Icon(FontAwesomeIcons.book),
                  SubtitleWidget("Instructions"),
                  Column(
                    children: steps(widget.recipe.steps),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            widget.recipe.suggestions != null && widget.recipe.suggestions != ""
                ? Card(
                    child: _contentMargin(children: [
                    Icon(FontAwesomeIcons.leaf),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children: <Widget>[
                            //   Text(
                            //       "Carbs: ${widget.recipe.nutrition["carbs"]}"),
                            //   Text(
                            //       "Fat: ${widget.recipe.nutrition["fat"]}"),
                            //   Text(
                            //       "Protein: ${widget.recipe.nutrition["protein"]}"),
                            // ],
                            children:
                                _buildNutritionInfo(widget.recipe.nutrition),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Card(
                child: _contentMargin(children: [
              Icon(
                FontAwesomeIcons.hashtag,
                color: Colors.black,
              ),
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
                labels: widget.recipe.labels, currentRecipe: widget.recipe),
            SizedBox(
              height: 70,
            )
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
            size: 13,
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

class FoodPictureParallax extends StatefulWidget {
  final Recipe recipe;
  FoodPictureParallax({this.recipe});
  @override
  _FoodPictureParallaxState createState() => _FoodPictureParallaxState();
}

class _FoodPictureParallaxState extends State<FoodPictureParallax> {
  @override
  void initState() {
    super.initState();
  }

  Widget _pictureAttribution() {
    return widget.recipe.attribution["name"] != null &&
            widget.recipe.attribution["name"] != ""
        ? Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'Picture taken by: ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String url = widget.recipe.attribution["url"];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white))),
                    child: Text(
                      widget.recipe.attribution["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    // AppState appState = AppState.of(context);
    return Stack(
      alignment: AlignmentDirectional.topStart,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .6,
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
            imageUrl: widget.recipe.image,
            placeholder: (context, url) => Container(
              width: MediaQuery.of(context).size.height,
              color: GreyColor,
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
                width: MediaQuery.of(context).size.width,
                color: GreyColor,
                child: Icon(
                  Icons.error,
                  size: 40,
                  // color: PrimaryColor,
                )),
          ),
        ),
        _pictureAttribution(),
      ],
    );
  }
}
