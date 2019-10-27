import 'package:easy_vegan_cooking/categoryActivity.dart';
import 'package:easy_vegan_cooking/favoriteActivity.dart';
import 'package:easy_vegan_cooking/recentRecipes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CartActivity.dart';

class AppDrawer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          // color: Colors.indigo,
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
                      builder: (BuildContext context) => CategoryActivity()));
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
                  "Shopping Cart",
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
                  FontAwesomeIcons.plusCircle,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RecentRecipesActivity()));
                },
              ),
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
