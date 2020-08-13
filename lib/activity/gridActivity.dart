import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:easy_vegan_cooking/components/GridListComponent.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../Recipe.dart';
import '../components/AppDrawer.dart';

class GridActivity extends StatefulWidget {
  final String category;
  GridActivity({Key key, this.category}) : super(key: key);

  @override
  _GridActivityState createState() => _GridActivityState();
}

class _GridActivityState extends State<GridActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;
  var connectivityResult;
  var connectivitySubscription;
  List<Recipe> recipeList = [];

  _checkConnectivity(ConnectivityResult result) async {
    // connectivityResult = await Connectivity().checkConnectivity();
    // print('Conectivity: ${connectivityResult == ConnectivityResult.mobile}');
    setState(() {
      connectivityResult = result;
    });
  }

  @override
  void initState() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("Connection Status has Changed");
      _checkConnectivity(result);
    });
    recipesRef = FirebaseDatabase.instance.reference();
    recipesRef.once().then((onValue) {
      print(onValue);
    });

    _recipesSubscription = recipesRef.onChildAdded.listen((event) {
      // print('Child added: ${event.snapshot.value}');
    });
    super.initState();
  }

  @override
  void dispose() {
    _recipesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AppState appState = AppState.of(context);

    return Scaffold(
        drawer: AppDrawer(),
        appBar: WidgetUtils.appBar(title: "${widget.category}"),
        // appBar: AppBar(
        //   title: Text(

        //     '${widget.category}',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),

        body: GridListComponent(
          category: widget.category,
        ));
  }
}
