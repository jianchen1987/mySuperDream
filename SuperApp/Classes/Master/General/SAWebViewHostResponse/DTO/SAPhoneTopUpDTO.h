//
//  SAPhoneTopUpDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/7/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

@class SAMoneyModel;
@class WMOrderSubmitRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAPhoneTopUpDTO : SAModel

/// 话费充值下单
/// @param paymentType 支付方式
/// @param amountModel 金额对象
/// @param topUpNumber 充值手机号
/// @param merchantNo 商户号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitPhoneTopUpOrderWithPaymentType:(SAOrderPaymentType)paymentType
                                 amountModel:(SAMoneyModel *)amountModel
                                 topUpNumber:(NSString *)topUpNumber
                                  merchantNo:(NSString *)merchantNo
                                     success:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
