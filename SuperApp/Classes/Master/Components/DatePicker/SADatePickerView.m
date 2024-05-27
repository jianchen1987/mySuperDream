//
//  SADatePickerView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SADatePickerView.h"
#import "SAGeneralUtil.h"
#import "SAMultiLanguageManager.h"


@interface SADatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
/// 风格
@property (nonatomic, assign) SADatePickerStyle style;
/// pickerView
@property (nonatomic, strong) UIPickerView *pickerView;
/// 年数据源
@property (nonatomic, strong) NSMutableArray *yearDataSource;
/// 月数据源
@property (nonatomic, strong) NSMutableArray *monthDataSource;
/// 日数据源
@property (nonatomic, strong) NSMutableArray *dayDataSource;
/// 按钮容器
@property (nonatomic, strong) UIView *btnContainer;
/// 取消
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// 确定
@property (nonatomic, strong) HDUIButton *confirmBTN;

@property (nonatomic, strong) SALabel *titleLabel;

@end


@implementation SADatePickerView
- (void)setupViews {
    [self addSubview:self.btnContainer];
    [self.btnContainer addSubview:self.cancelBTN];
    [self.btnContainer addSubview:self.confirmBTN];
    [self.btnContainer addSubview:self.titleLabel];
    [self addSubview:self.pickerView];
}

- (instancetype)initWithFrame:(CGRect)frame style:(SADatePickerStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        [self setupViews];
    }
    return self;
}

- (void)updateConstraints {
    [self.btnContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBTN);
        make.right.equalTo(self.confirmBTN);
        make.top.bottom.equalTo(self.cancelBTN);
    }];
    [self.cancelBTN sizeToFit];
    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.cancelBTN.bounds.size);
        make.left.top.equalTo(self);
    }];
    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.confirmBTN.bounds.size);
        make.right.top.equalTo(self);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.btnContainer);
    }];

    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnContainer.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (_style == SADatePickerStyleMY) {
        return pickerView.frame.size.width / 2;
    } else if (_style == SADatePickerStyleDMY) {
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

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *output = @"";
    if (_style == SADatePickerStyleMY) {
        if (component == 0) {
            if (SAMultiLanguageManager.isCurrentLanguageKH) {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(@"DATEPICKER_MONTH", @"月"), SALocalizedString(self.monthDataSource[row], @"")];
            } else {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(self.monthDataSource[row], @""), SALocalizedString(@"DATEPICKER_MONTH", @"月")];
            }
        } else if (component == 1) {
            if (SAMultiLanguageManager.isCurrentLanguageKH) {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(@"DATEPICKER_YEAR", @"年"), self.yearDataSource[row]];
            } else {
                output = [NSString stringWithFormat:@"%@%@", self.yearDataSource[row], SALocalizedString(@"DATEPICKER_YEAR", @"年")];
            }
        }
    } else if (_style == SADatePickerStyleDMY) {
        if (component == 0) {
            if (SAMultiLanguageManager.isCurrentLanguageKH) {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(@"DATEPICKER_DAY", @"日"), self.dayDataSource[row]];
            } else {
                output = [NSString stringWithFormat:@"%@%@", self.dayDataSource[row], SALocalizedString(@"DATEPICKER_DAY", @"日")];
            }
        } else if (component == 1) {
            if (SAMultiLanguageManager.isCurrentLanguageKH) {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(@"DATEPICKER_MONTH", @"月"), SALocalizedString(self.monthDataSource[row], @"")];
            } else {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(self.monthDataSource[row], @""), SALocalizedString(@"DATEPICKER_MONTH", @"月")];
            }
        } else if (component == 2) {
            if (SAMultiLanguageManager.isCurrentLanguageKH) {
                output = [NSString stringWithFormat:@"%@%@", SALocalizedString(@"DATEPICKER_YEAR", @"年"), self.yearDataSource[row]];
            } else {
                output = [NSString stringWithFormat:@"%@%@", self.yearDataSource[row], SALocalizedString(@"DATEPICKER_YEAR", @"年")];
            }
        }
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:output
                                                                  attributes:@{NSFontAttributeName: [HDAppTheme.font forSize:22], NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    return attrStr;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    if (_style == SADatePickerStyleDMY) {
        return 3;
    } else if (_style == SADatePickerStyleMY) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_style == SADatePickerStyleMY) {
        if (component == 0) {
            return self.monthDataSource.count;
        } else if (component == 1) {
            return self.yearDataSource.count;
        } else {
            return 0;
        }
    } else if (_style == SADatePickerStyleDMY) {
        if (component == 0) {
            return self.dayDataSource.count;
        } else if (component == 1) {
            return self.monthDataSource.count;
        } else if (component == 2) {
            return self.yearDataSource.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_style == SADatePickerStyleDMY) {
        if (component == 1) {
            [self reloadDay];
        } else if (component == 2) {
            [self reloadMonth];
            [self reloadDay];
        }
    } else if (_style == SADatePickerStyleMY) {
        if (component == 1) {
            [self reloadMonth];
        }
    }

    if (_style == SADatePickerStyleMY) {
        // 某些条件下导致数组越界的可能
        if (self.monthDataSource.count <= [pickerView selectedRowInComponent:0]) {
            return;
        }

        if (self.yearDataSource.count <= [pickerView selectedRowInComponent:1]) {
            return;
        }

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd/MM/yyyy"];
        [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        NSString *selectStr = [NSString stringWithFormat:@"01/%@/%@", self.monthDataSource[[pickerView selectedRowInComponent:0]], self.yearDataSource[[pickerView selectedRowInComponent:1]]];
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

    } else if (_style == SADatePickerStyleDMY) {
        // 某些条件下导致数组越界的可能
        if (self.dayDataSource.count <= [pickerView selectedRowInComponent:0]) {
            return;
        }

        if (self.monthDataSource.count <= [pickerView selectedRowInComponent:1]) {
            return;
        }

        if (self.yearDataSource.count <= [pickerView selectedRowInComponent:2]) {
            return;
        }

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd/MM/yyyy"];
        [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        NSString *selectStr = [NSString stringWithFormat:@"%@/%@/%@",
                                                         self.dayDataSource[[pickerView selectedRowInComponent:0]],
                                                         self.monthDataSource[[pickerView selectedRowInComponent:1]],
                                                         self.yearDataSource[[pickerView selectedRowInComponent:2]]];
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:valueChange:)]) {
        [self.delegate datePickerView:self valueChange:self.currentDateStr];
    }
}

