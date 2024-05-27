//
//  PayHDCheckstandBaseViewController.h
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAppTheme.h"
#import "PNUtilMacro.h"
#import "PayHDCheckStandCustomNavBarView.h"
#import "PayHDCheckstandViewModel.h"
#import "SAViewController.h"
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

/** 订单超时支付的最后操作 */
typedef NS_ENUM(NSInteger, PayHDCheckstandPaymentOverTimeEndActionType) {
    PayHDCheckstandPaymentOverTimeEndActionTypeConfirm = 0,        ///< 确认订单页面
    PayHDCheckstandPaymentOverTimeEndActionTypeChoosePreferential, ///< 选择优惠方式
    PayHDCheckstandPaymentOverTimeEndActionTypeChoosePayMethod,    ///< 选择支付方式
    PayHDCheckstandPaymentOverTimeEndActionTypeInputPassword       ///< 输入交易密码页面
};

/** 收银台风格 */
typedef NS_ENUM(NSInteger, PayHDCheckstandViewControllerStyle) {
    PayHDCheckstandViewControllerStyleDefault = 0,            ///< 收银台
    PayHDCheckstandViewControllerStylePay = 1,                ///< 支付
    PayHDCheckstandViewControllerStyleVerifyPwd = 2,          ///< 验证支付密码
    PayHDCheckstandViewControllerStyleOpenPayment = 3,        ///< 开通付款码 功能
    PayHDCheckstandViewControllerStyleGetPaymentCode = 4,     ///< 生成付款二维码
    PayHDCheckstandViewControllerStyleMerchantServicePwd = 5, ///< 商户交易密码校验
};

@class PayHDCheckstandBaseViewController;
@class PayHDCheckstandTextField;

NS_ASSUME_NONNULL_BEGIN

@protocol PayPayHDCheckstandBaseViewControllerDelegate <NSObject>

@optional
- (void)checkStandBaseViewControllerDidShown:(PayHDCheckstandBaseViewController *)controller;
- (void)checkStandBaseViewController:(PayHDCheckstandBaseViewController *)controller paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel;
- (void)checkStandBaseViewController:(PayHDCheckstandBaseViewController *)controller transactionFailure:(NSString *)reason code:(NSString *)code;
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo;
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller completedInputPassword:(PayHDCheckstandTextField *)textField;
- (void)checkStandViewBaseControllerPaymentOverTime:(PayHDCheckstandBaseViewController *)controller endActionType:(PayHDCheckstandPaymentOverTimeEndActionType)type;

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewBaseControllerUserClosedCheckStand:(PayHDCheckstandBaseViewController *)controller;

/**
 验证支付密码成功

 @param controller 收银台
 @param token 凭证
 @param index 加密因子
 @param password 加密后的密码
 */
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyPwdPaymentPasswordSuccess:(NSString *)token index:(NSString *)index password:(NSString *)password;

/**
 验证支付密码失败

 @param controller 收银台
 @param reason 失败原因
 @param code 失败 code
 */
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyPwdPaymentPasswordFailed:(NSString *)reason code:(NSString *)code;

/**
 验证支付密码成功 - 开通付款码
 */
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller
    verifyOpenPaymentPasswordSuccess:(NSString *)payerUsrToken
                               index:(NSString *)index
                            password:(NSString *)password
                             authKey:(NSString *)authKey
                                 pwd:(NSString *)pwd;

/**
 验证支付密码成功 - 获取付款码
 */
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller verifyGetPaymentQRCodeSuccess:(NSDictionary *)rspData index:(NSString *)index password:(NSString *)password;

/// 商户交易密码
- (void)checkStandViewBaseController:(PayHDCheckstandBaseViewController *)controller merchantPwd:(NSString *)index password:(NSString *)password;

@end


@interface PayHDCheckstandBaseViewController : SAViewController
@property (nonatomic, strong) UIView *containerView;                         ///< 容器
@property (nonatomic, strong) PayHDCheckstandViewModel *checkStandViewModel; ///< ViewModel
@property (nonatomic, copy) NSString *tradeNo;                               ///< 订单号
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;
@property (nonatomic, weak) id<PayPayHDCheckstandBaseViewControllerDelegate> delegate; ///< 代理
@property (nonatomic, strong) PayHDCheckstandCustomNavBarView *navBarView;             ///<  导航栏
@property (nonatomic, assign) PayHDCheckstandViewControllerStyle style;                ///< 风格

- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType;
- (void)setTitleBtnImage:(NSString *__nullable)imageName title:(NSString *__nullable)title font:(UIFont *__nullable)font;
/**
 动画隐藏界面并 dismiss 收银台，调用关闭订单接口
 */
- (void)hideContainerViewAndDismissCheckStand;
- (void)hideContainerViewAndDismissCheckStandFinshed:(void (^__nullable)(void))finishedHandler;
/**
 动画隐藏界面并 dismiss 收银台，不调用关闭订单接口
 */
- (void)hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:(void (^__nullable)(void))finishedHandler;
/** 关闭订单 */
- (void)closePaymentFinshed:(void (^)(void))finished;
@end

NS_ASSUME_NONNULL_END
