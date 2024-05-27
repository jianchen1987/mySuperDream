//
//  SAOrderRefundDetailProcessCell.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

@class SAOrderDetailRefundEventModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderRefundDetailProcessCell : SATableViewCell

/// 模型
@property (nonatomic, strong) SAOrderDetailRefundEventModel *model;

@end

NS_ASSUME_NONNULL_END
