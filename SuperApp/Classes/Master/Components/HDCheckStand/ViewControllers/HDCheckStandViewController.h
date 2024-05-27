//
//  HDCheckStandViewController.h
//  SuperApp
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandTextField.h"
#import "HDCheckStandWechatPayResultResp.h"
#import "HDOnlinePaymentToolsModel.h"
#import "HDPresentViewControllerAnimation.h"
#import "HDTradeBuildOrderModel.h"

/** 订单超时支付的最后操作 */
typedef NS_ENUM(NSInteger, HDCheckStandPaymentOverTimeEndActionType) {
    HDCheckStandPaymentOverTimeEndActionTypeConfirm = 0,        ///< 确认订单页面
    HDCheckStandPaymentOverTimeEndActionTypeChoosePreferential, ///< 选择优惠方式
    HDCheckStandPaymentOverTimeEndActionTypeChoosePayMethod,    ///< 选择支付方式
    HDCheckStandPaymentOverTimeEndActionTypeInputPassword       ///< 输入交易密码页面
};

/** 收银台风格 */
typedef NS_ENUM(NSInteger, HDCheckStandViewControllerStyle) {
    HDCheckStandViewControllerStyleDefault = 0, ///< 收银台
    HDCheckStandViewControllerStyleVerifyPwd,   ///< 验证支付密码
};

@class HDCheckStandViewController;
@class HDTradeSubmitPaymentRspModel;
@class SAModel;

/** 点击阴影的操作类型 */
typedef NS_ENUM(NSInteger, HDCheckStandTappedShadowAction) {
    HDCheckStandTappedShadowActionDefault = 0,             ///< 什么也不做
    HDCheckStandTappedShadowActionDismiss,                 ///< 消失
    HDCheckStandTappedShadowActionDismissOnlyInConfirmPage ///< 只在确认页允许消失
};

NS_ASSUME_NONNULL_BEGIN

@protocol HDCheckStandViewControllerDelegate <NSObject>

@required
/**
 收银台初始化失败
 下支付单失败or获取支付工具失败，需要重新下单, 会自动收起收银台
 @param controller 收银台
*/
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller;

/**
 支付成功
 @param controller 收银台
 @param resultResp 支付成功返回模型
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *_Nullable)resultResp;

/**
 支付失败
 @param controller 收银台
 @param resultResp 支付失败返回模型
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(HDCheckStandPayResultResp *)resultResp;

/// 已完成，但是状态未明
/// @param controller 收银台
- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller;

/**
 支付失败（可能是网络错误）
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error;

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller;

@optional

/**
 收银台已显示
 @param controller 收银台
 */
- (void)checkStandViewControllerDidShown:(HDCheckStandViewController *)controller;

/**
 获取凭证成功
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo;

/**
 密码输入完成
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller completedInputPassword:(HDCheckStandTextField *)textField;

/**
 验证支付密码失败（可能是网络错误），使用者自行决定密码输入框和收银台操作
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller
    verifyPwdPaymentPasswordfailureWithRspModel:(SARspModel *_Nullable)rspModel
                                      errorType:(CMResponseErrorType)errorType
                                          error:(NSError *_Nullable)error;

/**
 订单超过5分钟内未支付
 @param type 超时支付时用户所在的页面
 */
- (void)checkStandViewControllerPaymentOverTime:(HDCheckStandViewController *)controller endActionType:(HDCheckStandPaymentOverTimeEndActionType)type;

/**
 验证支付密码成功

 @param controller 收银台
 @param token 凭证
 @param index 加密因子
 @param password 加密后的密码
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller verifyPwdPaymentPasswordSuccess:(NSString *)token index:(NSString *)index password:(NSString *)password;

/// 获取viewcontroller
/// @param controller 收银台
- (void)getCheckStandViewController:(HDCheckStandViewController *)controller;

/// 货到付款完成
/// @param controller 收银台
/// @param bussineLine 业务线
/// @param orderNo 聚合订单号
- (void)checkStandViewControllerCashOnDeliveryCompleted:(HDCheckStandViewController *)controller bussineLine:(SAClientType)bussineLine orderNo:(NSString *)orderNo;


@end


@interface HDCheckStandViewController : UINavigationController

/// 创建默认收银台
+ (instancetype)checkStandWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel preferedHeight:(CGFloat)preferedHeight;
- (instancetype)initWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel preferedHeight:(CGFloat)preferedHeight;

/// 验证支付密码类型收银台
+ (instancetype)checkStandWithPreferedHeight:(CGFloat)preferedHeight style:(HDCheckStandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr;
- (instancetype)initWithPreferedHeight:(CGFloat)preferedHeight style:(HDCheckStandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr;

@property (nonatomic, weak) id<HDCheckStandViewControllerDelegate> resultDelegate; ///< 代理

@property (assign, nonatomic) HDCSPresentVCAnimationStyle presentingStyle;
@property (assign, nonatomic) HDCSPresentVCAnimationStyle dismissStyle;
@property (nonatomic, assign) HDCheckStandTappedShadowAction tappedShadowAction; ///< 点击阴影的操作类型

@property (nonatomic, strong) HDCheckStandTextField *textField; ///< 密码输入框
@property (nonatomic, copy) void (^tappedShadowHandler)(void);  ///< 点击了阴影
/// 下单模型
@property (nonatomic, strong, readonly) HDTradeBuildOrderModel *buildModel;

/** 动画消失收银台 */
- (void)dismissViewControllerCompletion:(void (^__nullable)(void))completion;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;

/// 返回当前订单号
- (NSString *)currentOrderNo;
/// 返回应付金额
- (SAMoneyModel *)payableAmount;
/// 返回业务线
- (NSString *)businessLine;
/// 返回支付单号
- (NSString *)outPayOrderNo;
/// 返回商户号
- (NSString *)merchantNo;

- (id)associatedObject;

@end

NS_ASSUME_NONNULL_END
