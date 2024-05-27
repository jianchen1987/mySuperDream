//
//  SACaculateNumberTool.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SANumRoundingMode) {
    SANumRoundingModeUpAndDown = 0, ///< 四舍五入
    SANumRoundingModeOnlyUp,        ///< 只入不舍
    SANumRoundingModeOnlyDown,      ///< 只舍不入
};

NS_ASSUME_NONNULL_BEGIN


@interface SACaculateNumberTool : NSObject

/**
 返回数字描述

 @param number 数字
 @param toFixed 保留小数位数
 @param roundingMode 是否四舍五入
 */
+ (NSString *)stringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode;

/**
 计算距离（米到米单位的转换）
 */
+ (NSString *)distanceStringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode;

/**
 团购计算距离（米到米单位的转换）
 */
+ (NSString *)gnDistanceStringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode;

@end

NS_ASSUME_NONNULL_END
