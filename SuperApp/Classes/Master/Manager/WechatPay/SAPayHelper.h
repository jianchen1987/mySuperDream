//
//  SAPayHelper.h
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAPayHelper : NSObject

/// 判断用户设备是否支持微信支付
/// @param appNotInstalledHandler 微信未安装回调
/// @param appNotSupportApiHandler 微信当前版本不支持此功能回调
+ (BOOL)isSupportWechatPayAppNotInstalledHandler:(void (^_Nullable)(void))appNotInstalledHandler appNotSupportApiHandler:(void (^_Nullable)(void))appNotSupportApiHandler;
@end

NS_ASSUME_NONNULL_END
