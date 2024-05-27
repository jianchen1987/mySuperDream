//
//  SACouponRedemptionCell.h
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class SACouponTicketModel;


@interface SACouponRedemptionCell : SATableViewCell

@property (nonatomic, strong) SACouponTicketModel *model;

/// 点击了展开或关闭详情
@property (nonatomic, copy) void (^clickViewDetailBlock)(SACouponRedemptionCell *cell, SACouponTicketModel *model);
/// 点击立即使用
@property (nonatomic, copy) void (^clickUseNowBlock)(SACouponTicketModel *model);

@end

NS_ASSUME_NONNULL_END
