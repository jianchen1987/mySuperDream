//
//  WMOrderDetailTrackingTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMOrderDetailTrackingTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailTrackingTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMOrderDetailTrackingTableViewCellModel *model;
@end

NS_ASSUME_NONNULL_END
