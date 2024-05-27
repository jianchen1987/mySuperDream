//
//  PayHDTradeConfirmPaymentRspModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 确认支付返回模型
 */
@interface PayHDTradeConfirmPaymentRspModel : HDJsonRspModel
@property (nonatomic, copy) NSString *tradeNo;   ///< 订单号
@property (nonatomic, copy) NSString *voucherNo; ///< 凭证号
@property (nonatomic, copy) NSString *outBizNo;  ///< 外部订单号

/// 提现
/// 业务单号
@property (nonatomic, copy) NSString *orderNo;
/// 凭证号
@property (nonatomic, copy) NSString *cashVoucherNo;
@end

NS_ASSUME_NONNULL_END
