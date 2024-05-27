//
//  PNFilterDateCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNMSBillFilterModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelctDateBlock)(NSString *selectDate);


@interface PNMSFilterDateCell : PNCollectionViewCell

@property (nonatomic, strong) PNMSBillFilterModel *model;

@property (nonatomic, copy) SelctDateBlock selectDateBlock;

@end

NS_ASSUME_NONNULL_END
