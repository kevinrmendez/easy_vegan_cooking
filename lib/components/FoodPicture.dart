import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/components/favoriteWidget.dart';
import 'package:easy_vegan_cooking/main.dart';

class FoodPicture extends StatefulWidget {
  final Recipe recipe;
  FoodPicture({this.recipe});
  @override
  _FoodPictureState createState() => _FoodPictureState();
}

class _FoodPictureState extends State<FoodPicture> {
  void _shareRecipe(Recipe recipe) {
    Share.share("""
         Hi, 
         I would like to share you this delicious easy vegan recipe: ${recipe.title},
         you can read the full recipe from the app:
          https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking  
         """);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .5,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
            FavoriteWidget(
              recipe: widget.recipe,
              iconSize: 45,
            ),
          ],
        ),
      ],
    );
  }
}
