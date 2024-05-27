//
//  PNMSOrderListCell.h
//  SuperApp
//
//  Created by xixi on 2022/6/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMSBillListModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOrderListCell : PNTableViewCell
@property (nonatomic, strong) PNMSBillListModel *model;
@property (nonatomic, assign) BOOL isLastCell;
@end

NS_ASSUME_NONNULL_END
