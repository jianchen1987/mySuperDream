//
//  TNNotificationConst.h
//  SuperApp
//
//  Created by 张杰 on 2020/12/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NSFoundationVersionNumber_iOS_9_x_Max
/// 通知
typedef NSString *NSNotificationName NS_EXTENSIBLE_STRING_ENUM;
#endif

NS_ASSUME_NONNULL_BEGIN
///砍价定时任务通知
FOUNDATION_EXPORT NSNotificationName const kNotificationNameBargainCountTime;
///发表评论成功通知
FOUNDATION_EXPORT NSNotificationName const kTNNotificationNamePostReviewSuccess;
///专题样式切换通知
FOUNDATION_EXPORT NSNotificationName const kTNNotificationNameChangedSpecialStyle;
/// 专题商品列表样式切换通知
FOUNDATION_EXPORT NSNotificationName const kTNNotificationNameChangedSpecialProductsListDispalyStyle;
NS_ASSUME_NONNULL_END

/// 本地存储key
typedef NSString *NSUserDefaultsKey NS_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN
///商品列表展示横向单个商品
FOUNDATION_EXPORT NSUserDefaultsKey const kNSUserDefaultsKeyShowHorizontalProductsStyle;
///专题新手指导是否已展示过
FOUNDATION_EXPORT NSUserDefaultsKey const kNSUserDefaultsKeySpecialNewFutureShowed;
NS_ASSUME_NONNULL_END
