//
//  TNRefundDetailsItemCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNRefundDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundDetailsItemCellModel : NSObject
///
@property (nonatomic, strong) TNRefundDetailsItemsModel *model;
@end


@interface TNRefundDetailsItemCell : SATableViewCell
///
@property (nonatomic, strong) TNRefundDetailsItemsModel *itemModel;
@end

NS_ASSUME_NONNULL_END
