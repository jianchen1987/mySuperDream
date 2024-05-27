//
//  TNIncomeFilterCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNIncomeListFilterModel;
@class TNIncomeCommissionSumModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeFilterCell : SATableViewCell
/// 筛选模型
@property (strong, nonatomic) TNIncomeListFilterModel *filterModel;
/// 收益统计
@property (strong, nonatomic) TNIncomeCommissionSumModel *sumModel;
/// 筛选回调
@property (nonatomic, copy) void (^filterClickCallBack)(TNIncomeListFilterModel *filterModel);
/// 展开收缩回调
@property (nonatomic, copy) void (^dropCellCallBack)(void);
@end

NS_ASSUME_NONNULL_END
