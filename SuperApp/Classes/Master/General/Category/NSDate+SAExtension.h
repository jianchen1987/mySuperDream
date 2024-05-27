//
//  NSDate+SAExtension.h
//  SuperApp
//
//  Created by VanJay on 2020/6/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 星期几枚举
typedef NSString *SADateWeekDayType NS_STRING_ENUM;

FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeSunDay;    ///< 星期天
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeMonday;    ///< 星期一
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeTuesDay;   ///< 星期二
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeWednesday; ///< 星期三
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeThursday;  ///< 星期四
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeFriday;    ///< 星期五
FOUNDATION_EXPORT SADateWeekDayType const SADateWeekDayTypeSaturday;  ///< 星期六


@interface NSDate (SAExtension)

/// 是否今天
@property (nonatomic, assign, readonly) BOOL sa_isToday;

/// 是否昨天
@property (nonatomic, assign, readonly) BOOL sa_isYesterday;

/// 是否今年
@property (nonatomic, assign, readonly) BOOL sa_isThisYear;

/// 和今天是否在同一周
@property (nonatomic, assign, readonly) BOOL sa_isSameWeek;

/// 星期几
@property (nonatomic, copy, readonly) SADateWeekDayType sa_weekday;

/// 是否是同一天
/// @param date 需要比较的NSDate
- (BOOL)sa_isSameDay:(NSDate *)date;

/// 字符说明
/*
(:)

时间分隔符。在某些区域设置中，可以使用其他字符表示时间分隔符。时间分隔符在格式化时间值时分隔小时、分钟和秒。格式化输出中用作时间分隔符的实际字符由您的应用程序的当前区域性值确定。

(/)

日期分隔符。在某些区域设置中，可以使用其他字符表示日期分隔符。日期分隔符在格式化日期值时分隔日、月和年。格式化输出中用作日期分隔符的实际字符由您的应用程序的当前区域性确定。

(%)

用于表明不论尾随什么字母，随后字符都应该以单字母格式读取。也用于表明单字母格式应以用户定义格式读取。有关更多详细信息，请参见下面的内容。

d

将日显示为不带前导零的数字（如 1）。如果这是用户定义的数字格式中的唯一字符，请使用 %d。

dd

将日显示为带前导零的数字（如 01）。

EEE

将日显示为缩写形式（例如 Sun）。

EEEE

将日显示为全名（例如 Sunday）。

M

将月份显示为不带前导零的数字（如一月表示为 1）。如果这是用户定义的数字格式中的唯一字符，请使用 %M。

MM

将月份显示为带前导零的数字（例如 01/12/01）。

MMM

将月份显示为缩写形式（例如 Jan）。

MMMM

将月份显示为完整月份名（例如 January）。

gg

显示时代/纪元字符串（例如 A.D.）

h

使用 12 小时制将小时显示为不带前导零的数字（例如 1:15:15 PM）。如果这是用户定义的数字格式中的唯一字符，请使用 %h。

hh

使用 12 小时制将小时显示为带前导零的数字（例如 01:15:15 PM）。

H

使用 24 小时制将小时显示为不带前导零的数字（例如 1:15:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %H。

HH

使用 24 小时制将小时显示为带前导零的数字（例如 01:15:15）。

m

将分钟显示为不带前导零的数字（例如 12:1:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %m。

mm

将分钟显示为带前导零的数字（例如 12:01:15）。

s

将秒显示为不带前导零的数字（例如 12:15:5）。如果这是用户定义的数字格式中的唯一字符，请使用 %s。

ss

将秒显示为带前导零的数字（例如 12:15:05）。

f

显示秒的小数部分。例如，ff 将精确显示到百分之一秒，而 ffff 将精确显示到万分之一秒。用户定义格式中最多可使用七个 f 符号。如果这是用户定义的数字格式中的唯一字符，请使用 %f。

t

使用 12 小时制，并对中午之前的任一小时显示大写的 A，对中午到 11:59 P.M 之间的任一小时显示大写的 P。如果这是用户定义的数字格式中的唯一字符，请使用 %t。

tt

对于使用 12 小时制的区域设置，对中午之前任一小时显示大写的 AM，对中午到 11:59 P.M 之间的任一小时显示大写的 PM。

对于使用 24 小时制的区域设置，不显示任何字符。

y

将年份 (0-9) 显示为不带前导零的数字。如果这是用户定义的数字格式中的唯一字符，请使用 %y。

yy

以带前导零的两位数字格式显示年份（如果适用）。

yyy

以四位数字格式显示年份。

yyyy

以四位数字格式显示年份。

z

显示不带前导零的时区偏移量（如 -8）。如果这是用户定义的数字格式中的唯一字符，请使用 %z。

zz

显示带前导零的时区偏移量（例如 -08）

zzz

显示完整的时区偏移量（例如 -08:00）

 */
/// @param format 格式字符串
- (NSString *)stringWithFormatStr:(NSString *)format;

/// 获取某日期后的日期
/// @param currentDate 当前日期
/// @param day 后几天，负数为前几天
/// @param formatter 日期格式
+ (NSString *)getDate:(NSDate *)currentDate day:(NSInteger)day formatter:(NSString *)formatter;

/// 获取日期时间戳
/// @param str 日期字符串
/// @param formatter 日期格式
+ (NSTimeInterval)getTimeIntervalWithString:(NSString *)str formatter:(NSString *)formatter;

/// 本地时间与其他时间对比，返回时间差
/// @param serverTime 比较的时间
/// @param format 日期格式
/// @param maxSec 比较数
+ (NSTimeInterval)overtime:(NSString *)serverTime format:(NSString *)format maxSecond:(CGFloat)maxSec;
@end

NS_ASSUME_NONNULL_END
