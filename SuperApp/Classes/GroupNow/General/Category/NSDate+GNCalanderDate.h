//
//  NSDate+GNCalanderDate.h
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSDate (GNCalanderDate)
///  获取日
+ (NSInteger)day:(NSDate *)date;
/// 获取月
+ (NSInteger)month:(NSDate *)date;
/// 获取年
+ (NSInteger)year:(NSDate *)date;
/// 获取当月第一天周几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
///获取当前月有多少天
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/// 是否属于同一天判断
+ (BOOL)isInSameDay:(NSDate *)date1 time2:(NSDate *)date2;
/// 比较两个时间的大小
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
/// 根据日期获取周几
+ (NSString *)weekdayStringWithDate:(NSDate *)date;
///  与当前时间相差几天
+ (NSInteger)getDifferenceByDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
