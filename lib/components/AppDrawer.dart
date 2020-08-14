import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:easy_vegan_cooking/ui/AboutActivity.dart';
import 'package:easy_vegan_cooking/ui/CartActivity.dart';
import 'package:easy_vegan_cooking/ui/HomeActivity.dart';
import 'package:easy_vegan_cooking/ui/RecentRecipesListActivity.dart';
import 'package:easy_vegan_cooking/ui/RecipeOfDayActivity.dart';
import 'package:easy_vegan_cooking/ui/TimerActivity.dart';
import 'package:easy_vegan_cooking/ui/favoriteActivity.dart';
import 'package:easy_vegan_cooking/main.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          color: GreyColor,
          child: ListView(
            children: <Widget>[
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
              ListTile(
                title: Text(
                  "Remove ads",
                ),
                trailing: Icon(
                  FontAwesomeIcons.minusCircle,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  String url =
                      "https://play.google.com/store/apps/details?id=com.easy.vegan.cooking.pro";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                title: Text(
                  "About",
                ),
                trailing: Icon(
                  Icons.info,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutActivity()));
                },
              ),
              ListTile(
                title: Text(
                  "Share App",
                ),
                trailing: Icon(
                  Icons.share,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  String url =
                      "https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking";

                  Share.share("Get the best and easy vegan recipes: $url");
                },
              ),
              ListTile(
                title: Text(
                  "Rate App",
                ),
                trailing: Icon(
                  Icons.rate_review,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  String url =
                      "https://play.google.com/store/apps/details?id=com.kevinrmendez.easy.vegan.cooking";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
