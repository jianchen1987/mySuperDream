//
//  GNAlertUntils.h
//  SuperApp
//
//  Created by wmz on 2021/6/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNMultiLanguageManager.h"
#import "TNMultiLanguageManager.h"
#import "WMAlertCallPopView.h"
#import "WMEnum.h"
#import "WMMultiLanguageManager.h"
#import <Foundation/Foundation.h>
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GNAlertUntils : NSObject
///导航弹窗
/// @param name 导航终点的名字
/// @param lat lat
/// @param lon lon
+ (void)navigation:(NSString *)name lat:(double)lat lon:(double)lon;

///拨打电话
/// @param phone 电话
+ (void)callString:(NSString *)phone;

///拨打电话和客服电话
/// @param phone 电话
+ (void)callAndServerString:(NSString *)phone;

/// 通用打电话 自动携带telegram和客服热线
/// @param dataSource 二级展示类型 传入nil 则只有一级
/// @param info 其他携带的数据
+ (void)commonCallWithArray:(nullable NSArray<WMAlertCallPopModel *> *)dataSource info:(nullable NSDictionary *)info;

/// 打电话 一级为传入的dataSource
/// @param dataSource 展示的数据
+ (void)callWithModelArray:(nullable NSArray<WMAlertCallPopModel *> *)dataSource info:(nullable NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
