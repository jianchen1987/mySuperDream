//
//  HDBillDatePickViewController.m
//  customer
//
//  Created by 帅呆 on 2018/10/31.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDBillDatePickViewController.h"
#import "HDAppTheme+PayNow.h"
#import "HDAppTheme.h"
#import "HDButton.h"
#import "HDDatePickView.h"
#import "HDUITextField.h"
#import "PNCommonUtils.h"


@interface HDBillDatePickViewController () <UITextFieldDelegate, HDDatePickViewDelegate>
@property (nonatomic, strong) UIButton *cancelItem;
@property (nonatomic, strong) UIButton *completeItem;
@property (nonatomic, strong) UIScrollView *scrollViews;
@property (nonatomic, strong) HDButton *searchByMonthBtn;
@property (nonatomic, strong) HDButton *searchByDayBtn;
@property (nonatomic, strong) HDButton *searchMonth;
@property (nonatomic, strong) HDButton *searchDayStart;
@property (nonatomic, strong) HDButton *searchDayEnd;
@property (nonatomic, strong) HDDatePickView *monthPickView;
@property (nonatomic, copy) NSArray *month;
@property (nonatomic, strong) NSMutableArray *year;
@property (nonatomic, strong) HDDatePickView *dayDatePickView;
@end


@implementation HDBillDatePickViewController

- (HDDatePickView *)dayDatePickView {
    if (!_dayDatePickView) {
        _dayDatePickView = [[HDDatePickView alloc] initWithFrame:CGRectMake(kScreenWidth + 20, self.searchMonth.bottom + 30, kScreenWidth - 40, 150) style:HDDatePickStyleDMY];
        _dayDatePickView.HDDelegate = self;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyyMMdd HH:mm:ss"];
        [fmt setLocale:[NSLocale currentLocale]];
        _dayDatePickView.minDate = [fmt dateFromString:@"20180101 12:00:00"];
        _dayDatePickView.maxDate = [NSDate new];
    }
    return _dayDatePickView;
}

- (HDDatePickView *)monthPickView {
    if (!_monthPickView) {
        _monthPickView = [[HDDatePickView alloc] initWithFrame:CGRectMake(0, self.searchMonth.bottom + 30, kScreenWidth, 150) style:HDDatePickStyleMY];
        _monthPickView.HDDelegate = self;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyyMMdd HH:mm:ss"];
        [fmt setLocale:[NSLocale currentLocale]];
        _monthPickView.minDate = [fmt dateFromString:@"20180101 12:00:00"];
        _monthPickView.maxDate = [NSDate new];
    }

    return _monthPickView;
}

