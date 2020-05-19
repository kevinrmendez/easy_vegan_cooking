import 'dart:async';

import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/components/imageComponent.dart';
import 'package:easy_vegan_cooking/components/imageComponent2.dart';
import 'package:easy_vegan_cooking/components/imageComponentParallax.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Recipe.dart';
import '../components/AppDrawer.dart';

class RecipeOfDayActivity extends StatefulWidget {
  RecipeOfDayActivity({Key key}) : super(key: key);

  @override
  _RecipeOfDayActivityState createState() => _RecipeOfDayActivityState();
}

class _RecipeOfDayActivityState extends State<RecipeOfDayActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;
  var connectivityResult;
  var connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  _updateConnectionStatus(ConnectivityResult result) async {
    connectivityResult = await (Connectivity().checkConnectivity());

    // connectivityResult = await Connectivity().checkConnectivity();
    // print('Conectivity: ${connectivityResult == ConnectivityResult.mobile}');
    setState(() {
      connectivityResult = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  @override
  void initState() {
    initConnectivity();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("Connection Status has Changed");
      _updateConnectionStatus(result);
    });
    recipesRef = FirebaseDatabase.instance.reference();
    super.initState();
  }

  @override
  void dispose() {
    _recipesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Recipe of the Day'),
      ),
      body: Center(
        child: connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FirebaseAnimatedList(
                      query:
                          FirebaseDatabase.instance.reference().limitToLast(1),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Recipe recipe = Utils.recipeBuilder(snapshot.value);
                        return ImageComponent2(
                          // return ImageComponentParallax(
                          recipe: recipe,
                        );
                      },
                    ),
                  ),
                  // AdmobBanner(
                  //   adUnitId: getBannerAdUnitId(),
                  //   adSize: AdmobBannerSize.BANNER,
                  // ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  connectivityResult == null
                      ? CircularProgressIndicator()
                      : EmptyListTitle('No internet',
                          'Check your internet connection and try again :)'),
                ],
              ),
      ),
    );
  }
}
