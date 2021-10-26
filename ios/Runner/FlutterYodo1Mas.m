//
//  FlutterYodo1Mas.m
//  Runner
//
//  Created by 周玉震 on 2021/9/17.
//

#import "FlutterYodo1Mas.h"
#import <Yodo1MasCore/Yodo1Mas.h>
#import <YYModel/YYModel.h>

#define CHANNEL @"com.yodo1.mas/sdk"
#define METHOD_NATIVE_INIT_SDK @"native_init_sdk"
#define METHOD_NATIVE_IS_AD_LOADED @"native_is_ad_loaded"
#define METHOD_NATIVE_SHOW_AD @"native_show_ad"

#define METHOD_FLUTTER_INIT_EVENT @"flutter_init_event"
#define METHOD_FLUTTER_AD_EVENT @"flutter_ad_event"

@interface FlutterYodo1Mas()<Yodo1MasRewardAdDelegate, Yodo1MasInterstitialAdDelegate, Yodo1MasBannerAdDelegate>

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong)  FlutterMethodChannel *channel;

@end


@implementation FlutterYodo1Mas {
    
}

+ (FlutterYodo1Mas *)sharedInstance {
    static FlutterYodo1Mas *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FlutterYodo1Mas alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [Yodo1Mas sharedInstance].rewardAdDelegate = self;
    }
    return self;
}

- (void)buildWithController:(FlutterViewController *)controller {
    __weak __typeof(self)weakSelf = self;
    _controller = controller;
    _channel = [FlutterMethodChannel methodChannelWithName:CHANNEL binaryMessenger:controller];
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if (call.method) {
            if ([call.method isEqualToString: METHOD_NATIVE_INIT_SDK]) {
                NSString *appKey = call.arguments[@"app_key"];
                
                if (appKey) {
                    [weakSelf initSdk: appKey];
                    result(@1);
                }
            } else if ([call.method isEqualToString: METHOD_NATIVE_IS_AD_LOADED]) {
                BOOL isAdLoaded = NO;
                NSString *type = call.arguments[@"ad_type"];
                if (type) {
                    if ([type isEqualToString:@"Reward"]) {
                        isAdLoaded = [[Yodo1Mas sharedInstance] isRewardAdLoaded];
                    } else if ([type isEqualToString:@"Interstitial"]) {
                        isAdLoaded = [[Yodo1Mas sharedInstance] isInterstitialAdLoaded];
                    } if ([type isEqualToString:@"Banner"]) {
                        isAdLoaded = [[Yodo1Mas sharedInstance] isBannerAdLoaded];
                    }
                }
                result(@(isAdLoaded));
            } else if ([call.method isEqualToString: METHOD_NATIVE_SHOW_AD]) {
                NSLog(@"Show Ad - %@", call.arguments);
                NSString *type = call.arguments[@"ad_type"];
                if (type) {
                    if ([type isEqualToString:@"Reward"]) {
                        [[Yodo1Mas sharedInstance] showRewardAd];
                    } else if ([type isEqualToString:@"Interstitial"]) {
                        [[Yodo1Mas sharedInstance] showInterstitialAd];
                    } if ([type isEqualToString:@"Banner"]) {
                        [[Yodo1Mas sharedInstance] showBannerAd];
                    }
                }
                result(nil);
            } else {
                result(FlutterMethodNotImplemented);
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (void)initSdk:(NSString *)appKey {
    __weak __typeof(self)weakSelf = self;
    [[Yodo1Mas sharedInstance] initWithAppKey:appKey successful:^{
        if (weakSelf.channel) {
            NSDictionary *json = @{@"successful" : @(YES)};
            [weakSelf.channel invokeMethod:METHOD_FLUTTER_INIT_EVENT arguments: json];
        }
    } fail:^(Yodo1MasError * error) {
        if (weakSelf.channel) {
            NSDictionary *json = @{@"successful" : @(NO), @"error" : [error getJsonObject]};
            [weakSelf.channel invokeMethod:METHOD_FLUTTER_INIT_EVENT arguments: json];
        }
    }];
}

#pragma mark - Yodo1Masdelegate
- (void)onAdOpened:(Yodo1MasAdEvent *)event {
    if (self.channel) {
        [self.channel invokeMethod:METHOD_FLUTTER_AD_EVENT arguments: [event getJsonObject]];
    }
}

- (void)onAdClosed:(Yodo1MasAdEvent *)event {
    if (self.channel) {
        [self.channel invokeMethod:METHOD_FLUTTER_AD_EVENT arguments: [event getJsonObject]];
    }
}

- (void)onAdError:(Yodo1MasAdEvent *)event error:(Yodo1MasError *)error {
    if (self.channel) {
        [self.channel invokeMethod:METHOD_FLUTTER_AD_EVENT arguments: [event getJsonObject]];
    }
}

- (void)onAdRewardEarned:(Yodo1MasAdEvent *)event {
    if (self.channel) {
        [self.channel invokeMethod:METHOD_FLUTTER_AD_EVENT arguments: [event getJsonObject]];
    }
}

@end
