import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/activity/recipeActivity.dart';
import 'package:easy_vegan_cooking/activity/searchFilterActivity.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/components/MyGridTile.dart';
import 'package:easy_vegan_cooking/components/categoryComponent.dart';

import 'package:easy_vegan_cooking/components/horizontalList/horizontalCategory.dart';
import 'package:easy_vegan_cooking/components/horizontalList/horizontalNewRecipes.dart';
import 'package:easy_vegan_cooking/components/horizontalList/horizontalNewRecipesList.dart';
import 'package:easy_vegan_cooking/components/horizontalList/horizontalRecipeDay.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeActivity extends StatefulWidget {
  final int listSize = 10;
  final String category = "ensaladas";
  @override
  HomeActivityState createState() => HomeActivityState();
}

class HomeActivityState extends State<HomeActivity> {
  Icon _searchIcon = new Icon(Icons.search);

  var recipesRef = FirebaseDatabase.instance.reference();
  Widget _appBarTitle = new Text(
    'Easy Vegan Cooking',
    style: TextStyle(fontWeight: FontWeight.bold),
  );
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";

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
        attribution: data["attribution"],
        isFavorite: false);
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              '¿Do you want to close the app?',
              style: TextStyle(color: PrimaryColor),
            ),
            content: new Text('Before closing the app, share us your feedback'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: AccentColor),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  // Navigator.of(context).pop(false);
                  String url =
                      "https://play.google.com/store/apps/details?id=com.kevinrmendez.veganisimo";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'We could not open $url';
                  }
                },
                child: new Text(
                  'Review app',
                  style: TextStyle(color: AccentColor),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: AccentColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildAppBarTitle() {
    return Container(
      // width: 200,
      // color: Colors.red,
      child: Row(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * .6,
              child: _appBarTitle),
          Container(
            // width: 200,
            child: IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = TextField(
          style: TextStyle(color: Colors.white, fontSize: 19),
          controller: _filter,
          decoration: InputDecoration(
            fillColor: Colors.white,
            // prefixIcon: Icon(
            //   Icons.search,
            //   color: Colors.white,
            // ),
            hintText: 'Busca receta',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            // border: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.white))
          ),
          onEditingComplete: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchFilterActivity(
                        searchTerm: _filter.text,
                      )),
            );
          },
        );
      } else {
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.white,
        );
        this._appBarTitle = new Text('Easy Vegan Cooking',
            style: TextStyle(fontWeight: FontWeight.bold));
        // filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(centerTitle: true, title: _buildAppBarTitle()
        // leading: Container(
        //   child: new IconButton(
        //     icon: _searchIcon,
        //     onPressed: _searchPressed,
        //   ),
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildBar(context),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                HorizontalRecipeDay(),
                WidgetUtils.boldTitle("Categories"),
                CategoryComponent(),
                HorizontalNewRecipes(),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
