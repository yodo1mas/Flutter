import 'dart:io';

import 'package:flutter/material.dart';
import 'Yodo1Mas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState() {

    Yodo1Mas.instance.setRewardListener((event, message) {
      switch(event) {
        case Yodo1Mas.AD_EVENT_OPENED:
          print('RewardVideo AD_EVENT_OPENED');
          break;
        case Yodo1Mas.AD_EVENT_ERROR:
          print('RewardVideo AD_EVENT_ERROR' + message);
          break;
        case Yodo1Mas.AD_EVENT_CLOSED:
          print('RewardVideo AD_EVENT_CLOSED');
          break;
        case Yodo1Mas.AD_EVENT_EARNED:
          print('RewardVideo AD_EVENT_EARNED');
          break;
      }
    });

    var appKey = Platform.isAndroid ? "1BUpPjJgws" : "1yLpy8IMte";
    Yodo1Mas.instance.init(appKey, (successful) {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Show Reward Ad"),
              onPressed: () {
                Yodo1Mas.instance.showRewardAd();
              },
            ),
            ElevatedButton(
              child: Text("Show Interstitial Ad"),
              onPressed: () {
                Yodo1Mas.instance.showInterstitialAd();
              },
            ),
            ElevatedButton(
              child: Text("Show Banner Ad"),
              onPressed: () {
                Yodo1Mas.instance.showBannerAd();
              },
            )
          ],
        ),
      )
    );
  }
}
