//
//  NSDate+SAExtension.m
//  SuperApp
//
//  Created by VanJay on 2020/6/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "NSDate+SAExtension.h"

SADateWeekDayType const SADateWeekDayTypeSunDay = @"1";    ///< 星期天
SADateWeekDayType const SADateWeekDayTypeMonday = @"2";    ///< 星期一
SADateWeekDayType const SADateWeekDayTypeTuesDay = @"3";   ///< 星期二
SADateWeekDayType const SADateWeekDayTypeWednesday = @"4"; ///< 星期三
SADateWeekDayType const SADateWeekDayTypeThursday = @"5";  ///< 星期四
SADateWeekDayType const SADateWeekDayTypeFriday = @"6";    ///< 星期五
SADateWeekDayType const SADateWeekDayTypeSaturday = @"7";  ///< 星期六


@implementation NSDate (SAExtension)
- (BOOL)sa_isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

- (BOOL)sa_isYesterday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";

    // 生成只有年月日的字符串对象
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];

    // 生成只有年月日的日期对象
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (BOOL)sa_isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];

    return nowCmps.year == selfCmps.year;
}

- (BOOL)sa_isSameWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute;

    // 1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *sourceCmps = [calendar components:unit fromDate:self];

    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:[NSDate date] toDate:self options:0];
    NSInteger subDay = labs(dateCom.day);
    NSInteger subMonth = labs(dateCom.month);
    NSInteger subYear = labs(dateCom.year);

    if (subYear == 0 && subMonth == 0) { // 当相关的差值等于零的时候说明在一个年、月、日的时间范围内，不是按照零点到零点的时间算的
        if (subDay > 6) {                // 相差天数大于6肯定不在一周内
            return NO;
        } else {                                                                // 相差的天数大于或等于后面的时间所对应的weekday则不在一周内
            if (dateCom.day >= 0 && dateCom.hour >= 0 && dateCom.minute >= 0) { //比较的时间大于当前时间
                // 西方一周的开始是从周日开始算的，周日是1，周一是2，而我们是从周一开始算新的一周
                NSInteger chinaWeekday = sourceCmps.weekday == 1 ? 7 : sourceCmps.weekday - 1;
                if (subDay >= chinaWeekday) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                NSInteger chinaWeekday = sourceCmps.weekday == 1 ? 7 : nowCmps.weekday - 1;
                if (subDay >= chinaWeekday) { // 比较的时间比当前时间小，已经过去的时间
                    return NO;
                } else {
                    return YES;
                }
            }
        }
    } else { // 时间范围差值超过了一年或一个月的时间范围肯定就不在一个周内了
        return NO;
    }
}

- (BOOL)sa_isSameDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date];

    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}

- (SADateWeekDayType)sa_weekday {
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null],
                                                  SADateWeekDayTypeSunDay,
                                                  SADateWeekDayTypeMonday,
                                                  SADateWeekDayTypeTuesDay,
                                                  SADateWeekDayTypeWednesday,
                                                  SADateWeekDayTypeThursday,
                                                  SADateWeekDayTypeFriday,
                                                  SADateWeekDayTypeSaturday,
                                                  nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = NSTimeZone.localTimeZone;
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    return [weekdays objectAtIndex:theComponents.weekday];
}
- (NSString *)stringWithFormatStr:(NSString *)format {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:format];
    [formatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    return [formatter1 stringFromDate:self];
}

//获取N天后日期
+ (NSString *)getDate:(NSDate *)currentDate day:(NSInteger)day formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSInteger days = day;                 // n天后的天数
    NSDate *appointDate;                  // 指定日期声明
    NSTimeInterval oneDay = 24 * 60 * 60; // 一天一共有多少秒
    appointDate = [currentDate initWithTimeIntervalSinceNow:+(oneDay * days)];
    NSString *dateStr = [fmt stringFromDate:appointDate];
    return dateStr;
}

+ (NSTimeInterval)getTimeIntervalWithString:(NSString *)str formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 创建一个时间格式化对象
    [dateFormatter setDateFormat:formatter];
    //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];

    return [tempDate timeIntervalSince1970];
}

// 本地时间与其他时间对比，判断是否在固定时间区间内
+ (NSTimeInterval)overtime:(NSString *)serverTime format:(NSString *)format maxSecond:(CGFloat)maxSec {
    if (serverTime.length == 0 || maxSec < 0) {
        return 0;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //    fmt.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //    fmt.locale =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

    fmt.dateFormat = format;

    NSDate *serverDate = [fmt dateFromString:serverTime];
    //    NSInteger min = [[NSDate date] minutesAfterDate:serverDate];
    if (serverDate == nil) {
        return 0;
    }
    NSTimeInterval timeDiff = [serverDate timeIntervalSinceDate:NSDate.new];

    if (timeDiff < maxSec && timeDiff > 0) {
        return timeDiff;
    }
    return 0;
}

@end
