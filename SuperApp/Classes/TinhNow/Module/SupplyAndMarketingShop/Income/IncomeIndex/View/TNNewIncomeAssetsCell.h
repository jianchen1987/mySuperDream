//
//  TNNewIncomeAssetsCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNNewProfitIncomeModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeAssetsCell : SATableViewCell
@property (strong, nonatomic) TNNewProfitIncomeModel *incomeModel; ///< 收益模型
/// 默认展示 1已结算 2预估
@property (nonatomic, assign) NSInteger queryMode;
///  已结算  预估切换
@property (nonatomic, copy) void (^settledAndPreIncomeToggleCallBack)(NSInteger queryMode);
@end

NS_ASSUME_NONNULL_END
