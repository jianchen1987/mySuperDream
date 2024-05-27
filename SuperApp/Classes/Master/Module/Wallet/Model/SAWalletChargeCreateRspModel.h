//
//  SAWalletChargeCreateRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletChargeCreateRspModel : SARspModel
/// 资金明细
@property (nonatomic, copy) NSString *fundDetailNo;
/// 交易订单号
@property (nonatomic, copy) NSString *tradeNo;
/// 产品ID
@property (nonatomic, copy) NSString *productId;
/// 业务订单号
@property (nonatomic, copy) NSString *outBizNo;
/// 支付链接
@property (nonatomic, copy) NSString *payUrl;
/// 预支付结果(11-处理中,13-预支付失败,15-订单已关闭)
@property (nonatomic, copy) NSString *status;
/// 失败原因
@property (nonatomic, copy) NSString *errorMsg;
@end

NS_ASSUME_NONNULL_END
