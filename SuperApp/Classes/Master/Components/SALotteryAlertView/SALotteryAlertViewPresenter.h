//
//  SALotteryAlertViewPresenter.h
//  SuperApp
//
//  Created by seeu on 2021/8/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SALotteryAlertViewPresenter : NSObject

/// 查询抽奖权益
/// @param orderNo 聚合订单号
/// @param completion 显示完毕
+ (void)showLotteryAlertViewWithOrderNo:(NSString *_Nonnull)orderNo completion:(void (^_Nullable)(void))completion;

- (instancetype)init __attribute__((unavailable("Use +showLotteryAlertViewWithOrganizer:completion: instead.")));

@end

NS_ASSUME_NONNULL_END
