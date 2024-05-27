//
//  GNCancelListTableVIewCell.h
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderCancelRspModel.h"
#import "GNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNCancelListTableVIewCell : GNTableViewCell
@property (nonatomic, strong) GNOrderCancelRspModel *model;
@end

NS_ASSUME_NONNULL_END
