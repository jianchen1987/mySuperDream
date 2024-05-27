//
//  WMLadderRuleModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

@class SAMoneyModel, SAInternationalizationModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreLadderRuleModel : SAModel
///开始距离
@property (nonatomic, assign) NSInteger startDistance;
///结束距离
@property (nonatomic, assign) NSInteger endDistance;
///优惠比例
@property (nonatomic, assign) NSInteger preferentialRatio;
/// 币种
@property (nonatomic, copy) SACurrencyType currencyType;
/// 规则
@property (nonatomic, copy) NSString *ladderRuleNo;
/// 折扣金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
/// 门槛金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmt;
/// 是否是正在使用梯度，只有试算返回的梯度才有这个字段
@property (nonatomic, assign) BOOL inUse;

@end

NS_ASSUME_NONNULL_END
