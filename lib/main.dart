import 'package:flutter/material.dart';
import 'Yodo1Mas.dart';
void main() {
  runApp(const MyApp());
  startInitSdk();
}
void startInitSdk()
{

  Yodo1Mas.instance.setInterstitialListener((event, message) {
    switch(event) {
      case Yodo1Mas.AD_EVENT_OPENED:
        print('Interstitial AD_EVENT_OPENED');
        break;
      case Yodo1Mas.AD_EVENT_ERROR:
        print('Interstitial AD_EVENT_ERROR' + message);
        break;
      case Yodo1Mas.AD_EVENT_CLOSED:
        print('Interstitial AD_EVENT_CLOSED');
        break;
    }
  });

  Yodo1Mas.instance.setBannerListener((event, message) {
    switch(event) {
      case Yodo1Mas.AD_EVENT_OPENED:
        print('Banner AD_EVENT_OPENED');
        break;
      case Yodo1Mas.AD_EVENT_ERROR:
        print('Banner AD_EVENT_ERROR' + message);
        break;
      case Yodo1Mas.AD_EVENT_CLOSED:
        print('Banner AD_EVENT_CLOSED');
        break;
    }
  });
  Yodo1Mas.instance.init("mhLeFzAL4F", (successful) {

  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MAS Integration Sample',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Yodo1 MAS Flutter Integration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}  ) : super(key: key) ;


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {

  int _bonus = 0;



  void GiveRewardDelegate()
  {
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
          _incrementCounter();
          break;
      }
    });


  }
  void showBannerAds()
  {
    Yodo1Mas.instance.showBannerAd();

  }
  void hideBannerAds()
  {
    Yodo1Mas.instance.dismissBannerAd();
  }
  void showInterAds()
  {
    Yodo1Mas.instance.showInterstitialAd();


  }
  void showRewardedAds()
  {

    Yodo1Mas.instance.showRewardAd();
    GiveRewardDelegate();
  }

  void _incrementCounter() {
    //initSdk();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _bonus+=5;
    });
  }
 // void initSdk(){
  //  SetDeledates();

 // }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
      mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: Text("${_bonus}"),
            ),
            SizedBox(
              height: 16,
            ),

           SizedBox(
             width: 200,
             height: 50,
             child: RaisedButton(
                 padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                 onPressed: (

                     ){showBannerAds();

             }, color:Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                 child: Text("Show Banner")),
           ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                  onPressed: (

                      ){hideBannerAds();

                  }, color:Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text("Hide Banner")),
            ),
            SizedBox(
              height: 16,
            ),

            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                  onPressed: (){
                  showInterAds();
                  }, color:Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Text("Show Interstitial")),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton.icon(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                  onPressed: (){
                    showRewardedAds();
                  }, icon: Icon(Icons.ondemand_video_outlined), label: Text("Show Reward  "+"+5"), color:Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                 ),
                  //child: Text("Show Rewarded Ads")),
            ),
            SizedBox(
              height: 16,
            ),
          ],

      )),


    );
  }


}

