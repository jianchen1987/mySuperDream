//
//  PNExchangeRateModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNExchangeRateModel : PNModel
/// 美元兑ruier
@property (nonatomic, strong) NSNumber *usdBuyKhr;
/// 央行
@property (nonatomic, strong) NSNumber *bankSugPrice;
/// 瑞尔兑美元
@property (nonatomic, strong) NSNumber *khrBuyUsd;

@property (nonatomic, copy) NSString *exchangeDate;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
