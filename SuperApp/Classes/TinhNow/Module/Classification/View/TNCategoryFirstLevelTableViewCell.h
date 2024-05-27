//
//  TNCategoryFirstLevelTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TNFirstLevelCategoryModel;


@interface TNCategoryFirstLevelTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNFirstLevelCategoryModel *model;
@end

NS_ASSUME_NONNULL_END
