import 'dart:typed_data';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:easy_vegan_cooking/gridActivity.dart';
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

import 'package:path_provider/path_provider.dart';
import 'CartModel.dart';
import 'Ingredient.dart';
import 'Recipe.dart';
import 'RecipeModel.dart';
import 'appState.dart';
import 'categoryActivity.dart';
import 'data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

const PrimaryColor = const Color(0xFF99cc00);
const AccentColor = const Color(0xFFeeb52d);
FirebaseApp app;
void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Admob.initialize(getAppId());

  runApp(MyApp());
}

String getAppId() {
  return "ca-app-pub-7306861253247220~4569332025";
}

Map<PermissionGroup, PermissionStatus> _permissions;
PermissionStatus _permissionStatus;
Future<PermissionStatus> _checkPermission() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  return permission;
}

Future<Map<PermissionGroup, PermissionStatus>> _requestPermission() async {
  // await PermissionHandler()
  //     .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
  // await PermissionHandler().openAppSettings();

  _permissionStatus = await _checkPermission();
  if (_permissionStatus != PermissionStatus.granted) {
    return await PermissionHandler()
        .requestPermissions([PermissionGroup.storage]);
  }
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            theme: ThemeData(
              primaryColor: PrimaryColor,
              accentColor: AccentColor,
              primaryTextTheme:
                  TextTheme(title: TextStyle(color: Colors.white)),
              primarySwatch: Colors.blueGrey,
            ),
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
    downloading = false;
    index = _getNumber();
    super.initState();
  }

  int _getNumber() {
    return widget._random.nextInt(data.length);
  }

  void _changeIndex() {
    setState(() {
      index = _getNumber();
    });
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
