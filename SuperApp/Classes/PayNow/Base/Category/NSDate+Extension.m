//
//  NSDate+Extension.m
//  National Wallet
//
//  Created by 谢 on 2018/5/19.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#define D_MINUTE 60
#define D_HOUR 3600
#define D_DAY 86400
#define D_WEEK 604800
#define D_YEAR 31556926

#define DATE_COMPONENTS                                                                                                                                                                 \
    (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday \
     | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#import "NSDate+Extension.h"


@implementation NSDate (Extension)
+ (NSString *)dateSecondToDate:(NSInteger)Second DateFormat:(NSString *)Format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:Format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    NSTimeZone *timeZone = NSTimeZone.localTimeZone; // [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:Second];

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

- (NSString *)dateFormat:(NSString *)Format {
    // NSDateFormatter实例
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    // NSDateFormatter格式化
    [form setDateFormat:Format];
    NSString *str = [form stringFromDate:self];

    return str;
}

+ (NSInteger)dateString:(NSString *)DateString DateFormat:(NSString *)Format {
    // NSDateFormatter实例
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    // NSDateFormatter格式化
    [form setDateFormat:Format];
    NSDate *date = [form dateFromString:DateString];
    NSInteger count = [date timeIntervalSince1970];
    return count;
}

+ (NSInteger)dateStringddMMyyyyHHmmss:(NSString *)dateString {
    // NSDateFormatter实例
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    // NSDateFormatter格式化
    [form setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    form.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];

    NSDate *date = [form dateFromString:dateString];
    NSInteger count = [date timeIntervalSince1970];
    return count;
}

+ (NSInteger)ddMMYYYY:(NSString *)date {
    if (!date.length) {
        return 0;
    }
    NSString *day = [date substringWithRange:NSMakeRange(0, 2)];
    NSString *mouth = [date substringWithRange:NSMakeRange(3, 2)];
    NSString *year = [date substringWithRange:NSMakeRange(6, 4)];
    return [NSDate dateString:[NSString stringWithFormat:@"%@-%@-%@", year, mouth, day] DateFormat:@"YYYY-MM-dd"];
}

+ (NSInteger)ddMMYYYYHHmmss:(NSString *)date {
    if (!date.length) {
        return 0;
    }
    NSString *day = [date substringWithRange:NSMakeRange(0, 2)];
    NSString *mouth = [date substringWithRange:NSMakeRange(3, 2)];
    NSString *year = [date substringWithRange:NSMakeRange(6, 4)];
    return [NSDate dateString:[NSString stringWithFormat:@"%@-%@-%@", year, mouth, day] DateFormat:@"YYYY-MM-dd HH:mm:ss"];
}

+ (NSString *)ddMMYYYYString:(NSDate *)date {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyyMMdd"];
    [fm setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = [fm stringFromDate:date];

    NSString *day = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *mouth = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString *year = [dateString substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@", year, mouth, day];
}

+ (NSInteger)MMYYYY:(NSString *)date {
    if (!date.length) {
        return 0;
    }
    NSString *mouth = [date substringWithRange:NSMakeRange(0, 2)];
    NSString *year = [date substringWithRange:NSMakeRange(3, 4)];
    return [NSDate dateString:[NSString stringWithFormat:@"%@-%@", year, mouth] DateFormat:@"YYYY-MM"];
}

+ (NSDate *)numberMouthAfter:(NSInteger)number {
    return [self afterDateYear:0 Mouth:number Day:0 Date:[NSDate date]];
}

+ (NSDate *)numberYearAfter:(NSInteger)number {
    return [self afterDateYear:number Mouth:0 Day:0 Date:[NSDate date]];
}

+ (NSDate *)afterDateYear:(NSInteger)year Mouth:(NSInteger)Mouth Day:(NSInteger)day Date:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:DATE_COMPONENTS fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:Mouth];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+ (NSDate *)numberWeekAfter:(NSInteger)number {
    return [self afterDateYear:0 Mouth:0 Day:number * 7 Date:[NSDate date]];
}

+ (NSDate *)numberDayAfter:(NSInteger)number {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    NSTimeInterval oneDay = D_DAY * number; // 1天的长度
    if (number > 0) {
        theDate = [nowDate initWithTimeIntervalSinceNow:+oneDay * number];
    } else {
        theDate = [nowDate initWithTimeIntervalSinceNow:-oneDay * number];
    }
    return theDate;
}

#pragma mark Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)seconds {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)day {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)month {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)week {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekday {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)year {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

- (NSInteger)timeStamp {
    return [self timeIntervalSince1970];
}
@end
