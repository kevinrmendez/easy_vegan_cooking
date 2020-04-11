import 'package:easy_vegan_cooking/activity/imageActivity.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_database/firebase_database.dart';

import '../Recipe.dart';
import '../components/AppDrawer.dart';

import '../helpers.dart';

class MyGridTile extends StatelessWidget {
  final Recipe recipe;
  final Animation animation;
  MyGridTile({Key key, this.recipe, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _cardDetailText(text, fontWeight) {
      return Flexible(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
                // color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 18,
                fontWeight: fontWeight),
          ),
        ),
      );
    }

    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        // decoration: ,
        margin: EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            showAd();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageActivity(
                        recipe: recipe,
                      )),
            );
          },
          child:
              // Stack(
              //     alignment: AlignmentDirectional.bottomEnd,
              //     fit: StackFit.loose,
              //     children: <Widget>[
              //       CachedNetworkImage(
              //         imageBuilder: (context, imageProvider) =>
              //             Container(
              //           decoration: BoxDecoration(
              //               image: DecorationImage(
              //                   image: imageProvider,
              //                   fit: BoxFit.cover)),
              //         ),
              //         imageUrl: recipe.image,
              //         placeholder: (context, url) => Container(
              //           width: MediaQuery.of(context).size.width,
              //           color: GreyColor,
              //           // constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
              //           child: Column(
              //             mainAxisAlignment:
              //                 MainAxisAlignment.center,
              //             children: <Widget>[
              //               SizedBox(
              //                   height: 40,
              //                   width: 40,
              //                   child:
              //                       new CircularProgressIndicator()),
              //             ],
              //           ),
              //         ),
              //         errorWidget: (context, url, error) =>
              //             Container(
              //                 height: MediaQuery.of(context)
              //                     .size
              //                     .height,
              //                 width: MediaQuery.of(context)
              //                     .size
              //                     .width,
              //                 color: GreyColor,
              //                 child: Icon(
              //                   Icons.error,
              //                   size: 40,
              //                   // color: PrimaryColor,
              //                 )),
              //       ),
              //       Container(
              //         margin: EdgeInsets.all(10),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           crossAxisAlignment:
              //               CrossAxisAlignment.end,
              //           children: <Widget>[
              //             _cardDetailText(recipe.title),
              //             _cardDetailText("${recipe.time} min")
              //           ],
              //         ),
              //       )
              //     ]),

              Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height * .31,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    imageUrl: recipe.image,
                    placeholder: (context, url) => Container(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.width,
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
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: GreyColor,
                        child: Icon(
                          Icons.error,
                          size: 40,
                          // color: PrimaryColor,
                        )),
                  ),
                  _cardDetailText(recipe.title, FontWeight.bold),
                  _cardDetailText("${recipe.time} min", FontWeight.normal)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
