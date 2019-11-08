import 'package:admob_flutter/admob_flutter.dart';

import 'apikeys.dart';

String getBannerAdUnitId() {
  return apikeys["addMobBanner"];
}

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
}

void showAd() async {
  counter++;
  if (counter % 3 == 0) {
    interstitialAd.load();
  }

  if (await interstitialAd.isLoaded) {
    interstitialAd.show();
  }
}

int counter = 0;
