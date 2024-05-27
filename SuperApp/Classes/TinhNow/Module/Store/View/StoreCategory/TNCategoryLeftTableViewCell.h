//
//  TNCategoryLeftTableViewCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNFirstLevelCategoryModel;


@interface TNCategoryLeftTableViewCell : SATableViewCell
/// 模型数据
@property (strong, nonatomic) TNFirstLevelCategoryModel *model;
@end

NS_ASSUME_NONNULL_END
