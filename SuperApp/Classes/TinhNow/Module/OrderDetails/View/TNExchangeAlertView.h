//
//  TNExchangeAlertView.h
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNQueryExchangeOrderExplainRspModel;


@interface TNExchangeAlertView : TNView <HDCustomViewActionViewProtocol>
- (instancetype)initWithFrame:(CGRect)frame model:(TNQueryExchangeOrderExplainRspModel *)model;
@end

NS_ASSUME_NONNULL_END