#pragma mark - private methods
- (NSString *)currentDateStr {
    if (_style == SADatePickerStyleMY) {
        return [NSString stringWithFormat:@"%@/%@", self.monthDataSource[[self.pickerView selectedRowInComponent:0]], self.yearDataSource[[self.pickerView selectedRowInComponent:1]]];
    } else if (_style == SADatePickerStyleDMY) {
        return [NSString stringWithFormat:@"%@/%@/%@",
                                          self.dayDataSource[[self.pickerView selectedRowInComponent:0]],
                                          self.monthDataSource[[self.pickerView selectedRowInComponent:1]],
                                          self.yearDataSource[[self.pickerView selectedRowInComponent:2]]];
    } else {
        return @"";
    }
}

- (void)reloadMonth {
    NSString *currentYear = nil;

    if (_style == SADatePickerStyleMY) {
        currentYear = [self.yearDataSource objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    } else if (_style == SADatePickerStyleDMY) {
        currentYear = [self.yearDataSource objectAtIndex:[self.pickerView selectedRowInComponent:2]];
    } else {
        currentYear = [SAGeneralUtil getDateStrWithDate:[NSDate new] format:@"yyyy"];
    }

    NSString *maxYear = [SAGeneralUtil getDateStrWithDate:self.maxDate format:@"yyyy"];
    NSString *minYear = [SAGeneralUtil getDateStrWithDate:self.minDate format:@"yyyy"];

    if ([currentYear isEqualToString:maxYear] && [currentYear isEqualToString:minYear]) {
        [self setMonthFrom:[SAGeneralUtil getDateStrWithDate:self.minDate format:@"MM"].integerValue to:[SAGeneralUtil getDateStrWithDate:self.maxDate format:@"MM"].integerValue];
    } else if ([currentYear isEqualToString:maxYear] && ![currentYear isEqualToString:minYear]) {
        [self setMonthFrom:1 to:[SAGeneralUtil getDateStrWithDate:self.maxDate format:@"MM"].integerValue];
    } else if (![currentYear isEqualToString:maxYear] && [currentYear isEqualToString:minYear]) {
        [self setMonthFrom:[SAGeneralUtil getDateStrWithDate:self.minDate format:@"MM"].integerValue to:12];
    } else {
        [self setMonthFrom:1 to:12];
    }
    if (_style == SADatePickerStyleMY) {
        [self.pickerView reloadComponent:0];
    } else if (_style == SADatePickerStyleDMY) {
        [self.pickerView reloadComponent:1];
    }
}

- (void)setMonthFrom:(NSInteger)start to:(NSInteger)end {
    [self.monthDataSource removeAllObjects];
    for (NSInteger i = start; i <= end; i++) {
        [self.monthDataSource addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
}

- (void)reloadDay {
    NSString *currenMY = [NSString stringWithFormat:@"%@%@", self.monthDataSource[[self.pickerView selectedRowInComponent:1]], self.yearDataSource[[self.pickerView selectedRowInComponent:2]]];
    NSString *minMY = [SAGeneralUtil getDateStrWithDate:self.minDate format:@"MMyyyy"];
    NSString *maxMY = [SAGeneralUtil getDateStrWithDate:self.maxDate format:@"MMyyyy"];

    if ([currenMY isEqualToString:minMY] && [currenMY isEqualToString:maxMY]) {
        [self setDayFrom:[SAGeneralUtil getDateStrWithDate:self.minDate format:@"dd"].integerValue to:[SAGeneralUtil getDateStrWithDate:self.maxDate format:@"dd"].integerValue];

    } else if ([currenMY isEqualToString:minMY] && ![currenMY isEqualToString:maxMY]) {
        [self setDayFrom:[SAGeneralUtil getDateStrWithDate:self.minDate format:@"dd"].integerValue
                      to:[SAGeneralUtil getDaysForMonth:[(NSString *)[self.monthDataSource objectAtIndex:[self.pickerView selectedRowInComponent:1]] integerValue]
                                                 inYear:[(NSString *)[self.yearDataSource objectAtIndex:[self.pickerView selectedRowInComponent:2]] integerValue]]];

    } else if (![currenMY isEqualToString:minMY] && [currenMY isEqualToString:maxMY]) {
        [self setDayFrom:1 to:[SAGeneralUtil getDateStrWithDate:self.maxDate format:@"dd"].integerValue];
    } else {
        [self setDayFrom:1 to:[SAGeneralUtil getDaysForMonth:[(NSString *)[self.monthDataSource objectAtIndex:[self.pickerView selectedRowInComponent:1]] integerValue]
                                                      inYear:[(NSString *)[self.yearDataSource objectAtIndex:[self.pickerView selectedRowInComponent:2]] integerValue]]];
    }

    [self.pickerView reloadComponent:0];
}

- (void)setDayFrom:(NSInteger)start to:(NSInteger)end {
    [self.dayDataSource removeAllObjects];
    for (NSInteger i = start; i <= end; i++) {
        [self.dayDataSource addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
}

#pragma mark - public methods
- (void)setCurrentDate:(NSDate *)date {
    NSString *dayDataSource = [SAGeneralUtil getDateStrWithDate:date format:@"dd"];
    NSString *monthDataSource = [SAGeneralUtil getDateStrWithDate:date format:@"MM"];
    NSString *yearDataSource = [SAGeneralUtil getDateStrWithDate:date format:@"yyyy"];

    if (_style == SADatePickerStyleDMY) {
        for (int i = 0; i < self.yearDataSource.count; i++) {
            if ([yearDataSource isEqualToString:self.yearDataSource[i]]) {
                [self.pickerView selectRow:i inComponent:2 animated:YES];
                [self reloadMonth];
            }
        }

        for (int i = 0; i < self.monthDataSource.count; i++) {
            if ([monthDataSource isEqualToString:self.monthDataSource[i]]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self reloadDay];
            }
        }

        for (int i = 0; i < self.dayDataSource.count; i++) {
            if ([dayDataSource isEqualToString:self.dayDataSource[i]]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }
        }

    } else if (_style == SADatePickerStyleMY) {
        for (int i = 0; i < self.yearDataSource.count; i++) {
            if ([yearDataSource isEqualToString:self.yearDataSource[i]]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self reloadMonth];
            }
        }

        for (int i = 0; i < self.monthDataSource.count; i++) {
            if ([monthDataSource isEqualToString:self.monthDataSource[i]]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }
        }
    }
}

- (void)setTitleText:(NSString *)text {
    if (text) {
        self.titleLabel.text = text;
    }
}

#pragma mark - event response
- (void)clickedCancelBTNHandler {
    !self.clickedCancelBlock ?: self.clickedCancelBlock();
}

- (void)clickedConfirmBTNHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [self.delegate datePickerView:self didSelectDate:self.currentDateStr];
    }
    [self clickedCancelBTNHandler];
}

#pragma mark - lazy load

- (UIView *)btnContainer {
    if (!_btnContainer) {
        _btnContainer = UIView.new;
        _btnContainer.backgroundColor = HDAppTheme.color.G5;
    }
    return _btnContainer;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = UIPickerView.new;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (HDUIButton *)cancelBTN {
    if (!_cancelBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button addTarget:self action:@selector(clickedCancelBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _cancelBTN = button;
    }
    return _cancelBTN;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN = button;
    }
    return _confirmBTN;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = SALabel.new;
        _titleLabel.font = HDAppTheme.font.sa_standard16B;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (NSMutableArray *)yearDataSource {
    if (!_yearDataSource) {
        _yearDataSource = [[NSMutableArray alloc] init];

        NSString *maxYear = [SAGeneralUtil getDateStrWithDate:self.maxDate format:@"yyyy"];
        NSString *minYear = [SAGeneralUtil getDateStrWithDate:self.minDate format:@"yyyy"];

        for (int i = minYear.intValue; i <= maxYear.intValue; i++) {
            [_yearDataSource addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _yearDataSource;
}

- (NSMutableArray *)monthDataSource {
    if (!_monthDataSource) {
        _monthDataSource = [[NSMutableArray alloc] initWithArray:@[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"]];
    }
    return _monthDataSource;
}

- (NSMutableArray *)dayDataSource {
    if (!_dayDataSource) {
        _dayDataSource = [[NSMutableArray alloc] init];
    }
    return _dayDataSource;
}

@end
