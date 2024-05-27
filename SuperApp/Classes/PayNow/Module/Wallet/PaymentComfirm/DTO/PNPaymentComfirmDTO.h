//
//  PNPaymentComfirmDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "PNModel.h"

@class PNPaymentComfirmRspModel;
@class PNPaymentResultRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentComfirmDTO : PNModel

// 确认支付币种汇兑信息
- (void)getTradePaymentInfo:(NSString *)tradeNo
                       type:(PNWalletBalanceType)type
                     payWay:(NSString *)payWay
                    success:(void (^_Nullable)(PNPaymentComfirmRspModel *rspModel))successBlock
                    failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询支付结果页
- (void)getPaymentResultWithTradeNo:(NSString *)tradeNo success:(void (^_Nullable)(PNPaymentResultRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

- (void)submitOrderParamsWithPaymentMethod:(HDCheckStandPaymentTools)payWay
                                   tradeNo:(NSString *)tradeNo
                           paymentCurrency:(NSInteger)paymentCurrency
                                   success:(void (^_Nullable)(HDCheckStandOrderSubmitParamsRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
