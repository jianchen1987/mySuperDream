//
//  TNInconmeAssetsView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  顶部资产视图

#import "SATableViewCell.h"
@class TNIncomeModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNInconmeAssetsCell : SATableViewCell
@property (strong, nonatomic) TNIncomeModel *incomeModel; ///< 收益模型
/// 提现点击回调
@property (nonatomic, copy) void (^withDrawClickCallBack)(void);
/// 预估收益点击回调
@property (nonatomic, copy) void (^preIncomeClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
