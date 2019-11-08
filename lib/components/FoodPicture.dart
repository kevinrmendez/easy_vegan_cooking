import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_vegan_cooking/Recipe.dart';
import 'package:easy_vegan_cooking/appState.dart';
import 'package:easy_vegan_cooking/components/favoriteWidget.dart';
import 'package:easy_vegan_cooking/main.dart';
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
    AppState appState = AppState.of(context);
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      fit: StackFit.loose,
      children: <Widget>[
        // Container(
        //   height: MediaQuery.of(context).size.height * .4,
        //   decoration: BoxDecoration(
        //       color: GreyColor,
        //       image: DecorationImage(
        //           image: NetworkImage(widget.recipe.image), fit: BoxFit.cover)),
        // ),
        Container(
          height: MediaQuery.of(context).size.height * .4,
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
              // constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
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
                color: Theme.of(context).accentColor,
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