- (HDButton *)searchDayStart {
    if (!_searchDayStart) {
        _searchDayStart = [[HDButton alloc] initWithFrame:CGRectMake(kScreenWidth + 30, self.searchByMonthBtn.bottom + 10, kScreenWidth / 2.0 - 40, 40) type:HDButtonStyleUnderLine];
        [_searchDayStart setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateSelected];
        [_searchDayStart setTitleColor:[UIColor hd_colorWithHexString:@"#ACACAC"] forState:UIControlStateNormal];
        _searchDayStart.titleLabel.font = HDAppTheme.PayNowFont.standard17;
        [_searchDayStart setTitle:PNLocalizedString(@"BTN_TITLE_BEGAIN_TIME", @"开始时间") forState:UIControlStateNormal];
        _searchDayStart.selected = YES;
        [_searchDayStart addTarget:self action:@selector(clickOnDayButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _searchDayStart;
}

- (HDButton *)searchDayEnd {
    if (!_searchDayEnd) {
        _searchDayEnd = [[HDButton alloc] initWithFrame:CGRectMake(kScreenWidth + kScreenWidth / 2.0 + 10, self.searchByMonthBtn.bottom + 10, kScreenWidth / 2.0 - 40, 40) type:HDButtonStyleUnderLine];
        [_searchDayEnd setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateSelected];
        [_searchDayEnd setTitleColor:[UIColor hd_colorWithHexString:@"#ACACAC"] forState:UIControlStateNormal];
        _searchDayEnd.titleLabel.font = HDAppTheme.PayNowFont.standard17;
        [_searchDayEnd setTitle:PNLocalizedString(@"BTN_TITLE_END_TIME", @"结束时间") forState:UIControlStateNormal];
        [_searchDayEnd addTarget:self action:@selector(clickOnDayButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _searchDayEnd;
}

- (HDButton *)searchMonth {
    if (!_searchMonth) {
        _searchMonth = [[HDButton alloc] initWithFrame:CGRectMake(15, self.searchByMonthBtn.bottom + 10, kScreenWidth - 30, 40) type:HDButtonStyleUnderLine];
        [_searchMonth setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateSelected];
        _searchMonth.titleLabel.font = HDAppTheme.PayNowFont.standard17;
        [_searchMonth setTitle:@"-/-" forState:UIControlStateNormal];
        _searchMonth.selected = YES;
    }

    return _searchMonth;
}

- (UIScrollView *)scrollViews {
    if (!_scrollViews) {
        _scrollViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - kNavigationBarH - 60)];
        _scrollViews.bounces = NO;
        _scrollViews.contentSize = CGSizeMake(kScreenWidth * 2, _scrollViews.height);
        _scrollViews.pagingEnabled = YES;
        _scrollViews.scrollEnabled = NO;

        _scrollViews.showsVerticalScrollIndicator = NO;
        _scrollViews.showsHorizontalScrollIndicator = NO;
    }
    return _scrollViews;
}

- (UIButton *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelItem setTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") forState:UIControlStateNormal];
        [_cancelItem setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateNormal];
        [_cancelItem addTarget:self action:@selector(clickOnCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelItem;
}

- (UIButton *)completeItem {
    if (!_completeItem) {
        _completeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeItem setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:UIControlStateNormal];
        [_completeItem setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateNormal];
        [_completeItem addTarget:self action:@selector(clickOnDone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeItem;
}

- (HDButton *)searchByMonthBtn {
    if (!_searchByMonthBtn) {
        _searchByMonthBtn = [[HDButton alloc] initWithFrame:CGRectMake(15, HD_STATUSBAR_NAVBAR_HEIGHT + 15, 85, 30) type:HDButtonStyleBorderCycle];
        //        _searchByMonthBtn.layer.borderColor = kGradualColorTo.CGColor;
        _searchByMonthBtn.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [_searchByMonthBtn setTitle:PNLocalizedString(@"BTN_TITLE_SELECTBYMONTH", @"按月选择") forState:UIControlStateNormal];
        [_searchByMonthBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateSelected];
        [_searchByMonthBtn setTitleColor:[UIColor hd_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        _searchByMonthBtn.selected = YES;
        [_searchByMonthBtn addTarget:self action:@selector(clickOnSelectTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchByMonthBtn;
}

- (HDButton *)searchByDayBtn {
    if (!_searchByDayBtn) {
        _searchByDayBtn = [[HDButton alloc] initWithFrame:CGRectMake(self.searchByMonthBtn.right + 15, HD_STATUSBAR_NAVBAR_HEIGHT + 15, 85, 30) type:HDButtonStyleBorderCycle];
        _searchByDayBtn.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [_searchByDayBtn setTitle:PNLocalizedString(@"BTN_TITLE_SELECTBYDAY", @"按日选择") forState:UIControlStateNormal];
        [_searchByDayBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateSelected];
        [_searchByDayBtn setTitleColor:[UIColor hd_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_searchByDayBtn addTarget:self action:@selector(clickOnSelectTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchByDayBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.completeItem]];
    self.hd_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.cancelItem]];
    //    [self setNavCustomLeftView:self.cancelItem];
    //    [self setNavCustomRightView:self.completeItem];

    [self.view addSubview:self.scrollViews];
    [self.view addSubview:self.searchByMonthBtn];
    [self.view addSubview:self.searchByDayBtn];

    [self.scrollViews addSubview:self.searchMonth];
    [self.scrollViews addSubview:self.searchDayStart];
    UIView *separLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth + (kScreenWidth - 15) / 2.0, self.searchDayStart.bottom - 19.5, 15, 1)];
    separLine.backgroundColor = [UIColor hd_colorWithHexString:@"#ACACAC"];
    [self.scrollViews addSubview:separLine];
    [self.scrollViews addSubview:self.searchDayEnd];

    [self.scrollViews addSubview:self.monthPickView];

    [self.scrollViews addSubview:self.dayDatePickView];

    [self reflushUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.searchMonth setTitle:[PNCommonUtils getCurrentDateStrByFormat:@"MM/yyyy"] forState:UIControlStateNormal];
    [self.monthPickView setCurrentDate:[NSDate new]];

    [self.searchDayStart setTitle:[PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"] forState:UIControlStateNormal];
    [self.dayDatePickView setCurrentDate:[NSDate new]];
}

- (void)reflushUI {
    self.boldTitle = PNLocalizedString(@"VIEW_TITLE_SELECTTIME", @"选择时间");
    [self.searchByMonthBtn setTitle:PNLocalizedString(@"BTN_TITLE_SELECTBYMONTH", @"按月选择") forState:UIControlStateNormal];
    [self.searchByDayBtn setTitle:PNLocalizedString(@"BTN_TITLE_SELECTBYDAY", @"按日选择") forState:UIControlStateNormal];
    [self.searchDayEnd setTitle:PNLocalizedString(@"BTN_TITLE_END_TIME", @"结束时间") forState:UIControlStateNormal];
    [self.searchDayStart setTitle:PNLocalizedString(@"BTN_TITLE_BEGAIN_TIME", @"开始时间") forState:UIControlStateNormal];
}

#pragma mark navigationitem action

- (void)clickOnCancel:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(DatePickCancel)]) {
        [self.delegate DatePickCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickOnDone:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(DatePickDateType:Start:End:)]) {
        if (self.searchByMonthBtn.selected) {
            [self.delegate DatePickDateType:HD_SEARCH_DATE_TYPE_MONTH Start:self.searchMonth.currentTitle End:@""];
        } else if (self.searchByDayBtn.selected) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            [fmt setDateFormat:@"dd/MM/yyyy HH:m:ss"];
            [fmt setLocale:[NSLocale currentLocale]];
            NSDate *start = [fmt dateFromString:[self.searchDayStart.currentTitle stringByAppendingString:@" 12:00:00"]];
            if (!start) {
                [self dateFormatIsUncorrect];
                return;
            }
            NSDate *end = [fmt dateFromString:[self.searchDayEnd.currentTitle stringByAppendingString:@" 12:00:00"]];
            if (!end) {
                [self.delegate DatePickDateType:HD_SEARCH_DATE_TYPE_INTERVAL Start:self.searchDayStart.currentTitle End:self.searchDayStart.currentTitle];
            } else if ([start compare:end] == NSOrderedAscending) {
                [self.delegate DatePickDateType:HD_SEARCH_DATE_TYPE_INTERVAL Start:self.searchDayStart.currentTitle End:self.searchDayEnd.currentTitle];

            } else {
                [self.delegate DatePickDateType:HD_SEARCH_DATE_TYPE_INTERVAL Start:self.searchDayEnd.currentTitle End:self.searchDayStart.currentTitle];
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickOnSelectTypeButton:(HDButton *)button {
    if ([button isEqual:self.searchByMonthBtn]) {
        self.searchByMonthBtn.selected = YES;
        self.searchByDayBtn.selected = NO;
        [self.scrollViews setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        self.searchByMonthBtn.selected = NO;
        self.searchByDayBtn.selected = YES;
        [self.scrollViews setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
}

- (void)clickOnDayButton:(HDButton *)button {
    if ([button isEqual:self.searchDayStart]) {
        [self.searchDayStart setSelected:YES];
        [self.searchDayEnd setSelected:NO];
        [self resetButtonTitle:self.searchDayStart];

    } else if ([button isEqual:self.searchDayEnd]) {
        [self.searchDayEnd setSelected:YES];
        [self.searchDayStart setSelected:NO];
        [self resetButtonTitle:self.searchDayEnd];
    }
}

#pragma mark HDDatePickViewDelegate
- (void)HDDatePickView:(HDDatePickView *)pickView ValueChange:(NSString *)date {
    if ([pickView isEqual:self.dayDatePickView]) {
        if (self.searchDayStart.selected) {
            [self.searchDayStart setTitle:date forState:UIControlStateNormal];
        } else {
            [self.searchDayEnd setTitle:date forState:UIControlStateNormal];
        }
    } else if ([pickView isEqual:self.monthPickView]) {
        [self.searchMonth setTitle:date forState:UIControlStateNormal];
    }
}

- (void)dateFormatIsUncorrect {
    [NAT showAlertWithMessage:PNLocalizedString(@"", @"请选择正确的开始结束时间") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确定")
                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                          [alertView dismiss];
                      }];
}

- (void)resetButtonTitle:(HDButton *)button {
    NSString *title = button.currentTitle;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy"];
    [fmt setLocale:[NSLocale currentLocale]];
    if ([PNCommonUtils isDate:title withFormat:@"dd/MM/yyyy"]) {
        [self.dayDatePickView setCurrentDate:[fmt dateFromString:title]];
    } else {
        [button setTitle:[fmt stringFromDate:[NSDate new]] forState:UIControlStateNormal];
        [self.dayDatePickView setCurrentDate:[NSDate new]];
    }
}

@end
