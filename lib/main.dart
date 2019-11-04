import 'dart:typed_data';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';

import 'package:easy_vegan_cooking/components/appTItle.dart';
import 'package:easy_vegan_cooking/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
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

const PrimaryColor = const Color(0xFF99cc00);
// const AccentColor = const Color(0xFFeeb52d);
// const AccentColor = const Color(0xFFCE424D);
// // const AccentColor = const Color(0xFFD7D430);
// const AccentColor = const Color(0xFFC9CC00);
// const AccentColor = const Color(0xFFE2BE66);
const AccentColor = const Color(0xFFFF9900);
// const GreyColor = const Color(0xFFD0D0D0);
// const GreyColor = const Color(0xFFe6e6e6);
const GreyColor = const Color(0xFFEEEEEE);
FirebaseApp app;
var recipesData;
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

  @override
  void initState() {
    share = true;
    save = true;
    blackScreen = false;
    recipes = [];
    shoppingCart = [];
    WidgetsBinding.instance.addObserver(this);

    super.initState();
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

  void _showAd() async {
    _counter++;
    if (_counter % 4 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
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
              fontFamily: 'Montserrat',
              primaryColor: PrimaryColor,
              accentColor: AccentColor,
              primaryTextTheme:
                  TextTheme(title: TextStyle(color: Colors.white)),
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
            home: CategoryActivity(),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final _random = new Random();

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('setWallpaper');

  Dio dio = Dio();
  int index;
  String progressString;
  bool downloading;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _menuSelected(choice) {
      switch (choice) {
        case 'settings':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
          break;
      }
    }

    AppState appState = AppState.of(context);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          iconTheme: IconThemeData(color: Colors.white),
          title: appTitle('Cutest Cats'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onSelected: _menuSelected,
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return [
                  // PopupMenuItem(
                  //   value: 'donate',
                  //   child: Container(child: Text('Donate')),
                  // ),

                  PopupMenuItem(
                    value: 'settings',
                    child: Container(child: Text('Settings')),
                  ),
                ];
              },
            )
          ],
        ),
        body: Center(
          child: Text('main'),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    interstitialAdBeginning.load();
    Future.delayed(Duration(seconds: 5), () {
      interstitialAdBeginning.show();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryActivity(),
          ));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => CategoryActivity()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/screen.jpg'), fit: BoxFit.cover)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Easy Vegan Cooking',
                style: new TextStyle(fontSize: 35.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}

AdmobInterstitial interstitialAdBeginning = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

int _counter = 0;
