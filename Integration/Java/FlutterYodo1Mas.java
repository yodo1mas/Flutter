import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.JsonObject;
import com.yodo1.mas.Yodo1Mas;
import com.yodo1.mas.error.Yodo1MasError;
import com.yodo1.mas.event.Yodo1MasAdEvent;
import com.yodo1.mas.helper.model.Yodo1MasAdBuildConfig;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterYodo1Mas {

   private static FlutterYodo1Mas helper;
   public static FlutterYodo1Mas getInstance() {
       if (helper == null) {
           synchronized (Yodo1Mas.class) {
               if (helper == null) {
                   helper = new FlutterYodo1Mas();
               }
           }
       }
       return helper;
   }

   private static final String CHANNEL = "com.yodo1.mas/sdk";
   private static final String METHOD_NATIVE_INIT_SDK = "native_init_sdk";
   private static final String METHOD_NATIVE_IS_AD_LOADED = "native_is_ad_loaded";
   private static final String METHOD_NATIVE_SHOW_AD = "native_show_ad";

   private static final String METHOD_FLUTTER_INIT_EVENT = "flutter_init_event";
   private static final String METHOD_FLUTTER_AD_EVENT = "flutter_ad_event";
   private static final String DISMISS_BANNER = "dismiss_banner";

   private MethodChannel channel;
   private Activity activity;

   private FlutterYodo1Mas() {
       Yodo1Mas.getInstance().setRewardListener(new Yodo1Mas.RewardListener() {
           @Override
           public void onAdOpened(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdError(@NonNull Yodo1MasAdEvent event, @NonNull Yodo1MasError error) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdClosed(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdvertRewardEarned(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }
       });

       Yodo1Mas.getInstance().setInterstitialListener(new Yodo1Mas.InterstitialListener() {
           @Override
           public void onAdOpened(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdError(@NonNull Yodo1MasAdEvent event, @NonNull Yodo1MasError error) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdClosed(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }
       });
       Yodo1Mas.getInstance().setBannerListener(new Yodo1Mas.BannerListener() {
           @Override
           public void onAdOpened(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdError(@NonNull Yodo1MasAdEvent event, @NonNull Yodo1MasError error) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }

           @Override
           public void onAdClosed(@NonNull Yodo1MasAdEvent event) {
               if (channel != null) {
                   channel.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.getJSONObject().toString());
               }
           }
       });
   }

   public void build(FlutterEngine flutterEngine, Activity activity) {
       this.activity = activity;
       this.channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
       this.channel.setMethodCallHandler(
               new MethodChannel.MethodCallHandler() {
                   @Override
                   public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                       switch (call.method) {
                           case METHOD_NATIVE_INIT_SDK: {
                               String appKey = call.argument("app_key");
                               if (appKey != null) {
                                   initSdk(appKey);
                               }
                               result.success(null);
                               break;
                           }
                           case METHOD_NATIVE_IS_AD_LOADED:{
                               boolean isAdLoaded = false;
                               String type = call.argument("ad_type");
                               if (type != null) {
                                   switch (type) {
                                       case "Reward": {
                                           isAdLoaded = Yodo1Mas.getInstance().isRewardedAdLoaded();
                                           break;
                                       }
                                       case "Interstitial": {
                                           isAdLoaded = Yodo1Mas.getInstance().isInterstitialAdLoaded();
                                           break;
                                       }
                                       case "Banner": {
                                           isAdLoaded = Yodo1Mas.getInstance().isBannerAdLoaded();
                                           break;
                                       }
                                   }
                               }
                               result.success(isAdLoaded);
                               break;
                           }
                           case METHOD_NATIVE_SHOW_AD: {
                               String type = call.argument("ad_type");
                               if (type != null) {
                                   switch (type) {
                                       case "Reward": {
                                           Yodo1Mas.getInstance().showRewardedAd(FlutterYodo1Mas.this.activity);
                                           break;
                                       }
                                       case "Interstitial": {
                                           Yodo1Mas.getInstance().showInterstitialAd(FlutterYodo1Mas.this.activity);
                                           break;
                                       }
                                       case "Banner": {
                                           Yodo1Mas.getInstance().showBannerAd(FlutterYodo1Mas.this.activity);
                                           break;
                                       }
                                   }
                               }
                               result.success(null);
                               break;
                           }
                           case DISMISS_BANNER: {
                               Yodo1Mas.getInstance().dismissBannerAd();
                               result.success(null);
                               break;
                           }
                       }
                   }
               }
       );
   }

   private void initSdk(@NonNull String appKey) {
       Yodo1MasAdBuildConfig config = new Yodo1MasAdBuildConfig.Builder().enableUserPrivacyDialog(true).build();
       Yodo1Mas.getInstance().setAdBuildConfig(config);
       Yodo1Mas.getInstance().init(activity, appKey, new Yodo1Mas.InitListener() {
           @Override
           public void onMasInitSuccessful() {
               if (channel != null) {
                   JsonObject json = new JsonObject();
                   json.addProperty("successful", true);
                   Log.d(FlutterYodo1Mas.CHANNEL, "调用Flutter方法 - " + METHOD_FLUTTER_INIT_EVENT);
                   Map<String, String> args = new HashMap<>();
                   args.put("successful", "true");
                   channel.invokeMethod(METHOD_FLUTTER_INIT_EVENT, args);
               }
           }

           @Override
           public void onMasInitFailed(@NonNull Yodo1MasError error) {
               if (channel != null) {
                   JsonObject json = new JsonObject();
                   json.addProperty("successful", false);
                   json.addProperty("error", error.getJsonObject().toString());
                   channel.invokeMethod(METHOD_FLUTTER_INIT_EVENT, json.toString());
               }
           }
       });
   }
}