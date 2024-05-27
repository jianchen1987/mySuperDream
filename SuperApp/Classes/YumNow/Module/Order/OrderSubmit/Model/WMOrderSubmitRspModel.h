//
//  WMOrderSubmitRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SAMoneyModel;


@interface WMOrderSubmitRspModel : WMRspModel
/// 下单后返回的聚合订单号
@property (nonatomic, copy) NSString *orderNo;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *paymentAmount;
/// 支付订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 业务订单号
@property (nonatomic, copy) NSString *businessNo;
@end

NS_ASSUME_NONNULL_END
