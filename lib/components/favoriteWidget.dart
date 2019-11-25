import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/RecipeModel.dart';
import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void _toggleFavorite(context) {
    setState(() {
      if (_isFavorited) {
        widget.recipe.isFavorite = false;
        _isFavorited = false;
        Provider.of<RecipeModel>(context, listen: false).remove(widget.recipe);
      } else {
        widget.recipe.isFavorite = true;
        _isFavorited = true;
        Provider.of<RecipeModel>(context, listen: false).add(widget.recipe);
      }
    });
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
                      // color: Theme.of(context).accentColor,
                      color: RedColors,
                    )
                  : Icon(
                      Icons.favorite_border,
                      // color: Theme.of(context).accentColor,
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
