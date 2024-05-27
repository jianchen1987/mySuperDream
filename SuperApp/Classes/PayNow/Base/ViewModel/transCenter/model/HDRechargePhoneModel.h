//
//  HDRechargePhoneModel.h
//  customer
//
//  Created by 谢 on 2019/1/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDRechargePhoneModel : HDJsonRspModel

@property (nonatomic, strong) NSNumber *actualAmt;   // Money, optional): 实际到账金额 ,
@property (nonatomic, copy) NSString *cy;            // string, optional): 币种 = ['USD', 'KHR'],
@property (nonatomic, strong) NSNumber *discountAmt; // Money, optional): 折扣金额 ,
@property (nonatomic, strong) NSNumber *orderAmt;    // Money, optional): 订单金额 ,
@property (nonatomic, copy) NSString *orderNo;       // string, optional): 订单号 ,
@property (nonatomic, copy) NSString *rivalAreaOn;   // string, optional): 目标账号区域号 ,
@property (nonatomic, copy) NSString *rivalMp;       // string, optional): 目标用户账号（手机号） ,
@property (nonatomic, copy) NSString *service;       // string, optional): =运营商 ,
@property (nonatomic, copy) NSString *tradeNo;       // string, optional): 交易订单号 ,
@property (nonatomic, copy) NSString *voucherNo;     // string, optional): 凭证号

@end

NS_ASSUME_NONNULL_END
