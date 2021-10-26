//
//  FlutterYodo1Mas.h
//  Runner
//
//  Created by 周玉震 on 2021/9/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterYodo1Mas : NSObject

+ (FlutterYodo1Mas *)sharedInstance;
- (void)buildWithController:(FlutterViewController *)controller;

@end

NS_ASSUME_NONNULL_END
