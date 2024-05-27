//
//  SACouponTicketContainView.h
//  SuperApp
//
//  Created by Tia on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACouponTicketModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponTicketContainView : SAView
/// 模型
@property (nonatomic, strong) SACouponTicketModel *model;
/// 点击了去使用
@property (nonatomic, copy) dispatch_block_t clickedToUseBTNBlock;
/// 点击了查看详情
@property (nonatomic, copy) dispatch_block_t clickedViewDetailBlock;

@end

NS_ASSUME_NONNULL_END
