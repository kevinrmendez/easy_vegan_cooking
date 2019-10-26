import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/favoriteWidget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class FoodPicture extends StatefulWidget {
  final Recipe recipe;
  FoodPicture({this.recipe});
  @override
  _FoodPictureState createState() => _FoodPictureState();
}

class _FoodPictureState extends State<FoodPicture> {
  // bool _isFavorited;
  // void _toggleFavorite(context) {
  //   AppState appState = AppState.of(context);

  //   setState(() {
  //     if (_isFavorited) {
  //       widget.recipe.isFavorite = false;
  //       _isFavorited = false;
  //       appState.callback(recipe: widget.recipe);
  //     } else {
  //       widget.recipe.isFavorite = true;

  //       _isFavorited = true;
  //       appState.callback(recipe: widget.recipe);
  //     }
  //   });
  // }
  void _shareRecipe(Recipe recipe) {
    Share.share("""
         Hi, 
         I would like to share you this vegan recipe: ${recipe.title},
         cooking time: ${recipe.time} 
         ingredients: ${recipe.ingredients}, 
         steps:${recipe.steps}
         You can find more free recipes from https://kevinrmendez.com/
         
         """);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = AppState.of(context);
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.recipe.image), fit: BoxFit.cover)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Theme.of(context).accentColor,
                size: 35,
              ),
              onPressed: () {
                _shareRecipe(widget.recipe);
                print('share');
              },
            ),
            FavoriteWidget(recipe: widget.recipe),
          ],
        )
      ],
    );
  }
}

// class ShareWidget extends StatefulWidget {
//   final Recipe recipe;
//   ShareWidget({this.recipe});
//   @override
//   _ShareWidgetState createState() => _ShareWidgetState();
// }

// class _ShareWidgetState extends State<ShareWidget> {
//   bool _isFavorited;
//   void _toggleFavorite(context) {
//     AppState appState = AppState.of(context);

//     setState(() {
//       if (_isFavorited) {
//         widget.recipe.isFavorite = false;
//         _isFavorited = false;
//         appState.callback(recipe: widget.recipe);
//       } else {
//         widget.recipe.isFavorite = true;

//         _isFavorited = true;
//         appState.callback(recipe: widget.recipe);
//       }
//     });
//   }

//   @override
//   void initState() {
//     _isFavorited = widget.recipe.isFavorite;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: EdgeInsets.all(0),
//           child: IconButton(
//               iconSize: 45,
//               icon: (_isFavorited
//                   ? Icon(
//                       Icons.favorite,
//                       color: Theme.of(context).accentColor,
//                     )
//                   : Icon(
//                       Icons.favorite_border,
//                       color: Theme.of(context).accentColor,
//                     )),
//               color: Colors.red[500],
//               onPressed: () {
//                 _toggleFavorite(context);
//               }),
//         ),
//       ],
//     );
//   }
// }
