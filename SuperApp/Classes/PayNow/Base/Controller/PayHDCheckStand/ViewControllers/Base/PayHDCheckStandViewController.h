//
//  PayHDCheckstandViewController.h
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNPaymentReqModel.h"
#import "PayHDCheckstandConfirmViewController.h"
#import "PayHDCheckstandTextField.h"
#import "PayHDPresentViewControllerAnimation.h"
#import "PayHDTradeBuildOrderRspModel.h"

@class PayHDCheckstandViewController;
@class PayHDTradeSubmitPaymentRspModel;

/** 点击阴影的操作类型 */
typedef NS_ENUM(NSInteger, PayPayHDCheckstandTappedShadowAction) {
    PayPayHDCheckstandTappedShadowActionDefault = 0,             ///< 什么也不做
    PayPayHDCheckstandTappedShadowActionDismiss,                 ///< 消失
    PayPayHDCheckstandTappedShadowActionDismissOnlyInConfirmPage ///< 只在确认页允许消失
};

NS_ASSUME_NONNULL_BEGIN

@protocol PayHDCheckstandViewControllerDelegate <NSObject>

@optional

/// 收银台已显示
/// @param controller 收银台
- (void)checkStandViewControllerDidShown:(PayHDCheckstandViewController *)controller;

/**
 支付成功

 @param controller 收银台
 @param rspModel 支付成功返回模型
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel;

/**
 支付失败
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller transactionFailure:(NSString *)reason code:(NSString *)code;

/**
 获取凭证成功
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo;

/**
 密码输入完成
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller completedInputPassword:(PayHDCheckstandTextField *)textField;

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewControllerUserClosedCheckStand:(PayHDCheckstandViewController *)controller;

/**
 订单超过5分钟内未支付
 @param type 超时支付时用户所在的页面
 */
- (void)checkStandViewControllerPaymentOverTime:(PayHDCheckstandViewController *)controller endActionType:(PayHDCheckstandPaymentOverTimeEndActionType)type;

/**
 验证支付密码成功

 @param controller 收银台
 @param token 凭证
 @param index 加密因子
 @param password 加密后的密码
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyPwdPaymentPasswordSuccess:(NSString *)token index:(NSString *)index password:(NSString *)password;

/**
 验证支付密码失败

 @param controller 收银台
 @param reason 失败原因
 @param code 失败 code
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyPwdPaymentPasswordFailed:(NSString *)reason code:(NSString *)code;

/**
 验证支付密码成功 - 开通付款码
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller
    verifyOpenPaymentPasswordSuccess:(NSString *)payerUsrToken
                               index:(NSString *)index
                            password:(NSString *)password
                                 key:(NSString *)authKey
                                 pwd:(NSString *)pwd;

/**
 验证支付密码成功 - 获取付款码
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyGetPaymentQRCodeSuccess:(NSDictionary *)rspData index:(NSString *)index password:(NSString *)password;

- (void)checkStandViewController:(PayHDCheckstandViewController *)controller merchantPwd:(NSString *)index password:(NSString *)password;

@end


@interface PayHDCheckstandViewController : UINavigationController <PayPayHDCheckstandBaseViewControllerDelegate>

+ (instancetype)checkStandWithBusinessPaymenModel:(PNPaymentReqModel *)businessPaymenModel
                                   preferedHeight:(CGFloat)preferedHeight
                                            style:(PayHDCheckstandViewControllerStyle)style
                                            title:(NSString *)title
                                           tipStr:(NSString *)tipStr;
- (instancetype)initWithBusinessPaymenModel:(PNPaymentReqModel *)businessPaymenModel
                             preferedHeight:(CGFloat)preferedHeight
                                      style:(PayHDCheckstandViewControllerStyle)style
                                      title:(NSString *)title
                                     tipStr:(NSString *)tipStr;

+ (instancetype)checkStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel preferedHeight:(CGFloat)preferedHeight;
- (instancetype)initWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel preferedHeight:(CGFloat)preferedHeight;

+ (instancetype)checkStandWithPreferedHeight:(CGFloat)preferedHeight style:(PayHDCheckstandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr;
- (instancetype)initWithPreferedHeight:(CGFloat)preferedHeight style:(PayHDCheckstandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr;

/// 支付密码输入-  支付业务【非校验】
+ (instancetype)pn_payCheckStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel;

/** 路由启动 */
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters;
@property (nonatomic, weak) id<PayHDCheckstandViewControllerDelegate> resultDelegate; ///< 代理

@property (assign, nonatomic) PayHDPresentVCAnimationStyle presentingStyle;
@property (assign, nonatomic) PayHDPresentVCAnimationStyle dismissStyle;
@property (nonatomic, assign) PayPayHDCheckstandTappedShadowAction tappedShadowAction; ///< 点击阴影的操作类型

@property (nonatomic, strong) PayHDCheckstandTextField *textField; ///< 密码输入框
@property (nonatomic, copy) void (^tappedShadowHandler)(void);     ///< 点击了阴影

@property (nonatomic, assign) BOOL showPaymentResult; ///< 是否显示结果页，在某些H5场景不需要显示原生的结果页，可以设置为false

/** 动画消失收银台 */
- (void)dismissViewControllerCompletion:(void (^__nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
