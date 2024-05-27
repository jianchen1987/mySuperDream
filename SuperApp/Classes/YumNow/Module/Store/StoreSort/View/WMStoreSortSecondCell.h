//
//  WMStoreSortSecondCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMCategoryItem.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMStoreSortSecondCell : SATableViewCell

@property (nonatomic, strong) WMCategoryItem *model;

@property (nonatomic, copy) void (^blockOnClickAll)(void);

@property (nonatomic, copy) void (^blockOnClickItem)(WMCategoryItem *item);

@end

NS_ASSUME_NONNULL_END
