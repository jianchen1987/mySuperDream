//
//  TNCategorySecondLevelTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNSecondLevelCategoryModel;


@interface TNCategorySecondLevelTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNSecondLevelCategoryModel *model;
/// 选中分类后回调
//@property (nonatomic, copy) void (^selectedCategoryHandler)(TNSecondLevelCategoryModel *secondLevelModel, TNCategoryModel *categoryModel);
@end

NS_ASSUME_NONNULL_END
