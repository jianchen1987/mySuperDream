//
//  HDCheckStandPresenter.h
//  SuperApp
//
//  Created by Tia on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandViewController.h"
#import <Foundation/Foundation.h>

@class HDTradeBuildOrderModel;

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandPresenter : NSObject

/// 判断是否重复支付拉起收银台在线支付结果页
/// @param model 支付订单model
/// @param preferedHeight 高度
/// @param viewController 拉起收银台的vc
/// @param delegate 收银台代理回调
+ (void)payWithTradeBuildModel:(HDTradeBuildOrderModel *)model preferedHeight:(CGFloat)preferedHeight fromViewController:(UIViewController *)viewController delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
