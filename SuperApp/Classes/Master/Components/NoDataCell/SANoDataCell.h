//
//  SANoDataCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANoDataCellModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SANoDataCell : SATableViewCell
@property (nonatomic, strong) SANoDataCellModel *model; ///< 模型
/// 底部按钮事件
@property (nonatomic, copy) void (^BlockOnClockBottomBtn)(void);
@end

NS_ASSUME_NONNULL_END
