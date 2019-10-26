import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/appState.dart';
import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  final Recipe recipe;
  FavoriteWidget({this.recipe});
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited;
  void _toggleFavorite(context) {
    AppState appState = AppState.of(context);

    setState(() {
      if (_isFavorited) {
        widget.recipe.isFavorite = false;
        _isFavorited = false;
        appState.callback(recipe: widget.recipe);
      } else {
        widget.recipe.isFavorite = true;

        _isFavorited = true;
        appState.callback(recipe: widget.recipe);
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
              iconSize: 45,
              icon: (_isFavorited
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).accentColor,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).accentColor,
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
