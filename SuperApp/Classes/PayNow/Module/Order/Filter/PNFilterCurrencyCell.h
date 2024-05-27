//
//  PNFilterCurrencyCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNBillFilterModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNFilterCurrencyCell : PNCollectionViewCell

@property (nonatomic, strong) PNBillFilterModel *model;

@end

NS_ASSUME_NONNULL_END
