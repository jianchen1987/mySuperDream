//
//  TNNewIncomeIndexItemCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNNewIncomeRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNNewIncomeIndexItemCell : SATableViewCell
/// 默认展示 1已结算 2预估
@property (nonatomic, assign) NSInteger queryMode;
/// 最后一个圆角
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, strong) TNNewIncomeItemModel *model;

@end

NS_ASSUME_NONNULL_END
