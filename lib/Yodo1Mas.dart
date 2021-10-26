import 'package:flutter/services.dart';
import 'dart:convert';

class Yodo1Mas {
  static const _CHANNEL = "com.yodo1.mas/sdk";
  static const _METHOD_NATIVE_INIT_SDK = "native_init_sdk";
  static const _METHOD_NATIVE_IS_AD_LOADED = "native_is_ad_loaded";
  static const _METHOD_NATIVE_SHOW_AD = "native_show_ad";
  static const _METHOD_FLUTTER_INIT_EVENT = "flutter_init_event";
  static const _METHOD_FLUTTER_AD_EVENT = "flutter_ad_event";
  static const _METHOD_DISMISS_BANNER = "dismiss_banner";


  static const AD_TYPE_REWARD = 1;
  static const AD_TYPE_INTERSTITIAL = 2;
  static const AD_TYPE_BANNER = 3;

  static const AD_EVENT_OPENED = 1001;
  static const AD_EVENT_CLOSED = 1002;
  static const AD_EVENT_ERROR = 1003;
  static const AD_EVENT_EARNED = 2001;

  static const _channel = const MethodChannel(_CHANNEL);

  Yodo1Mas._privateConstructor();
  static final Yodo1Mas instance = Yodo1Mas._privateConstructor();

  Function(bool successful)? _initCallback;
  Function(int event, String message)? _rewardCallback;
  Function(int event, String message)? _interstitialCallback;
  Function(int event, String message)? _bannerCallback;

  void init(String appKey, Function(bool successful)? callback) {
    _initCallback = callback;

    _channel.setMethodCallHandler((call) {
      switch(call.method) {
        case _METHOD_FLUTTER_INIT_EVENT: {
          bool successful = call.arguments["successful"];
          if (_initCallback != null) {
            _initCallback!(successful);
          }
          return Future<bool>.value(true);
        }
        case _METHOD_FLUTTER_AD_EVENT: {
          Map<String, dynamic> map = json.decode(call.arguments);
          int type = map["type"];
          int code = map["code"];
          String message = map["message"];
          switch (type) {
            case AD_TYPE_REWARD:
              if (_rewardCallback != null) {
                _rewardCallback!(code, message);
              }
              break;
            case AD_TYPE_INTERSTITIAL:
              if (_interstitialCallback != null) {
                _interstitialCallback!(code, message);
              }
              break;
            case AD_TYPE_BANNER:
              if (_bannerCallback != null) {
                _bannerCallback!(code, message);
              }
              break;
          }

          return Future<bool>.value(true);
        }
      }
      return Future<bool>.value(true);
    });
    _channel.invokeMethod(_METHOD_NATIVE_INIT_SDK, {"app_key": appKey});
  }

  void setRewardListener(Function(int event, String message)? callback) {
    _rewardCallback = callback;
  }

  void setInterstitialListener(Function(int event, String message)? callback) {
    _interstitialCallback = callback;
  }

  void setBannerListener(Function(int event, String message)? callback) {
    _bannerCallback = callback;
  }

  Future<bool?> isRewardAdLoaded() {
    return _channel.invokeMethod<bool>(_METHOD_NATIVE_IS_AD_LOADED, {"ad_type" : "Reward"});
  }

  void showRewardAd() {
    _channel.invokeMethod(_METHOD_NATIVE_SHOW_AD, {"ad_type" : "Reward"});
  }

  Future<bool?> isInterstitialAdLoaded() {
    return _channel.invokeMethod<bool>(_METHOD_NATIVE_IS_AD_LOADED, {"ad_type" : "Interstitial"});
  }

  void showInterstitialAd() {
    _channel.invokeMethod(_METHOD_NATIVE_SHOW_AD, {"ad_type" : "Interstitial"});
  }

  Future<bool?> isBannerAdLoaded() {
    return _channel.invokeMethod<bool>(_METHOD_NATIVE_IS_AD_LOADED, {"ad_type" : "Banner"});
  }

  void showBannerAd() {
    _channel.invokeMethod(_METHOD_NATIVE_SHOW_AD, {"ad_type" : "Banner"});
  }

  void dismissBannerAd() {
    _channel.invokeMethod(_METHOD_DISMISS_BANNER);
  }
}
