//
//  SANotificationConst.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NSFoundationVersionNumber_iOS_9_x_Max
typedef NSString *NSNotificationName NS_EXTENSIBLE_STRING_ENUM;
#endif

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const kNotificationNameDeviceChanged;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameReceiveRegistrationToken;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameReceivedNewMessage;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetAppHomeDynamicFunctionList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetAppTabBarConfigList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetDeliveryAppHomeDynamicFunctionList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetDeliveryAppTabBarConfigList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetTinhNowAppTabBarConfigList;
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSuccessGetGroupBuyAppTabBarConfigList;

/// 用户改变位置
FOUNDATION_EXPORT NSNotificationName const kNotificationNameUserChangedLocation;
/// 用户下单成功
FOUNDATION_EXPORT NSNotificationName const kNotificationNameOrderSubmitSuccess;
/// 登录成功
FOUNDATION_EXPORT NSNotificationName const kNotificationNameLoginSuccess;
/// 用户退出登录
FOUNDATION_EXPORT NSNotificationName const kNotificationNameUserLogout;
/// 发送一个sendReq后，收到微信的回应
FOUNDATION_EXPORT NSNotificationName const kNotificationWechatPayOnResponse;
/// 从未登入到已登入后上传离线购物车数据完成通知
FOUNDATION_EXPORT NSNotificationName const kNotificationNameUploadOfflineShoppingGoodsCompleted;
/// 电商下单成功
FOUNDATION_EXPORT NSNotificationName const kNotificationNameTNOrderSubmitSuccess;
/// 电商提交订单成功，刷新count
FOUNDATION_EXPORT NSNotificationName const kNotificationNameTNOrderSubmited;
/// 微信授权登录成功
FOUNDATION_EXPORT NSNotificationName const kNotificationWechatAuthLoginResponse;
/// 外卖门店页刷新
FOUNDATION_EXPORT NSNotificationName const kNotificationNameReloadStoreDetail;
/// 外卖门店页购物车刷新
FOUNDATION_EXPORT NSNotificationName const kNotificationNameReloadStoreShoppingCart;
/// 远程配置更新
FOUNDATION_EXPORT NSNotificationName const kNotificationNameRemoteConfigsUpdate;
/// IM 登陆成功
FOUNDATION_EXPORT NSNotificationName const kNotificationNameIMLoginSuccess;
/// Voip token获取
FOUNDATION_EXPORT NSNotificationName const kNotificationNameVoipTokenChanged;
/// 有新的push消息到来
FOUNDATION_EXPORT NSNotificationName const kNotificationNameNewMessages;
/// 太子银行支付回调
FOUNDATION_EXPORT NSNotificationName const kNotificationNamePrinceBankResp;
/// 汇旺支付回调
FOUNDATION_EXPORT NSNotificationName const kNotificationNameHuiOneResp;
/// 成功获取传声筒DT
FOUNDATION_EXPORT NSNotificationName const kNotificationNameDidReceiveHelloPlatformDeviceToken;
///跳转到验证码登录页面
FOUNDATION_EXPORT NSNotificationName const kNotificationNamePushSMSLoginViewController;
///监听tabbar切换
FOUNDATION_EXPORT NSNotificationName const kNotificationNameSATabBarControllerChangeSelectedIndex;

NS_ASSUME_NONNULL_END
