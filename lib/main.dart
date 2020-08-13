import 'dart:io';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easy_vegan_cooking/activity/HomeActivity.dart';
import 'package:easy_vegan_cooking/favoritesDb.dart';

import 'CartModel.dart';
import 'models/Ingredient.dart';
import 'models/Recipe.dart';
import 'RecipeModel.dart';
import 'appState.dart';
import 'apikeys.dart';

const PrimaryColor = const Color(0xFFB4CE2F);
const AccentColor = const Color(0xFFFF9900);
const GreyColor = const Color(0xFFEEEEEE);
const RedColors = const Color(0xFFff6961);
FirebaseApp app;
var recipesData;

String dbPath;
Directory directory;
SharedPreferences prefs;

FavoritesDb db = FavoritesDb();

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Admob.initialize(getAppId());

  runApp(MyApp());
}

String getAppId() {
  return apikeys["appId"];
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool share;
  bool save;
  bool blackScreen;
  List recipes;
  List shoppingCart;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    _firebaseMessaging.getToken().then((token) {
      print(" TOKEN : $token");
    });
  }

  @override
  void initState() {
    super.initState();
    share = true;
    save = true;
    blackScreen = false;
    recipes = [];
    shoppingCart = [];
    WidgetsBinding.instance.addObserver(this);
    firebaseCloudMessagingListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // _showAd();
    print('state = $state');
  }

  _callback(
      {share,
      save,
      blackScreen,
      Recipe recipe,
      Ingredient ingredient,
      shoppingItem}) {
    setState(() {
      if (share != null) {
        this.share = share;
      } else if (shoppingItem != null) {
        this.shoppingCart.removeAt(shoppingCart.indexOf(shoppingItem));
      } else if (ingredient != null) {
        this.shoppingCart.add(ingredient.name);
      } else if (recipe != null) {
        if (recipe.isFavorite) {
          this.recipes.add(recipe);
        } else {
          this.recipes.removeAt(recipes.indexOf(recipe));
        }
      } else {
        this.blackScreen = blackScreen;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return AppState(
        share: this.share,
        callback: _callback,
        blackScreen: blackScreen,
        save: this.save,
        recipes: this.recipes,
        shoppingCart: this.shoppingCart,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (context) => RecipeModel(),
            ),
            ChangeNotifierProvider(
              builder: (context) => CartModel(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Easy Vegan Cooking',
            theme: ThemeData(
              textTheme: TextTheme(
                  body1: TextStyle(
                fontSize: 18,
                //  height: 1.13
              )),
              // fontFamily: 'Montserrat',
              // fontFamily: 'JosefinSans',
              fontFamily: 'Lato',
              primaryColor: PrimaryColor,
              accentColor: AccentColor,
              primaryTextTheme: TextTheme(
                  title: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
              primarySwatch: Colors.blueGrey,
            ),
            home: HomeActivity(),
          ),
        ));
  }
}
