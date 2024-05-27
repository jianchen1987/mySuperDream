//
//  SAChooseActivityAlertView.h
//  SuperApp
//
//  Created by seeu on 2022/5/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import <HDUIkit/HDCustomViewActionView.h>

@class SAPaymentActivityModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAChooseActivityAlertView : SAView <HDCustomViewActionViewProtocol>

///< data
@property (nonatomic, strong) NSArray<SAPaymentActivityModel *> *data;
///< 当前选中的活动
@property (nonatomic, strong) SAPaymentActivityModel *currentActivity;

/// 选择了某个活动
@property (nonatomic, copy) void (^clickedActivity)(SAPaymentActivityModel *_Nullable activity);

@end

NS_ASSUME_NONNULL_END
