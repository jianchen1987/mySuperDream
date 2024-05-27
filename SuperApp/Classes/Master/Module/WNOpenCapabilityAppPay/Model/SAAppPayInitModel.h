//
//  SAAppPayInitModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;


@interface SAAppPayInitModel : SACodingModel

@property (nonatomic, copy) NSString *merchantNo;   ///< 一级商户号
@property (nonatomic, copy) NSString *merchantName; ///< 商户名
@property (nonatomic, copy) NSString *merchantType; ///< 商户类型
@property (nonatomic, copy) NSString *merLogo;      ///< 商户logo

//@property (nonatomic, assign) SAPaymentState payState;        ///< 支付状态
//@property (nonatomic, copy) NSString *currency;               ///< 币种
@property (nonatomic, strong) SAMoneyModel *actualPayAmount; ///< 实付金额
@property (nonatomic, copy) NSString *outPayOrderNo;         ///< vipay支付流水
//@property (nonatomic, assign) NSTimeInterval createTime;      ///< 创建时间
@property (nonatomic, assign) NSUInteger expiredTime;              ///< 过期时间
@property (nonatomic, strong) SAInternationalizationModel *remark; ///< 备注
//@property (nonatomic, copy) NSString *payOrderNo;                   ///< 中台支付流水
@property (nonatomic, copy) NSString *businessLine; ///< 业务线
@property (nonatomic, copy) NSString *bizOrderNo;   ///< 外部订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;

@end

NS_ASSUME_NONNULL_END
