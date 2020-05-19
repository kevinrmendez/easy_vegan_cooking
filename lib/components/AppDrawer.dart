import 'dart:async';

import 'package:easy_vegan_cooking/activity/CartActivity.dart';
import 'package:easy_vegan_cooking/activity/HomeActivity.dart';
import 'package:easy_vegan_cooking/activity/RecentRecipesListActivity.dart';
import 'package:easy_vegan_cooking/activity/RecipeOfDayActivity.dart';
import 'package:easy_vegan_cooking/activity/TimerActivity.dart';
import 'package:easy_vegan_cooking/activity/categoryActivity.dart';
import 'package:easy_vegan_cooking/activity/favoriteActivity.dart';
import 'package:easy_vegan_cooking/activity/recentRecipes.dart';
import 'package:easy_vegan_cooking/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Recipe.dart';
import '../RecipeModel.dart';

class AppDrawer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          color: GreyColor,
          child: ListView(
            children: <Widget>[
              // UserAccountsDrawerHeader(
              //   accountName: Text('Bad Jokes'),
              //   currentAccountPicture: CircleAvatar(
              //     backgroundImage: AssetImage('assets/smile.png'),
              //   ),
              // ),
              // Container(
              //   height: 110,
              //   color: Colors.yellow[600],
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Container(height: 70, child: Image.asset('assets/smile.png')),
              //     ],
              //   ),
              // ),
              DrawerHeader(
                child: SizedBox(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/drawer-header.jpg'),
                      fit: BoxFit.cover),
                  // color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(
                  "Home",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => HomeActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "Favorite",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FavoriteActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "Groceries",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CartActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "New Recipes",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  FontAwesomeIcons.utensils,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RecentRecipesListActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "Recipe of the Day",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  FontAwesomeIcons.sun,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RecipeOfDayActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "Timer",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  FontAwesomeIcons.clock,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TimerActivity()));
                },
              ),
              // ListTile(
              //   title: Text(
              //     "Random Recipe",
              //     // style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   trailing: Icon(
              //     FontAwesomeIcons.plusCircle,
              //     color: Theme.of(context).accentColor,
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     // Navigator.of(context).push(MaterialPageRoute(
              //     //     builder: (BuildContext context) =>
              //     //         ImageActivity(recipe: ,))
              //     //         );
              //   },
              // ),

              // ListTile(
              //   title: Text(
              //     "Share App",
              //     style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   trailing: Icon(
              //     Icons.share,
              //     color: Theme.of(context).accentColor,
              //   ),
              //   onTap: () {
              //     String url =
              //         "https://play.google.com/store/apps/details?id=com.kevinrmendez.bad_jokes";
              //     print('sharing');
              //     Share.share(
              //         "Get the best bad jokes and have a great timefrom $url");
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     "Rate App",
              //     style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   trailing: Icon(
              //     Icons.rate_review,
              //     color: Theme.of(context).accentColor,
              //   ),
              //   onTap: () async {
              //     String url =
              //         "https://play.google.com/store/apps/details?id=com.kevinrmendez.bad_jokes";
              //     if (await canLaunch(url)) {
              //       await launch(url);
              //     } else {
              //       throw 'Could not launch $url';
              //     }
              //   },
              // ),

              // ListTile(
              //   title: Text(
              //     "Favorite Jokes",
              //     style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   trailing: Icon(
              //     Icons.star,
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (BuildContext context) => FavoriteJokes()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
