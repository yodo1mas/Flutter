import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.JsonObject;
import com.yodo1.mas.Yodo1Mas;
import com.yodo1.mas.Yodo1Mas.RewardListener
import com.yodo1.mas.error.Yodo1MasError;
import com.yodo1.mas.event.Yodo1MasAdEvent;
import com.yodo1.mas.helper.model.Yodo1MasAdBuildConfig;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result;
class FlutterYodo1Mas {
   private var helper: FlutterYodo1Mas? = null
   companion object {
       private var helper: FlutterYodo1Mas? = null
       @JvmStatic
       fun getInstance(): FlutterYodo1Mas? {
           if (helper == null) {
               synchronized(Yodo1Mas::class.java) {
                   if (helper == null) {
                       helper = FlutterYodo1Mas()
                   }
               }
           }
           return helper
       }
   }

   private val CHANNEL = "com.yodo1.mas/sdk"
   private val METHOD_NATIVE_INIT_SDK = "native_init_sdk"
   private val METHOD_NATIVE_IS_AD_LOADED = "native_is_ad_loaded"
   private val METHOD_NATIVE_SHOW_AD = "native_show_ad"

   private val METHOD_FLUTTER_INIT_EVENT = "flutter_init_event"
   private val METHOD_FLUTTER_AD_EVENT = "flutter_ad_event"
   private val DISMISS_BANNER = "dismiss_banner"

   private var channel: MethodChannel? = null
   private var activity: Activity? = null

   //private fun FlutterYodo1Mas(): FlutterYodo1Mas? {
   init {
       Yodo1Mas.getInstance().setRewardListener(object : RewardListener() {
           override fun onAdOpened(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdError(event: Yodo1MasAdEvent, error: Yodo1MasError) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdClosed(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdvertRewardEarned(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }
       })
       Yodo1Mas.getInstance().setInterstitialListener(object : Yodo1Mas.InterstitialListener() {
           override fun onAdOpened(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdError(event: Yodo1MasAdEvent, error: Yodo1MasError) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdClosed(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }
       })
       Yodo1Mas.getInstance().setBannerListener(object : Yodo1Mas.BannerListener() {
           override fun onAdOpened(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdError(event: Yodo1MasAdEvent, error: Yodo1MasError) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }

           override fun onAdClosed(event: Yodo1MasAdEvent) {
               if (channel != null) {
                   channel!!.invokeMethod(METHOD_FLUTTER_AD_EVENT, event.jsonObject.toString())
               }
           }
       })

   }

   fun build(flutterEngine: FlutterEngine, activity: Activity?) {
       this.activity = activity
       channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
       channel!!.setMethodCallHandler { call, result ->
           when (call.method) {
               METHOD_NATIVE_INIT_SDK -> {
                   val appKey = call.argument<String>("app_key")
                   appKey?.let { initSdk(it) }
                   result.success(null)
               }
               METHOD_NATIVE_IS_AD_LOADED -> {
                   var isAdLoaded = false
                   val type = call.argument<String>("ad_type")
                   if (type != null) {
                       when (type) {
                           "Reward" -> {
                               isAdLoaded = Yodo1Mas.getInstance().isRewardedAdLoaded
                           }
                           "Interstitial" -> {
                               isAdLoaded = Yodo1Mas.getInstance().isInterstitialAdLoaded
                           }
                          
                       }
                   }
                   result.success(isAdLoaded)
               }
               METHOD_NATIVE_SHOW_AD -> {
                   val type = call.argument<String>("ad_type")
                   if (type != null) {
                       when (type) {
                           "Reward" -> {
                               Yodo1Mas.getInstance().showRewardedAd(this@FlutterYodo1Mas.activity!!)
                           }
                           "Interstitial" -> {
                               Yodo1Mas.getInstance().showInterstitialAd(this@FlutterYodo1Mas.activity!!)
                           }
                           "Banner" -> {
                               Yodo1Mas.getInstance().showBannerAd(this@FlutterYodo1Mas.activity!!)
                           }
                       }
                   }
                   result.success(null)
               }
               DISMISS_BANNER -> {
                   Yodo1Mas.getInstance().dismissBannerAd()
                   result.success(null)
               }
           }
       }
   }

   private fun initSdk(appKey: String) {
       val config = Yodo1MasAdBuildConfig.Builder().enableUserPrivacyDialog(true).build()
       Yodo1Mas.getInstance().setAdBuildConfig(config)
       Yodo1Mas.getInstance().init(activity!!, appKey, object : Yodo1Mas.InitListener {
           override fun onMasInitSuccessful() {
               if (channel != null) {
                   val json = JsonObject()
                   json.addProperty("successful", true)
                   val args: MutableMap<String, String> = HashMap()
                   args["successful"] = "true"
                   channel!!.invokeMethod(METHOD_FLUTTER_INIT_EVENT, args)
               }
           }

           override fun onMasInitFailed(error: Yodo1MasError) {
               if (channel != null) {
                   val json = JsonObject()
                   json.addProperty("successful", false)
                   json.addProperty("error", error.jsonObject.toString())
                   channel!!.invokeMethod(METHOD_FLUTTER_INIT_EVENT, json.toString())
               }
           }
       })
   }
}
