import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/activity/recipeActivity.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';

class HorizontalCategoryList extends StatefulWidget {
  final int listSize;
  final String category;
  HorizontalCategoryList({this.listSize, this.category});
  @override
  HorizontalCategoryListState createState() => HorizontalCategoryListState();
}

class HorizontalCategoryListState extends State<HorizontalCategoryList> {
  var recipesRef = FirebaseDatabase.instance.reference();

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
          Recipe recipe = Utils.recipeBuilder(snapshot.value);
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
