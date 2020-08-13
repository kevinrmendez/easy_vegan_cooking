import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/RecipeModel.dart';

import 'package:easy_vegan_cooking/main.dart';

class FavoriteWidget extends StatefulWidget {
  final Recipe recipe;
  final double iconSize;
  FavoriteWidget({this.recipe, this.iconSize = 10}) {
    // _saveData(recipe) async {
    //   var store = intMapStoreFactory.store('recipes');

    //   await store.add(db, recipe);
    //   var dbRecipe = await store.count(db);
    //   print('DBRECIPES $dbRecipe');
    // }
    // _saveData(recipe.toMap());
  }
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited;

  void _toggleFavorite(context) async {
    if (_isFavorited) {
      setState(() {
        widget.recipe.isFavorite = false;
        _isFavorited = false;
        Provider.of<RecipeModel>(context, listen: false).remove(widget.recipe);
      });
      // db.deleteFavorite(widget.recipe);
      // var favorites = await db.favorites();
      // favorites.forEach((f) => print(f.title));
    } else {
      setState(() {
        widget.recipe.isFavorite = true;
        _isFavorited = true;
        Provider.of<RecipeModel>(context, listen: false).add(widget.recipe);
      });
      // db.insertFavorite(widget.recipe);
      // var favorites = await db.favorites();

      // favorites.forEach((f) => print(f.title));
    }
  }

  @override
  void initState() {
    _isFavorited = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
              iconSize: widget.iconSize,
              icon: (_isFavorited
                  ? Icon(
                      Icons.favorite,
                      color: RedColors,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: RedColors,
                    )),
              color: Colors.red[500],
              onPressed: () {
                _toggleFavorite(context);
              }),
        ),
      ],
    );
  }
}
