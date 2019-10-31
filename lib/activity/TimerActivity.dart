import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:flutter/material.dart';

import 'package:admob_flutter/admob_flutter.dart';

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
  CountDown cd = CountDown(Duration(seconds: 10));
  bool isTimerActive;
  int time;
  var sub;

  void startTimer() {
    if (isTimerActive) {
      setState(() {
        isTimerActive = false;
      });
    } else {
      sub.onData((Duration d) {
        print(d);
        setState(() {
          time = time - 1;
        });
      });
    }

    // setState(() {
    //   isTimerActive = !isTimerActive;
    // });

    // if (isTimerActive) {
    //   sub.pause();
    // } else {
    //   sub.resume();
    // }

    sub.onDone(() {
      print("Timer completed");
    });
  }

  void stopTimer() {
    sub.setState(() {
      time = 0;
    });
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
  void initState() {
    time = 10;
    isTimerActive = false;
    sub = cd.stream.listen(null);

    super.initState();
  }

  @override
  void dispose() {
    sub.stream.cancel();
    super.dispose();
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
      body: Column(
        children: <Widget>[
          Text('timer here'),
          TextField(keyboardType: TextInputType.datetime),
          Text('$time'),
          RaisedButton(
            onPressed: startTimer,
            child: isTimerActive ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          ),
          RaisedButton(
            onPressed: stopTimer,
            child: Icon(Icons.stop),
          ),
          AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
          ),
        ],
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
