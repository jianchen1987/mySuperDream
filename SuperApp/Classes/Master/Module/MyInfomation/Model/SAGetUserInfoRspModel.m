//
//  SAGetUserInfoRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetUserInfoRspModel.h"
#import "SAGeneralUtil.h"


@implementation SAGetUserInfoRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"thirdBindsList": @"thirdBinds"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"thirdBindsList": SAUserThirdBindModel.class,
    };
}

- (NSInteger)WMAge {
    if (!_WMAge) {
        if (self.birthday) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.birthday.integerValue / 1000.0];
            NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
            if (dateStr.length >= 10) {
                NSString *year = [dateStr substringWithRange:NSMakeRange(dateStr.length - 4, 4)];
                NSString *month = [dateStr substringWithRange:NSMakeRange(3, 2)];
                NSString *day = [dateStr substringWithRange:NSMakeRange(0, 2)];
                NSDate *nowDate = [NSDate date];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
                NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
                NSInteger nowYear = compomemts.year;
                NSInteger nowMonth = compomemts.month;
                NSInteger nowDay = compomemts.day;
                /// 正确计算年龄
                NSInteger userAge = nowYear - year.intValue - 1;
                if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
                    userAge++;
                }
                /// 最小1岁
                _WMAge = MAX(1, userAge);
            }
        }
    }
    return _WMAge;
}
@end
