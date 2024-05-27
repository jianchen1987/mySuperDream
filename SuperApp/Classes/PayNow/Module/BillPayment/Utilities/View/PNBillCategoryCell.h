//
//  PNBillCategoryCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNBillCategoryItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNBillCategoryCell : PNCollectionViewCell
@property (nonatomic, strong) PNBillCategoryItemModel *model;
@property (nonatomic, strong) UIView *bgView;

@end

NS_ASSUME_NONNULL_END
