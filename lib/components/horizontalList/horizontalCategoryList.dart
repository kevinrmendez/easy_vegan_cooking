import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/activity/recipeActivity.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/components/MyGridTile.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

class HorizontalCategoryList extends StatefulWidget {
  final int listSize;
  final String category;
  HorizontalCategoryList({this.listSize, this.category});
  @override
  HorizontalCategoryListState createState() => HorizontalCategoryListState();
}

class HorizontalCategoryListState extends State<HorizontalCategoryList> {
  var recipesRef = FirebaseDatabase.instance.reference();

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FirebaseAnimatedList(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        query: widget.listSize == null
            ? FirebaseDatabase.instance.reference()
            : FirebaseDatabase.instance
                .reference()
                .orderByChild("id")
                .limitToLast(widget.listSize),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Recipe recipe = _recipeBuilder(snapshot.value);
          if (widget.category == null) {
            return MyGridTile2(
              recipe: recipe,
              // animation: animation,
            );
          } else {
            return recipe.category == widget.category
                ? MyGridTile2(
                    recipe: recipe,
                    // animation: animation,
                  )
                : SizedBox();
          }
        },
      ),
    );
  }
}

class MyGridTile2 extends StatelessWidget {
  final Recipe recipe;
  // final Animation animation;
  MyGridTile2({
    Key key,
    this.recipe,
    //  this.animation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _cardDetailText(text, fontWeight) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 3, 10, 0),
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16, fontWeight: fontWeight),
        ),
      );
    }

    return GestureDetector(
      child: Card(
        child: Stack(
            alignment: AlignmentDirectional.topEnd,
            fit: StackFit.loose,
            children: <Widget>[
              Container(
                width: 300,
                // width: 200,
                child: Card(
                  child: CachedNetworkImage(
                    // height: 300,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    imageUrl: recipe.image,
                    placeholder: (context, url) => Container(
                      height: 300,
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
                        height: 300,
                        color: GreyColor,
                        constraints:
                            BoxConstraints(maxHeight: 30, maxWidth: 30),
                        child: Icon(Icons.error)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: 300,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 7, 6, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        recipe.title,
                        style: TextStyle(
                            // color: Colors.white
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Text(" ${recipe.time} min",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              // color: Colors.white
                              fontSize: 16,
                              color: Colors.black))
                    ],
                  ),
                ),
              )
            ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeActivity(
                      recipe: recipe,
                    )));
      },
    );
  }
}
