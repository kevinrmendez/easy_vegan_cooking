import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/components/imageComponentParallax.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';

import '../models/Recipe.dart';
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
            ? StreamBuilder(
                stream: recipesRef.onValue,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: 300,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()),
                          ],
                        )),
                      );
                    default:
                      // print("SNAPSHOT: ${snap.data.snapshot.value}");
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        DataSnapshot snapshot = snap.data.snapshot;
                        List recipesList = snapshot.value.toList();

                        recipesList = recipesList.reversed.toList();
                        Recipe recipe = Utils.recipeBuilder(recipesList[0]);
                        return ImageComponentParallax(recipe: recipe);
                      }
                  }
                },
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
