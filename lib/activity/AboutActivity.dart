import 'package:audioplayers/audio_cache.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:countdown/countdown.dart';

import 'package:countdown_flutter/countdown_flutter.dart';

import '../apikeys.dart';

class TimerActivity extends StatefulWidget {
  // TimerActivity({Key key}) : super(key: key);

  @override
  _TimerActivityState createState() => _TimerActivityState();
}

class _TimerActivityState extends State<TimerActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    // var filteredData = data.where((recipe) => recipe["category"] == "dinner");
    // var recipes = AppState.of(context).recipes;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Favorite vegan recipes'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 4,
          margin: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'About',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                  'Easy vegan cooking is a free app that contains vegan recipes'),
              Text('Sound effects obtained from https://www.zapsplat.com'),
              AdmobBanner(
                adUnitId: getBannerAdUnitId(),
                adSize: AdmobBannerSize.BANNER,
              ),
            ],
          ),
        ),
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
