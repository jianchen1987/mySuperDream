//
//  SASelectableCouponTicketView.h
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponTicketModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASelectableCouponTicketView : SAView
/// 模型
@property (nonatomic, strong) SACouponTicketModel *model;
/// 点击了去使用
@property (nonatomic, copy) void (^clickedToUseBTNBlock)(void);

@end

NS_ASSUME_NONNULL_END
