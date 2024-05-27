//
//  PNRecentItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNRecentBillListItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNRecentItemCell : PNCollectionViewCell

@property (nonatomic, strong) PNRecentBillListItemModel *itemModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) BOOL isLast;

@end

NS_ASSUME_NONNULL_END
