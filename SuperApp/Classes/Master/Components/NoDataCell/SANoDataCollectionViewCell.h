//
//  SANoDataCollectionViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SANoDataCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SANoDataCollectionViewCell : SACollectionViewCell
@property (nonatomic, strong) SANoDataCellModel *model; ///< 模型
/// 底部按钮事件
@property (nonatomic, copy) void (^BlockOnClockBottomBtn)(void);
@end

NS_ASSUME_NONNULL_END
