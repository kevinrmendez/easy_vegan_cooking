import 'package:audioplayers/audio_cache.dart';
import 'package:easy_vegan_cooking/components/AppDrawer.dart';
import 'package:easy_vegan_cooking/utils/widgetUtils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/async.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:countdown/countdown.dart';

import 'package:countdown_flutter/countdown_flutter.dart';

import '../apikeys.dart';
import '../app_localizations.dart';

class TimerActivity extends StatefulWidget {
  // TimerActivity({Key key}) : super(key: key);

  @override
  _TimerActivityState createState() => _TimerActivityState();
}

class _TimerActivityState extends State<TimerActivity> {
  CountDown cd;
  CountdownTimer countDownTimer;
  final timeController = TextEditingController();
  AudioCache audioPlayer;
  bool isTimerActive;
  bool isDone;
  String isDoneText;
  String timerStatusText;
  int time;
  var countdown;

  void startTimer() {
    setState(() {
      timerStatusText = "Set cooking alarm";
      isDoneText = "";
      isDone = false;
    });
    if (time > 0) {
      setState(() {
        isTimerActive = true;
        timerStatusText = "Time remaining";
      });
      countDownTimer = CountdownTimer(
        new Duration(minutes: time),
        new Duration(minutes: 1),
      );

      countdown = countDownTimer.listen(null);
      countdown.onData((duration) {
        setState(() {
          time--;
        });
      });

      countdown.onDone(() {
        setState(() {
          isDone = true;
          isDoneText = "Food is ready";
          timeController.text = "";
          timerStatusText = "";
          isTimerActive = false;
        });
        countdown.cancel();
        audioPlayer.play('alarmClock.mp3');
        vibrate();
      });
    }
  }

  void stopTimer() {
    countdown.cancel();
    setState(() {
      isDoneText = "";
      time = 0;
      isTimerActive = false;
      timerStatusText = "Set cooking alarm";
    });
    timeController.text = "";
  }

  void vibrate() {
    Vibration.vibrate(duration: 1500);
  }

  @override
  void initState() {
    timerStatusText = "Set cooking alarm";
    time = 30;
    isTimerActive = false;
    timeController.text = time.toString();
    isDoneText = "";
    isDone = false;
    audioPlayer = AudioCache();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: WidgetUtils.appBar(title: 'Timer'),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 4,
          margin: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.clock,
                size: 60,
              ),

              isDone
                  ? Text(
                      isDoneText,
                      style: TextStyle(fontSize: 30),
                    )
                  : Text(
                      timerStatusText,
                      style: TextStyle(fontSize: 30),
                    ),
              isDone
                  ? SizedBox()
                  : Column(
                      children: <Widget>[
                        Text(
                          '$time',
                          style: TextStyle(fontSize: 60),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 7),
                            child: Text(" ${time > 1 ? "minutes" : "minute"}")),
                        // isTimerActive ? CircularProgressIndicator() : SizedBox()
                      ],
                    ),

              Container(
                width: MediaQuery.of(context).size.width * .4,
                child: isTimerActive
                    ? SizedBox()
                    : TextField(
                        onTap: () {
                          setState(() {
                            timerStatusText = "Set cooking  alarm";
                            isDone = false;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'time in minutes', hintText: '0'),
                        keyboardType: TextInputType.number,
                        controller: timeController,
                        onChanged: (value) {
                          this.time = int.parse(value);
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: isTimerActive
                        ? RaisedButton(
                            onPressed: stopTimer,
                            child: Icon(Icons.stop),
                          )
                        : RaisedButton(
                            onPressed: startTimer,
                            child: Icon(Icons.play_arrow),
                          ),
                  ),
                ],
              ),
              // AdmobBanner(
              //   adUnitId: getBannerAdUnitId(),
              //   adSize: AdmobBannerSize.BANNER,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// String getBannerAdUnitId() {
//   return apikeys["addMobBanner"];
// }

// AdmobInterstitial interstitialAd = AdmobInterstitial(
//   adUnitId: getInterstitialAdUnitId(),
// );

// getInterstitialAdUnitId() {
//   return apikeys["addMobInterstellar"];
// }

// int _counter = 0;
