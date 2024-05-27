//
//  WMOrderSubmitPayFeeTrialCalRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单金额试算返回
@interface WMOrderSubmitPayFeeTrialCalRspModel : WMRspModel
/// 试算id
@property (nonatomic, copy) NSString *trialId;
/// 订单试算总价（实付金额）
@property (nonatomic, strong) SAMoneyModel *totalTrialPrice;
/// 订单应付金额（应付）
@property (nonatomic, strong) SAMoneyModel *payableMoney;
/// 币种
@property (nonatomic, copy) SACurrencyType currency;
@end

NS_ASSUME_NONNULL_END
