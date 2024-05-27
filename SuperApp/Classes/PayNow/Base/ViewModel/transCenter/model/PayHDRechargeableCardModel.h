//
//  PayHDRechargeableCardModel.h
//  customer
//
//  Created by 谢 on 2019/1/22.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayHDRechargeableCardModel : HDJsonRspModel
@property (nonatomic, strong) NSNumber *amount;      // (integer, optional): 交易金额 ,
@property (nonatomic, copy) NSString *bizType;       // (string, optional): 账单分类 ,
@property (nonatomic, copy) NSString *channel;       // (string, optional): 充值渠道 ,
@property (nonatomic, strong) NSNumber *createTime;  // (string, optional): 创建时间 ,
@property (nonatomic, copy) NSString *currency;      //(string, optional): 交易币种 ,
@property (nonatomic, copy) NSString *outSourceCode; // (string, optional): 外部来源编号（VIPAY/PAYGO） ,
@property (nonatomic, copy) NSString *outTradeNo;    // (string, optional): 外部来源流水号（唯一） ,
@property (nonatomic, copy) NSString *tradeNo;       // (string, optional): 订单号 ,
@property (nonatomic, copy) NSString *tradeStatus;   // (string, optional)

@property (nonatomic, copy) NSString *mark;
@property (nonatomic, strong) NSNumber *amt;
@property (nonatomic, assign) PNTransType tradeType;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
