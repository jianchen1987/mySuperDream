//
//  SAOpenCapabilityAppPayPresenter.h
//  SuperApp
//
//  Created by seeu on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WNOpenCapability NS_STRING_ENUM;
FOUNDATION_EXPORT WNOpenCapability const WNOpenCapabilityAppPay; ///< WOWNOW开放能力，订单支付


@interface SAOpenCapabilityAppPayPresenter : NSObject

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+ (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler;

@end

NS_ASSUME_NONNULL_END
