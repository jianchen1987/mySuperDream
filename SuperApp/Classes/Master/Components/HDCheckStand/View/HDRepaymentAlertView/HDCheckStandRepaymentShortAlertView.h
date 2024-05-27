//
//  HDCheckStandRepaymentShortAlertView.h
//  SuperApp
//
//  Created by Tia on 2023/2/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDCheckStandRepaymentShortAlertView;


@interface HDCheckStandRepaymentShortAlertViewConfig : NSObject

/// 点击确认支付
@property (nonatomic, copy) void (^clickOnContinuePaymentHandler)(HDCheckStandRepaymentShortAlertView *alertView);
/// 点击等待支付结果
@property (nonatomic, copy) void (^clickOnWailtPaymentResultHandler)(HDCheckStandRepaymentShortAlertView *alertView);

@end


@interface HDCheckStandRepaymentShortAlertView : HDActionAlertView

@property (nonatomic, strong, readonly) HDCheckStandRepaymentShortAlertViewConfig *config; ///< 配置

+ (instancetype)alertViewWithConfig:(HDCheckStandRepaymentShortAlertViewConfig *__nullable)config;

@end

NS_ASSUME_NONNULL_END
