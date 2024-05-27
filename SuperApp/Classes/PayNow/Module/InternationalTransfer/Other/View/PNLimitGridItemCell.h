//
//  PNLimitGridItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNGrideItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNLimitGridItemCell : PNCollectionViewCell
@property (nonatomic, copy) PNGrideItemModel *model;
@end

NS_ASSUME_NONNULL_END
