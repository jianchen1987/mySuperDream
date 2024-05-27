//
//  NSDate+Extension.h
//  National Wallet
//
//  Created by 谢 on 2018/5/19.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Extension)
+ (NSInteger)ddMMYYYY:(NSString *)date;
+ (NSInteger)ddMMYYYYHHmmss:(NSString *)date;

+ (NSString *)ddMMYYYYString:(NSDate *)date;
/**
 秒数转时间
 @param Second 秒数
 @param Format 时间格式
 @return YYYY-MM-dd HH:mm:ss和YYYY-MM-dd hh:mm:ss的区别
 */
+ (NSString *)dateSecondToDate:(NSInteger)Second DateFormat:(NSString *)Format;
/**
 日期类型转换为想要的格式
 @param Format  时间格式
 */
- (NSString *)dateFormat:(NSString *)Format;
// 时间字符串转时间戳
+ (NSInteger)dateString:(NSString *)DateString DateFormat:(NSString *)Format;
// 时间字符串转时间戳 (固定时间格式)
+ (NSInteger)dateStringddMMyyyyHHmmss:(NSString *)dateString;
/**
 月年
 @param date 日期

 */
+ (NSInteger)MMYYYY:(NSString *)date;

/**
 一天之后日期
 */
+ (NSDate *)numberDayAfter:(NSInteger)number;

/**
 几个星期之后
 */
+ (NSDate *)numberWeekAfter:(NSInteger)number;
+ (NSDate *)numberMouthAfter:(NSInteger)number;
+ (NSDate *)numberYearAfter:(NSInteger)number;

/**
 前后年月日多少 返回日期
 */
+ (NSDate *)afterDateYear:(NSInteger)year Mouth:(NSInteger)Mouth Day:(NSInteger)day Date:(NSDate *)date;

#pragma mark Retrieving intervals 两个日期相隔的时间差
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
//- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

#pragma mark Decomposing dates（Get current date）分解日期（获得当前指定时间）
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger timeStamp;  // 时间戳
@property (readonly) NSInteger year;
@end
