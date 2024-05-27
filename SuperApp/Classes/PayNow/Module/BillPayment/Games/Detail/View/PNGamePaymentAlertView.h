//
//  PNGamePaymentAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBalanceAndExchangeModel.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface PNGamePaymentAlertView : HDActionAlertView
/// 选择支付方式回调
@property (nonatomic, copy) void (^choosePaymentMethodCallBack)(BOOL isUseWalletPay);
///初始化
- (instancetype)initWithBalanceModel:(PNBalanceAndExchangeModel *)model;

@end

NS_ASSUME_NONNULL_END
