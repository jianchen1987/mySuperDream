//
//  SAPaymentDetailsRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"

@class SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentDetailsRspModel : SACodingModel

//@property (nonatomic, assign) SAPaymentState payState;        ///< 支付状态
@property (nonatomic, copy) NSString *currency;              ///< 币种
@property (nonatomic, strong) SAMoneyModel *actualPayAmount; ///< 实付金额
@property (nonatomic, copy) NSString *outPayOrderNo;         ///< vipay支付流水
@property (nonatomic, assign) NSTimeInterval createTime;     ///< 创建时间
//@property (nonatomic, assign) NSUInteger expiredTime;         ///< 过期时间
@property (nonatomic, strong) SAInternationalizationModel *remark; ///< 备注
@property (nonatomic, copy) NSString *payOrderNo;                  ///< 中台支付流水
@property (nonatomic, copy) NSString *businessLine;                ///< 业务线
@property (nonatomic, copy) NSString *bizOrderNo;                  ///< 外部订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;            ///< 聚合订单号
///< 二级商户号
@property (nonatomic, copy) NSString *merchantNo;
@end

NS_ASSUME_NONNULL_END
