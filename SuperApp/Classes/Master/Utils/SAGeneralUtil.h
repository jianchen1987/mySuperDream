//
//  SAGeneralUtil.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import "SAWalletEnum.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAGeneralUtil : NSObject
/**
获取16位随机数

@return 随机数
*/
+ (NSString *)getRandomKey;

/**
 按格式返回当前时间字符串

 @param format 时间格式
 @return 时间字符串
 */
+ (NSString *)getCurrentDateStrByFormat:(NSString *)format;

/**
按格式返回当前时间字符串

@param date 日期
@param format 时间格式
@return 时间字符串
*/
+ (NSString *)getDateStrWithDate:(NSDate *)date format:(NSString *)format;

/**
时间戳转时间
@param timeInterval 时间戳
@param format 时间格式
@return 时间字符串
*/
+ (NSString *)getDateStrWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

/**
时间戳转时间
@param timeInterval 时间戳
@param format 时间格式
@param dateInTodayFormat 如果是当天，显示的时间格式
@return 时间字符串
*/
+ (NSString *)getDateStrWithTimeInterval:(NSInteger)timeInterval dateFormat:(NSString *)format dateInTodayFormat:(NSString *)dateInTodayFormat;

/**
获取某年某月天数

@param month 月份
@param year 年份
@return 天数
*/
+ (NSInteger)getDaysForMonth:(NSInteger)month inYear:(NSInteger)year;

/// 从16位随机随机数获取真实的因子
/// @param randomKey 随机数
+ (NSString *)getRealRandomKeyWithRandomKey:(NSString *)randomKey;

/// 从完整的账号中获取国家代码，如果不包含将返回 nil
/// @param fullAccountNo 帐号
+ (NSString *_Nullable)getCountryCodeFromFullAccountNo:(NSString *)fullAccountNo;

/// 从完整的账号中获取帐号（剔除国家代码的账号），如果不包含将返回原帐号
/// @param fullAccountNo 帐号
+ (NSString *_Nullable)getShortAccountNoFromFullAccountNo:(NSString *)fullAccountNo;

/// 获取目标时间与当前的时间间隔
/// @param date 目标时间
+ (NSInteger)getDiffValueUntilNowForDate:(NSDate *)date;

/// 消息通知是否打开
+ (BOOL)isNotificationEnable;

/**
通过交易类型代码获取交易类型名称

@param code 代码
@return 名称
*/
+ (NSString *)getTradeTypeNameByCode:(HDWalletTransType)code;

/// 根据钱包支付类型获取描述
/// @param paymethod 支付类型
+ (NSString *)getWalletPaymethodDescWithPaymethod:(HDWalletPaymethod)paymethod;

/// 转换枚举值为描述
/// @param paymentStatus 支付状态枚举
+ (NSString *)getPaymentStatusDescWithEnum:(SAPaymentState)paymentStatus;

+ (NSString *)getRefundStatusDescWithEnum:(SARefundState)refundStatus;

/// 转换枚举值为描述
/// @param operationType 退单状态枚举
+ (NSString *)getRefundOperationDescWithEnum:(SARefundOperationType)operationType;

+ (NSString *)getRefundSourceDescWithEnum:(SARefundSource)refundSource;

/// 根据 date 返回星期几
/// @param date 日期
+ (NSString *)getDayStringWithDate:(NSDate *)date;

/// 根据一个星期的第几天返回星期几
/// @param weekdayIndex 第几天
+ (NSString *)getDayStringWithDateWeekdayIndex:(NSUInteger)weekdayIndex;

/// 合成目标图到背景图中间
/// @param aboveImage 目标图
/// @param bgImage 背景图
+ (UIImage *)mergeImage:(UIImage *)aboveImage onBackgroundImageCenter:(UIImage *)bgImage;

/**
 秒数转时间
 @param seconds 秒数
 @return xx:xx:xx
 */
+ (NSString *)timeWithSeconds:(NSInteger)seconds;

/// 等待支付时间转换
/// @param seconds 秒
+ (NSString *)waitPayTimeWithSeconds:(NSInteger)seconds;

/// 设备信息
+ (NSString *)getDeviceInfo;

+ (NSString *)getAggregateOrderStateWithCode:(SAAggregateOrderState)code;
+ (NSString *)getAggregateOrderFinalStateWithCode:(SAAggregateOrderFinalState)code;

@end

NS_ASSUME_NONNULL_END
