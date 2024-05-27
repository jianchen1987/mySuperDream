//
//  HDDatePickView.m
//  customer
//
//  Created by 帅呆 on 2018/11/5.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDDatePickView.h"
#import "PNCommonUtils.h"
#import "PNMultiLanguageManager.h" //语言
#import "PNUtilMacro.h"


@interface HDDatePickView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    HDDatePickStyle _style;
}

@property (nonatomic, strong) NSMutableArray *year;
@property (nonatomic, strong) NSMutableArray *month;
@property (nonatomic, strong) NSMutableArray *day;

@end


@implementation HDDatePickView

- (NSMutableArray *)year {
    if (!_year) {
        _year = [[NSMutableArray alloc] init];

        NSString *maxYear = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:self.maxDate];
        NSString *minYear = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:self.minDate];

        for (int i = minYear.intValue; i <= maxYear.intValue; i++) {
            [_year addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _year;
}

- (NSMutableArray *)month {
    if (!_month) {
        _month = [[NSMutableArray alloc] initWithArray:@[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"]];
    }
    return _month;
}

- (NSMutableArray *)day {
    if (!_day) {
        _day = [[NSMutableArray alloc] init];
    }
    return _day;
}

- (instancetype)initWithFrame:(CGRect)frame style:(HDDatePickStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        self.delegate = self;
        self.dataSource = self;
    }

    return self;
}

//- (void)didAddSubview:(UIView *)subview{
//    [super didAddSubview:subview];
//    [self reloadMonth];
//    if(_style == HDDatePickStyleDMY){
//        [self reloadDay];
//    }
//
//
//}

- (NSString *)getSelectDate {
    if (_style == HDDatePickStyleMY) {
        return [NSString stringWithFormat:@"%@/%@", self.month[[self selectedRowInComponent:0]], self.year[[self selectedRowInComponent:1]]];
    } else if (_style == HDDatePickStyleDMY) {
        return [NSString stringWithFormat:@"%@/%@/%@", self.day[[self selectedRowInComponent:0]], self.month[[self selectedRowInComponent:1]], self.year[[self selectedRowInComponent:2]]];
    } else {
        return @"";
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (_style == HDDatePickStyleMY) {
        return pickerView.frame.size.width / 2;
    } else if (_style == HDDatePickStyleDMY) {
        if (component == 0) {
            return pickerView.frame.size.width / 5;
        } else if (component == 1) {
            return (pickerView.frame.size.width / 5) * 2;
        } else if (component == 2) {
            return (pickerView.frame.size.width / 5) * 2;
        } else {
            return 0;
        }

    } else {
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_style == HDDatePickStyleMY) {
        if (component == 0) {
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:LANGUAGE_KHR]) {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_MONTH", @"月"), PNLocalizedString(self.month[row], @"")];
            } else {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(self.month[row], @""), PNLocalizedString(@"DATEPICKER_MONTH", @"月")];
            }

        } else if (component == 1) {
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:LANGUAGE_KHR]) {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_YEAR", @"年"), self.year[row]];
            } else {
                return [NSString stringWithFormat:@"%@%@", self.year[row], PNLocalizedString(@"DATEPICKER_YEAR", @"年")];
            }

        } else {
            return @"";
        }
    } else if (_style == HDDatePickStyleDMY) {
        if (component == 0) {
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:LANGUAGE_KHR]) {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_DAY", @"日"), self.day[row]];
            } else {
                return [NSString stringWithFormat:@"%@%@", self.day[row], PNLocalizedString(@"DATEPICKER_DAY", @"日")];
            }

        } else if (component == 1) {
            //            return [NSString stringWithFormat:@"%@%@",PNLocalizedString(self.month[row], @""),PNLocalizedString(@"DATEPICKER_MONTH", @"月")];
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:LANGUAGE_KHR]) {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_MONTH", @"月"), PNLocalizedString(self.month[row], @"")];
            } else {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(self.month[row], @""), PNLocalizedString(@"DATEPICKER_MONTH", @"月")];
            }
        } else if (component == 2) {
            //            return [NSString stringWithFormat:@"%@%@",self.year[row],PNLocalizedString(@"DATEPICKER_YEAR", @"年")];
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:LANGUAGE_KHR]) {
                return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_YEAR", @"年"), self.year[row]];
            } else {
                return [NSString stringWithFormat:@"%@%@", self.year[row], PNLocalizedString(@"DATEPICKER_YEAR", @"年")];
            }
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_style == HDDatePickStyleDMY) {
        if (component == 1) {
            [self reloadDay];
        } else if (component == 2) {
            [self reloadMonth];
            [self reloadDay];
        }
    } else if (_style == HDDatePickStyleMY) {
        if (component == 1) {
            [self reloadMonth];
        }
    }

    if (_style == HDDatePickStyleMY) {
        //某些条件下导致数组越界的可能
        if (self.month.count <= [pickerView selectedRowInComponent:0]) {
            return;
        }

        if (self.year.count <= [pickerView selectedRowInComponent:1]) {
            return;
        }

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd/MM/yyyy"];
        [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        NSString *selectStr = [NSString stringWithFormat:@"01/%@/%@", self.month[[pickerView selectedRowInComponent:0]], self.year[[pickerView selectedRowInComponent:1]]];
        NSDate *selectDate = [fmt dateFromString:selectStr];

        if (self.minDate) {
            if ([selectDate compare:self.minDate] == NSOrderedAscending) {
                [self setCurrentDate:self.minDate];
            }
        }

        if (self.maxDate) {
            if ([selectDate compare:self.maxDate] == NSOrderedDescending) {
                [self setCurrentDate:self.maxDate];
            }
        }

    } else if (_style == HDDatePickStyleDMY) {
        //某些条件下导致数组越界的可能
        if (self.day.count <= [pickerView selectedRowInComponent:0]) {
            return;
        }

        if (self.month.count <= [pickerView selectedRowInComponent:1]) {
            return;
        }

        if (self.year.count <= [pickerView selectedRowInComponent:2]) {
            return;
        }

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd/MM/yyyy"];
        [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        NSString *selectStr = [NSString
            stringWithFormat:@"%@/%@/%@", self.day[[pickerView selectedRowInComponent:0]], self.month[[pickerView selectedRowInComponent:1]], self.year[[pickerView selectedRowInComponent:2]]];
        HDLog(@"select date :%@", selectStr);
        NSDate *selectDate = [fmt dateFromString:selectStr];

        if (self.minDate) {
            if ([selectDate compare:self.minDate] == NSOrderedAscending) {
                [self setCurrentDate:self.minDate];
            }
        }

        if (self.maxDate) {
            if ([selectDate compare:self.maxDate] == NSOrderedDescending) {
                [self setCurrentDate:self.maxDate];
            }
        }
    }

    if ([self.HDDelegate respondsToSelector:@selector(HDDatePickView:ValueChange:)]) {
        [self.HDDelegate HDDatePickView:self ValueChange:[self getSelectDate]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    if (_style == HDDatePickStyleDMY) {
        return 3;
    } else if (_style == HDDatePickStyleMY) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_style == HDDatePickStyleMY) {
        if (component == 0) {
            return self.month.count;
        } else if (component == 1) {
            return self.year.count;
        } else {
            return 0;
        }
    } else if (_style == HDDatePickStyleDMY) {
        if (component == 0) {
            return self.day.count;
        } else if (component == 1) {
            return self.month.count;
        } else if (component == 2) {
            return self.year.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (void)reloadMonth {
    NSString *currentYear = nil;

    if (_style == HDDatePickStyleMY) {
        currentYear = [self.year objectAtIndex:[self selectedRowInComponent:1]];
    } else if (_style == HDDatePickStyleDMY) {
        currentYear = [self.year objectAtIndex:[self selectedRowInComponent:2]];
    } else {
        currentYear = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:[NSDate new]];
    }

    NSString *maxYear = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:self.maxDate];
    NSString *minYear = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:self.minDate];

    if ([currentYear isEqualToString:maxYear] && [currentYear isEqualToString:minYear]) {
        [self setMonthFrom:[PNCommonUtils getDateStrByFormat:@"MM" withDate:self.minDate].integerValue to:[PNCommonUtils getDateStrByFormat:@"MM" withDate:self.maxDate].integerValue];
    } else if ([currentYear isEqualToString:maxYear] && ![currentYear isEqualToString:minYear]) {
        [self setMonthFrom:1 to:[PNCommonUtils getDateStrByFormat:@"MM" withDate:self.maxDate].integerValue];
    } else if (![currentYear isEqualToString:maxYear] && [currentYear isEqualToString:minYear]) {
        [self setMonthFrom:[PNCommonUtils getDateStrByFormat:@"MM" withDate:self.minDate].integerValue to:12];
    } else {
        [self setMonthFrom:1 to:12];
    }
    if (_style == HDDatePickStyleMY) {
        [self reloadComponent:0];
    } else if (_style == HDDatePickStyleDMY) {
        [self reloadComponent:1];
    }
}

- (void)setMonthFrom:(NSInteger)start to:(NSInteger)end {
    [self.month removeAllObjects];
    for (NSInteger i = start; i <= end; i++) {
        [self.month addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
}

- (void)reloadDay {
    NSString *currenMY = [NSString stringWithFormat:@"%@%@", self.month[[self selectedRowInComponent:1]], self.year[[self selectedRowInComponent:2]]];
    NSString *minMY = [PNCommonUtils getDateStrByFormat:@"MMyyyy" withDate:self.minDate];
    NSString *maxMY = [PNCommonUtils getDateStrByFormat:@"MMyyyy" withDate:self.maxDate];

    if ([currenMY isEqualToString:minMY] && [currenMY isEqualToString:maxMY]) {
        [self setDayFrom:[PNCommonUtils getDateStrByFormat:@"dd" withDate:self.minDate].integerValue to:[PNCommonUtils getDateStrByFormat:@"dd" withDate:self.maxDate].integerValue];

    } else if ([currenMY isEqualToString:minMY] && ![currenMY isEqualToString:maxMY]) {
        [self setDayFrom:[PNCommonUtils getDateStrByFormat:@"dd" withDate:self.minDate].integerValue
                      to:[PNCommonUtils getDayByMonth:[(NSString *)[self.month objectAtIndex:[self selectedRowInComponent:1]] integerValue]
                                                 Year:[(NSString *)[self.year objectAtIndex:[self selectedRowInComponent:2]] integerValue]]];

    } else if (![currenMY isEqualToString:minMY] && [currenMY isEqualToString:maxMY]) {
        [self setDayFrom:1 to:[PNCommonUtils getDateStrByFormat:@"dd" withDate:self.maxDate].integerValue];
    } else {
        [self setDayFrom:1 to:[PNCommonUtils getDayByMonth:[(NSString *)[self.month objectAtIndex:[self selectedRowInComponent:1]] integerValue]
                                                      Year:[(NSString *)[self.year objectAtIndex:[self selectedRowInComponent:2]] integerValue]]];
    }

    [self reloadComponent:0];
}

- (void)setDayFrom:(NSInteger)start to:(NSInteger)end {
    [self.day removeAllObjects];
    for (NSInteger i = start; i <= end; i++) {
        [self.day addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
}

- (NSString *)valueInRow:(NSInteger)row andCompont:(NSInteger)component {
    if (_style == HDDatePickStyleMY) {
        if (component == 0) {
            return self.month[row];
        } else if (component == 1) {
            return self.year[row];
        } else {
            return @"";
        }
    } else if (_style == HDDatePickStyleDMY) {
        if (component == 0) {
            return self.day[row];
        } else if (component == 1) {
            return self.month[row];
        } else if (component == 2) {
            return self.year[row];
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

- (void)setCurrentDate:(NSDate *)date {
    NSString *day = [PNCommonUtils getDateStrByFormat:@"dd" withDate:date];
    NSString *month = [PNCommonUtils getDateStrByFormat:@"MM" withDate:date];
    NSString *year = [PNCommonUtils getDateStrByFormat:@"yyyy" withDate:date];

    if (_style == HDDatePickStyleDMY) {
        for (int i = 0; i < self.year.count; i++) {
            if ([year isEqualToString:self.year[i]]) {
                [self selectRow:i inComponent:2 animated:YES];
                [self reloadMonth];
            }
        }

        for (int i = 0; i < self.month.count; i++) {
            if ([month isEqualToString:self.month[i]]) {
                [self selectRow:i inComponent:1 animated:YES];
                [self reloadDay];
            }
        }

        for (int i = 0; i < self.day.count; i++) {
            if ([day isEqualToString:self.day[i]]) {
                [self selectRow:i inComponent:0 animated:YES];
            }
        }

    } else if (_style == HDDatePickStyleMY) {
        for (int i = 0; i < self.year.count; i++) {
            if ([year isEqualToString:self.year[i]]) {
                [self selectRow:i inComponent:1 animated:YES];
                [self reloadMonth];
            }
        }

        for (int i = 0; i < self.month.count; i++) {
            if ([month isEqualToString:self.month[i]]) {
                [self selectRow:i inComponent:0 animated:YES];
            }
        }
    }
}

@end
