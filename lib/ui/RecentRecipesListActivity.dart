import 'dart:async';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:easy_vegan_cooking/components/GridListComponent.dart';

import '../apikeys.dart';
import '../components/AppDrawer.dart';

class RecentRecipesListActivity extends StatefulWidget {
  RecentRecipesListActivity({Key key}) : super(key: key);

  @override
  _RecentRecipesListActivityState createState() =>
      _RecentRecipesListActivityState();
}

class _RecentRecipesListActivityState extends State<RecentRecipesListActivity> {
  DatabaseReference recipesRef;
  StreamSubscription _recipesSubscription;
  void _showAd() async {
    _counter++;
    if (_counter % 3 == 0) {
      interstitialAd.load();
    }

    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  @override
  void initState() {
    recipesRef = FirebaseDatabase.instance.reference();

    _recipesSubscription = recipesRef.onChildAdded.listen((event) {
      print('Child added: ${event.snapshot.value}');
    });
    super.initState();
  }

  @override
  void dispose() {
    _recipesSubscription..cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('New vegan recipes'),
      ),
      body: GridListComponent(
        listSize: 14,
      ),
    );
  }
}

String getBannerAdUnitId() {
  return apikeys["addMobBanner"];
}

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

int _counter = 0;
