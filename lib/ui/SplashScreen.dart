import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

import '../apikeys.dart';
import 'categoryActivity.dart';

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
