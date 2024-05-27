//
//  WXApiManager.h
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShareObject.h"
#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>

NS_ASSUME_NONNULL_BEGIN

@class SAWechatPayRequestModel;

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

@end


@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
// 微信支付请求
- (void)sendPayReq:(SAWechatPayRequestModel *)requestModel;

/// 微信分享
/// @param shareObject 分享模型
/// @param scene 分享渠道 @see WXScene
/// @param completion 回调
- (void)sendShareReq:(SAShareObject *)shareObject inScene:(int)scene completion:(void (^__nullable)(BOOL success))completion;

/// 微信授权登陆请求
- (void)sendLoginReqWithViewController:(nullable UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
