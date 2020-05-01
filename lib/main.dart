import 'dart:typed_data';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';
import 'package:easy_vegan_cooking/activity/HomeActivity.dart';
import 'package:easy_vegan_cooking/activity/RecipeOfDayActivity.dart';

import 'package:easy_vegan_cooking/components/appTItle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'CartModel.dart';
import 'Ingredient.dart';
import 'Recipe.dart';
import 'RecipeModel.dart';
import 'activity/categoryActivity.dart';
import 'apikeys.dart';
import 'appState.dart';
import 'app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// const PrimaryColor = const Color(0xFFa8e000);
// const PrimaryColor = const Color(0xFF99cc00);
// const PrimaryColor = const Color(0xFFB2DB2B);
// const PrimaryColor = const Color(0xFFA8CE2D);
const PrimaryColor = const Color(0xFFB4CE2F);
const AccentColor = const Color(0xFFFF9900);
const GreyColor = const Color(0xFFEEEEEE);
const RedColors = const Color(0xFFff6961);
FirebaseApp app;
var recipesData;

String dbPath;
Directory directory;
SharedPreferences prefs;

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Admob.initialize(getAppId());

  runApp(MyApp());
}

String getAppId() {
  return "ca-app-pub-7306861253247220~4569332025";
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
            title: 'Flutter Demo',
            // initialRoute: '/',
            // routes: {
            //   // When navigating to the "/" route, build the FirstScreen widget.
            //   '/Category': (context) => CategoryActivity(),
            //   // When navigating to the "/second" route, build the SecondScreen widget.
            // },
            theme: ThemeData(
              textTheme: TextTheme(
                  body1: TextStyle(
                fontSize: 18,
                //  height: 1.13
              )),
              // fontFamily: 'Montserrat',
              fontFamily: 'JosefinSans',
              primaryColor: PrimaryColor,
              accentColor: AccentColor,
              primaryTextTheme: TextTheme(
                  title: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
              primarySwatch: Colors.blueGrey,
            ),
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('es', 'MX'),
            ],
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
            // home: SplashScreen(),
            home: HomeActivity(),
          ),
        ));
  }
}

// AdmobInterstitial interstitialAdBeginning = AdmobInterstitial(
//   adUnitId: getInterstitialAdUnitId(),
// );

// getInterstitialAdUnitId() {
//   return apikeys["addMobInterstellar"];
// }

// int _counter = 0;
