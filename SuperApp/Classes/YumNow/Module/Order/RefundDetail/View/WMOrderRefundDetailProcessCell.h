//
//  WMOrderRefundDetailProcessCell.h
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMOrderDetailRefundEventModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderRefundDetailProcessCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMOrderDetailRefundEventModel *model;
@end

NS_ASSUME_NONNULL_END
