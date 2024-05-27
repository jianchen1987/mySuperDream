//
//  TNIncomeFilterCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNIncomeFilterCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SADatePickerViewController.h"
#import "TNIncomeListFilterModel.h"
#import "TNIncomeModel.h"
#import "TNView.h"


@interface TNIncomeCustomizeTimeView : TNView <UITextFieldDelegate, SADatePickerViewDelegate>
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UITextField *startTimeTextFeild;
///
@property (strong, nonatomic) UITextField *endTimeTextFeild;
///
@property (strong, nonatomic) UIView *lineView;
///
@property (nonatomic, assign) BOOL isEditStartTime;
///
@property (nonatomic, copy) NSString *startDateStr;
///
@property (nonatomic, copy) NSString *endDateStr;
/// 时间选择完回调  开始时间和结束时间都要选择
@property (nonatomic, copy) void (^dateSelectedCallBack)(NSString *startTime, NSString *endTime);
@end


@implementation TNIncomeCustomizeTimeView
- (void)hd_setupViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.startTimeTextFeild];
    [self addSubview:self.endTimeTextFeild];
    [self addSubview:self.lineView];
}
- (void)setStartDateStr:(NSString *)startDateStr {
    _startDateStr = startDateStr;
    self.startTimeTextFeild.text = startDateStr;
}
- (void)setEndDateStr:(NSString *)endDateStr {
    _endDateStr = endDateStr;
    self.endTimeTextFeild.text = endDateStr;
}
#pragma mark - 选中时间
- (void)showDatePickerView {
    SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
    vc.datePickStyle = SADatePickerStyleDMY;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    // 生日不要超过今天
    NSDate *maxDate = [NSDate date];

    NSDate *minDate = [maxDate dateByAddingTimeInterval:-1 * 365 * 24 * 60 * 60.0];

    vc.maxDate = maxDate;
    vc.minDate = minDate;
    vc.delegate = self;

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.viewController.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma mark - SADatePickerViewDelegate
- (void)datePickerView:(SADatePickerView *)pickerView didSelectDate:(NSString *)dateStr {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSTimeInterval maxDiffTimeInterval = 90 * 24 * 60 * 60.0; // 90天
    NSDate *selectedDate = [fmt dateFromString:dateStr];
    NSTimeInterval selectedTimeInterval = [selectedDate timeIntervalSince1970];
    if (self.isEditStartTime) {
        // 年龄不超过 90天
        if (HDIsStringNotEmpty(self.endDateStr)) {
            NSDate *endDate = [fmt dateFromString:self.endDateStr];
            if ([selectedDate compare:endDate] == NSOrderedDescending) {
                //开始时间大于结束时间
                [HDTips showWithText:TNLocalizedString(@"h2H7EfuN", @"结束时间不能小于开始时间")];
                dateStr = @""; //置空
            } else {
                NSTimeInterval endTimeInterval = [endDate timeIntervalSince1970];
                if (endTimeInterval - selectedTimeInterval > maxDiffTimeInterval) {
                    //时间区间间隔不能超过90天
                    [HDTips showWithText:TNLocalizedString(@"lBMuQWri", @"时间区间间隔不能超过90天")];
                    dateStr = @""; //置空
                }
            }
        }
        self.startTimeTextFeild.text = dateStr;
        self.startDateStr = dateStr;
    } else {
        // 年龄不超过 90天
        if (HDIsStringNotEmpty(self.startDateStr)) {
            NSDate *startDate = [fmt dateFromString:self.startDateStr];
            if ([startDate compare:selectedDate] == NSOrderedDescending) {
                //开始时间大于结束时间
                [HDTips showWithText:TNLocalizedString(@"h2H7EfuN", @"结束时间不能小于开始时间")];
                dateStr = @""; //置空
            } else {
                NSTimeInterval startTimeInterval = [startDate timeIntervalSince1970];
                if (selectedTimeInterval - startTimeInterval > maxDiffTimeInterval) {
                    //时间区间间隔不能超过90天
                    [HDTips showWithText:TNLocalizedString(@"lBMuQWri", @"时间区间间隔不能超过90天")];
                    dateStr = @""; //置空
                }
            }
        }
        self.endTimeTextFeild.text = dateStr;
        self.endDateStr = dateStr;
    }

    if (HDIsStringNotEmpty(self.startDateStr) && HDIsStringNotEmpty(self.endDateStr)) {
        !self.dateSelectedCallBack ?: self.dateSelectedCallBack(self.startDateStr, self.endDateStr);
    }
}
#pragma mark -delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showDatePickerView];
    if (textField == self.startTimeTextFeild) {
        self.isEditStartTime = YES;
    } else {
        self.isEditStartTime = NO;
    }
    return NO;
}
- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
    }];
    [self.startTimeTextFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.nameLabel.mas_right).offset(kRealWidth(6));
        make.width.mas_equalTo(kRealWidth(110));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.startTimeTextFeild.mas_right).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), 1));
    }];
    [self.endTimeTextFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.lineView.mas_right).offset(kRealWidth(10));
        make.width.mas_equalTo(kRealWidth(110));
    }];
    [super updateConstraints];
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _nameLabel.text = TNLocalizedString(@"oZpZHOhQ", @"自定义");
    }
    return _nameLabel;
}
/** @lazy startTimeTextFeild */
- (UITextField *)startTimeTextFeild {
    if (!_startTimeTextFeild) {
        _startTimeTextFeild = [[UITextField alloc] init];
        _startTimeTextFeild.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _startTimeTextFeild.font = HDAppTheme.TinhNowFont.standard12;
        _startTimeTextFeild.textColor = HDAppTheme.TinhNowColor.G1;
        _startTimeTextFeild.placeholder = TNLocalizedString(@"hBQaWtMv", @"开始时间");
        _startTimeTextFeild.delegate = self;
        _startTimeTextFeild.textAlignment = NSTextAlignmentCenter;
        _startTimeTextFeild.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _startTimeTextFeild;
}
/** @lazy endTimeTextFeild */
- (UITextField *)endTimeTextFeild {
    if (!_endTimeTextFeild) {
        _endTimeTextFeild = [[UITextField alloc] init];
        _endTimeTextFeild.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _endTimeTextFeild.font = HDAppTheme.TinhNowFont.standard12;
        _endTimeTextFeild.textColor = HDAppTheme.TinhNowColor.G1;
        _endTimeTextFeild.placeholder = TNLocalizedString(@"TvHMC2uy", @"结束时间");
        _endTimeTextFeild.delegate = self;
        _endTimeTextFeild.textAlignment = NSTextAlignmentCenter;
        _endTimeTextFeild.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _endTimeTextFeild;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G3;
    }
    return _lineView;
}
@end


@interface TNIncomeFilterCell ()
/// 圆角背景视图
@property (strong, nonatomic) UIView *containerView;
/// 布局视图
@property (strong, nonatomic) UIStackView *stackView;
/// 筛选视图
@property (strong, nonatomic) UIView *filterView;
/// 全部按钮
@property (strong, nonatomic) HDUIGhostButton *allBtn;
/// 七天
@property (strong, nonatomic) HDUIGhostButton *sevenDaysBtn;
/// 30天
@property (strong, nonatomic) HDUIGhostButton *oneMonthBtn;
/// 自定义
@property (strong, nonatomic) HDUIGhostButton *customizeBtn;
/// 自定义选择时间
@property (strong, nonatomic) TNIncomeCustomizeTimeView *customizeTimeView;
/// 底部视图
@property (strong, nonatomic) UIView *bottomView;
/// 展开收起按钮
@property (strong, nonatomic) HDUIButton *dropBtn;

/// 合计数量
@property (strong, nonatomic) UILabel *totalCountLabel;
/// 合计金额
@property (strong, nonatomic) UILabel *totalMoneyLabel;
///
@property (nonatomic, assign) BOOL isDroped;
///
@property (strong, nonatomic) NSMutableArray *btnsArr;
@end


@implementation TNIncomeFilterCell
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.filterView];
    [self.stackView addArrangedSubview:self.bottomView];
    [self.filterView addSubview:self.allBtn];
    [self.filterView addSubview:self.sevenDaysBtn];
    [self.filterView addSubview:self.oneMonthBtn];
    [self.filterView addSubview:self.customizeBtn];
    [self.filterView addSubview:self.customizeTimeView];
    [self.filterView addSubview:self.totalCountLabel];
    [self.filterView addSubview:self.totalMoneyLabel];
    [self.bottomView addSubview:self.dropBtn];

    self.customizeTimeView.hidden = YES;
    [self.btnsArr addObject:self.sevenDaysBtn];
    [self.btnsArr addObject:self.oneMonthBtn];
    [self.btnsArr addObject:self.allBtn];
}
- (void)setFilterModel:(TNIncomeListFilterModel *)filterModel {
    _filterModel = filterModel;
}
- (void)setSumModel:(TNIncomeCommissionSumModel *)sumModel {
    _sumModel = sumModel;
    if (!HDIsObjectNil(sumModel)) {
        self.totalCountLabel.hidden = NO;
        self.totalMoneyLabel.hidden = NO;
        self.totalCountLabel.text = [NSString stringWithFormat:TNLocalizedString(@"1mqzrw9T", @"合计数：%ld条"), sumModel.total];
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"iW3fflPm", @"合计收益"), sumModel.totalMoney.thousandSeparatorAmount];
    } else {
        self.totalCountLabel.hidden = YES;
        self.totalMoneyLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
#pragma mark -按钮点击
- (void)onClickFilterBtn:(HDUIGhostButton *)btn {
    btn.selected = !btn.isSelected;
    [self changeBtnBackGoundColorWithBtn:btn];
    if (btn == self.customizeBtn) {
        self.customizeBtn.hidden = YES;
        self.customizeTimeView.hidden = NO;
    } else {
        self.customizeBtn.hidden = NO;
        self.customizeTimeView.hidden = YES;
        self.customizeTimeView.startDateStr = @"";
        self.customizeTimeView.endDateStr = @"";
        self.customizeBtn.selected = NO;
        //回调筛选
        !self.filterClickCallBack ?: self.filterClickCallBack(self.filterModel);
    }
}
/// 更改背景颜色
- (void)changeBtnBackGoundColorWithBtn:(HDUIGhostButton *)btn {
    if (btn == self.allBtn) {
        if (self.allBtn.isSelected) {
            self.filterModel.showAll = YES;
        } else {
            self.filterModel.showAll = NO;
        }
        self.filterModel.dailyInterval = nil;
    } else if (btn == self.sevenDaysBtn) {
        if (self.sevenDaysBtn.isSelected) {
            self.filterModel.dailyInterval = @(7);
        } else {
            self.filterModel.dailyInterval = nil;
        }
        self.filterModel.showAll = NO;
    } else if (btn == self.oneMonthBtn) {
        if (self.oneMonthBtn.isSelected) {
            self.filterModel.dailyInterval = @(30);
        } else {
            self.filterModel.dailyInterval = nil;
        }
        self.filterModel.showAll = NO;
    }
    self.filterModel.dateRangeStart = @"";
    self.filterModel.dateRangeEnd = @"";

    for (HDUIGhostButton *temBtn in self.btnsArr) {
        if (btn == temBtn && btn.isSelected) {
            temBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
            temBtn.borderWidth = 0;
            [temBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            temBtn.backgroundColor = [UIColor whiteColor];
            temBtn.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
            temBtn.borderWidth = 0.5;
            [temBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
            temBtn.selected = NO;
        }
    }
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(40));
    }];

    [self.allBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.filterView.mas_left).offset(kRealWidth(18));
        make.height.mas_equalTo(kRealWidth(30));
        make.width.equalTo(self.sevenDaysBtn.mas_width);
    }];
    [self.sevenDaysBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.mas_right).offset(kRealWidth(20));
        make.centerY.equalTo(self.allBtn.mas_centerY);
        make.height.equalTo(self.allBtn.mas_height);
        make.width.equalTo(self.oneMonthBtn.mas_width);
    }];
    [self.oneMonthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sevenDaysBtn.mas_right).offset(kRealWidth(20));
        make.centerY.equalTo(self.allBtn.mas_centerY);
        make.height.equalTo(self.allBtn.mas_height);
        make.right.equalTo(self.filterView.mas_right).offset(-kRealWidth(18));
    }];

    [self.customizeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allBtn.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.allBtn.mas_left);
        make.height.equalTo(self.allBtn.mas_height);
        make.width.equalTo(self.allBtn.mas_width);
    }];

    [self.customizeTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allBtn.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.allBtn.mas_left);
        make.right.equalTo(self.oneMonthBtn.mas_right);
        make.height.equalTo(self.allBtn.mas_height);
    }];

    CGFloat space = 0;
    if (!HDIsObjectNil(self.sumModel)) {
        space = kRealWidth(20);
    }

    [self.totalCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.mas_left);
        make.top.equalTo(self.customizeBtn.mas_bottom).offset(space);
        make.bottom.equalTo(self.filterView.mas_bottom).offset(-space);
    }];

    [self.totalMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.filterView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.customizeBtn.mas_bottom).offset(space);
    }];

    [self.dropBtn sizeToFit];
    [self.dropBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self.bottomView);
    }];
    [super updateConstraints];
}
/** @lazy bottomView */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
/** @lazy dropBtn */
- (HDUIButton *)dropBtn {
    if (!_dropBtn) {
        HDUIButton *btn = [[HDUIButton alloc] init];
        [btn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        [btn setTitle:TNLocalizedString(@"XgYwFZxn", @"展开") forState:UIControlStateNormal];
        [btn setTitle:TNLocalizedString(@"tn_store_less", @"收起") forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"tn_drop_up_triangle"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tn_drop_down_triangle"] forState:UIControlStateSelected];
        btn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        btn.spacingBetweenImageAndTitle = 5;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            btn.selected = !btn.isSelected;
            self.filterView.hidden = !btn.isSelected;
            !self.dropCellCallBack ?: self.dropCellCallBack();
        }];
        _dropBtn = btn;
    }
    return _dropBtn;
}
/** @lazy filterView */
- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] init];
        _filterView.hidden = YES;
    }
    return _filterView;
}
/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = 0;
    }
    return _stackView;
}
/** @lazy allBtn */
- (HDUIGhostButton *)allBtn {
    if (!_allBtn) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] init];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [button setTitle:TNLocalizedString(@"tn_title_all", @"全部") forState:UIControlStateNormal];
        button.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
        button.borderWidth = 0.5;
        [button addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _allBtn = button;
    }
    return _allBtn;
}
/** @lazy sevenDaysBtn */
- (HDUIGhostButton *)sevenDaysBtn {
    if (!_sevenDaysBtn) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] init];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [button setTitle:TNLocalizedString(@"ZtxDc0nT", @"近七天") forState:UIControlStateNormal];
        button.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
        button.borderWidth = 0.5;
        [button addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sevenDaysBtn = button;
    }
    return _sevenDaysBtn;
}
/** @lazy allBtn */
- (HDUIGhostButton *)oneMonthBtn {
    if (!_oneMonthBtn) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] init];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [button setTitle:TNLocalizedString(@"OVdIjzDL", @"近30天") forState:UIControlStateNormal];
        button.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
        button.borderWidth = 0.5;
        [button addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _oneMonthBtn = button;
    }
    return _oneMonthBtn;
}
/** @lazy customizeBtn */
- (HDUIGhostButton *)customizeBtn {
    if (!_customizeBtn) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] init];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [button setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [button setTitle:TNLocalizedString(@"oZpZHOhQ", @"自定义") forState:UIControlStateNormal];
        button.layer.borderColor = HDAppTheme.TinhNowColor.G1.CGColor;
        button.borderWidth = 0.5;
        [button addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _customizeBtn = button;
    }
    return _customizeBtn;
}
/** @lazy totalCountLabel */
- (UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel = [[UILabel alloc] init];
        _totalCountLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _totalCountLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
    }
    return _totalCountLabel;
}
/** @lazy totalMoneyLabel */
- (UILabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[UILabel alloc] init];
        _totalMoneyLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _totalMoneyLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
    }
    return _totalMoneyLabel;
}
/** @lazy customizeTimeView */
- (TNIncomeCustomizeTimeView *)customizeTimeView {
    if (!_customizeTimeView) {
        _customizeTimeView = [[TNIncomeCustomizeTimeView alloc] init];
        @HDWeakify(self);
        _customizeTimeView.dateSelectedCallBack = ^(NSString *startTime, NSString *endTime) {
            @HDStrongify(self);
            self.filterModel.dateRangeStart = startTime;
            self.filterModel.dateRangeEnd = endTime;
            self.filterModel.dailyInterval = nil;
            self.filterModel.showAll = NO;
            //回调筛选
            !self.filterClickCallBack ?: self.filterClickCallBack(self.filterModel);
        };
    }
    return _customizeTimeView;
}
/** @lazy btnsArr */
- (NSMutableArray *)btnsArr {
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray array];
    }
    return _btnsArr;
}
/** @lazy  containerView*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8)];
        };
    }
    return _containerView;
}
@end
