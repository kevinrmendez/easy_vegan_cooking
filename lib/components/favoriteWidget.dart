import 'package:flutter/material.dart';

import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/bloc/favorite_bloc.dart';
import 'package:easy_vegan_cooking/main.dart';

class FavoriteWidget extends StatefulWidget {
  final Recipe recipe;
  final double iconSize;
  FavoriteWidget({this.recipe, this.iconSize = 10}) {}
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  int _isFavorited;

  void _toggleFavorite(context) async {
    if (_isFavorited == 1) {
      setState(() {
        widget.recipe.isFavorite = 0;
        _isFavorited = 0;
      });

      favoriteServices.remove(widget.recipe);
    } else {
      setState(() {
        widget.recipe.isFavorite = 1;
        _isFavorited = 1;
        widget.recipe.isFavorite = 1;
      });

      favoriteServices.add(widget.recipe);
    }

    var favorites = favoriteServices.currentList;
    favorites.forEach((element) {
      print(element.id);
      print(element.title);
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
              icon: (_isFavorited == 1
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
