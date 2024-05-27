//
//  WMSortCollectionViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "WMCategoryItem.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMSortCollectionViewCell : SACollectionViewCell
@property (nonatomic, strong) WMCategoryItem *model;
@end

NS_ASSUME_NONNULL_END
