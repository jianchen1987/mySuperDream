//
//  TNIncomeModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeModel : TNModel
@property (strong, nonatomic) SAMoneyModel *totalAssetsMoney;             ///< 总资产
@property (strong, nonatomic) SAMoneyModel *commissionBalanceMoney;       ///< 可提现
@property (strong, nonatomic) SAMoneyModel *frozenCommissionBalanceMoney; ///< 预估收入
@property (strong, nonatomic) SAMoneyModel *partTimeCommissionMoney;      ///< 兼职收入
@property (nonatomic, assign) BOOL isExistWithdrawal;                     ///<  是否存在审核中的提现申请
@end

NS_ASSUME_NONNULL_END
