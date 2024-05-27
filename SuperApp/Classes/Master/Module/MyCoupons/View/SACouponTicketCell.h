//
//  SACouponTicketCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponTicketModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponTicketCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SACouponTicketModel *model;
/// 点击了去使用
@property (nonatomic, copy) void (^clickedToUseBTNBlock)(void);
/// 点击了查看详情
@property (nonatomic, copy) void (^clickedViewDetailBlock)(void);

@end

NS_ASSUME_NONNULL_END
