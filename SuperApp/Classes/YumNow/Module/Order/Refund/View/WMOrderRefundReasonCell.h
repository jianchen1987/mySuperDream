//
//  WMOrderRefundReasonCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMOrderRefundReasonCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderRefundReasonCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMOrderRefundReasonCellModel *model;
@end

NS_ASSUME_NONNULL_END
