//
//  TNOrderActionBarView.h
//  SuperApp
//
//  Created by seeu on 2020/7/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderActionBarView : TNView

/// 点击了取消
@property (nonatomic, copy) void (^cancelClicked)(void);
/// 点击了确认
@property (nonatomic, copy) void (^confirmClicked)(void);
/// 点击了自取
@property (nonatomic, copy) void (^paymentClicked)(void);
/// 点击了换货
@property (nonatomic, copy) void (^exchangeClicked)(void);
/// 点击了评论
@property (nonatomic, copy) void (^reviewClicked)(void);
/// 查看评论
@property (nonatomic, copy) void (^checkReviewClicked)(void);
/// 再次购买
@property (nonatomic, copy) void (^reBuyClicked)(void);
/// 申请退款
@property (nonatomic, copy) void (^applyRefundClicked)(void);
/// 取消退款
@property (nonatomic, copy) void (^cancelApplyRefundClicked)(void);
/// 转账付款
@property (nonatomic, copy) void (^transferPayClicked)(void);

/// 再来一单
@property (nonatomic, copy) void (^oneMoreClicked)(void);
/// 联系客服
@property (nonatomic, copy) void (^customerServiceClicked)(void);
/// 刷新状态
//@property (nonatomic, copy) void (^refreshClicked)(void);
@end

NS_ASSUME_NONNULL_END
