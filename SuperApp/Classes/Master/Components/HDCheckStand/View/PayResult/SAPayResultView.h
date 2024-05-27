//
//  SAPayResultView.h
//  SuperApp
//
//  Created by Chaos on 2020/8/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAQueryPaymentStateRspModel;


@interface SAPayResultView : SAView

///< model
@property (nonatomic, strong) SAQueryPaymentStateRspModel *model;

/// 点击订单详情按钮回调
@property (nonatomic, copy) void (^orderDetailClicked)(void);

- (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
