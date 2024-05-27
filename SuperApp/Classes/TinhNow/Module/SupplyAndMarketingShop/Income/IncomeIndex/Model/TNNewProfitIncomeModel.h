//
//  TNNewProfitIncomeModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNewProfitIncomeModel : TNModel
/// 已结算金额
@property (strong, nonatomic) SAMoneyModel *settlementBalance;
/// 预估收入金额
@property (strong, nonatomic) SAMoneyModel *frozenCommissionBalance;
@end

NS_ASSUME_NONNULL_END
