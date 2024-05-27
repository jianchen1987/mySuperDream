//
//  HDCheckStandRepaymentAlertView.h
//  SuperApp
//
//  Created by seeu on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDCheckStandRepaymentAlertView;


@interface HDCheckStandRepaymentAlertViewConfig : NSObject

/// 点击确认支付
@property (nonatomic, copy) void (^clickOnContinuePaymentHandler)(HDCheckStandRepaymentAlertView *alertView);
/// 点击等待支付结果
@property (nonatomic, copy) void (^clickOnWailtPaymentResultHandler)(HDCheckStandRepaymentAlertView *alertView);
/// 点击联系客服
@property (nonatomic, copy) void (^clickOnServiceHandler)(HDCheckStandRepaymentAlertView *alertView);

@end


@interface HDCheckStandRepaymentAlertView : HDActionAlertView

@property (nonatomic, strong, readonly) HDCheckStandRepaymentAlertViewConfig *config; ///< 配置

+ (instancetype)alertViewWithConfig:(HDCheckStandRepaymentAlertViewConfig *__nullable)config;

@end

NS_ASSUME_NONNULL_END
