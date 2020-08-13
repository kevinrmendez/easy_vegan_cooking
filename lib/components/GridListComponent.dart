import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity/connectivity.dart';

import 'package:easy_vegan_cooking/models/Recipe.dart';
import 'package:easy_vegan_cooking/components/EmptyListTitle.dart';
import 'package:easy_vegan_cooking/components/MyGridTile.dart';
import 'package:easy_vegan_cooking/utils/utils.dart';

import '../helpers.dart';

class GridListComponent extends StatefulWidget {
  final String category;
  final int listSize;

  GridListComponent({this.category, this.listSize});
  @override
  _GridListComponentState createState() => _GridListComponentState();
}

class _GridListComponentState extends State<GridListComponent> {
  // _GridListComponentState() {}
  DatabaseReference recipesRef;
  // StreamSubscription _recipesSubscription;
  var connectivityResult;
  var connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  List<Recipe> recipeList = [];

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
    super.initState();
    initConnectivity();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("Connection Status has Changed");
      _updateConnectionStatus(result);
    });
    recipesRef = FirebaseDatabase.instance.reference();
    recipesRef.once().then((onValue) {
      print(onValue);
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: FirebaseAnimatedList(
                    query: widget.listSize == null
                        ? FirebaseDatabase.instance.reference()
                        : FirebaseDatabase.instance
                            .reference()
                            .orderByChild("id")
                            .limitToLast(widget.listSize),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Recipe recipe = Utils.recipeBuilder(snapshot.value);
                      if (widget.category == null) {
                        return MyGridTile(
                          recipe: recipe,
                          // animation: animation,
                        );
                      } else {
                        return recipe.category == widget.category
                            ? MyGridTile(
                                recipe: recipe,
                                // animation: animation,
                              )
                            : SizedBox();
                      }
                    },
                  ),
                ),
                AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: AdmobBannerSize.BANNER,
                ),
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
    );
  }
}
