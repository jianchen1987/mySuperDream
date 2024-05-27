//
//  UIDevice+Extension.h
//  ViPay
//
//  Created by VanJay on 2019/8/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (Extension)

/**  唯一标识 */
+ (NSString *)uniqueIdentifier;

+ (NSString *)IDFA;

/** 获取IDFV */
+ (NSString *)IDFV;

/** 获取UUID */
+ (NSString *)UUID;

/** 获取设备型号 */
+ (NSString *)model;

/** 获取设备名 */
+ (NSString *)name;

/** 获取设备系统版本号 */
+ (NSString *)systemVersion;

/** 获取设备屏幕宽高比 */
+ (NSString *)WxH;

/** 获取设备屏幕密度 */
+ (NSString *)density;

/** 获取设备总内存大小 */
+ (NSString *)totalMemory;

/** 获取设备语言 */
+ (NSString *)language;

/** 获取设备地区 */
+ (NSString *)region;

/** 获取电池状态 */
+ (NSString *)batteryState;

/** 获取电池电量水平 */
+ (NSString *)batteryLevel;

/** 获取磁盘总大小 */
+ (NSString *)totalDisk;

/** 获取运营商信息 */
+ (NSString *)networkBrand;

@end
