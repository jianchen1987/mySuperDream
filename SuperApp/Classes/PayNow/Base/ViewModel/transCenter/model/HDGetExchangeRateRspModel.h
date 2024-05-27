//
//  HDGetExchangeRateRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/20.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"


@interface HDGetExchangeRateRspModel : HDJsonRspModel

@property (nonatomic, strong) NSNumber *bankSugPrice;
@property (nonatomic, strong) NSNumber *khrBuyUsd;
@property (nonatomic, strong) NSNumber *usdBuyKhr;
@property (nonatomic, copy) NSString *exchangeDate;
@property (nonatomic, copy) NSString *updateTime;
@end
