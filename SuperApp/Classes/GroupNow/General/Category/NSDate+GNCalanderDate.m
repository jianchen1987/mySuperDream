//
//  NSDate+GNCalanderDate.m
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "NSDate+GNCalanderDate.h"


@implementation NSDate (GNCalanderDate)

+ (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.day;
}

+ (NSInteger)month:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.month;
}

+ (NSInteger)year:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.year;
}

+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    } else if (result == NSOrderedAscending) {
        return -1;
    }
    return 0;
}

+ (BOOL)isInSameDay:(NSDate *)date1 time2:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    NSDateComponents *nowCmps = [calendar components:unit fromDate:date1];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date2];

    return nowCmps.day == selfCmps.day && nowCmps.month == selfCmps.month && nowCmps.year == selfCmps.year;
}

+ (NSString *)weekdayStringWithDate:(NSDate *)date {
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    NSArray *weekArray = @[@"SUNDAY", @"MONDAY", @"TUESDAY", @"WEDNESDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY"];
    NSString *weekStr = weekArray[weekday - 1];
    return weekStr;
}

+ (NSInteger)getDifferenceByDate:(NSDate *)date {
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now toDate:date options:0];
    NSInteger day = [comps day];
    return day;
}

@end
