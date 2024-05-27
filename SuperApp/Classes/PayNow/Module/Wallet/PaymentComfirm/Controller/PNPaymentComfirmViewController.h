//
//  PNPaymentComfirmViewController.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentBuildModel.h"
#import "PNViewController.h"

@class PNPaymentComfirmViewController;
@class PayHDTradeSubmitPaymentRspModel;

NS_ASSUME_NONNULL_BEGIN

@protocol PNPaymentComfirmViewControllerDelegate <NSObject>

@optional
/// 支付成功的回调
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller;

/// 支付失败的回调
- (void)paymentFaild:(NSString *)errorCode message:(NSString *)message tradeNo:(NSString *)tradeNo controller:(PNPaymentComfirmViewController *)controller;

/// 主动点击了返回
- (void)userGoBack:(PNPaymentComfirmViewController *)controller;
@end


@interface PNPaymentComfirmViewController : PNViewController

@property (nonatomic, weak) id<PNPaymentComfirmViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
