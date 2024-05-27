//
//  PNFilterDateCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterDateCell.h"
#import "PNMSBillFilterModel.h"
#import "PNUtilMacro.h"
#import "SADatePickerViewController.h"


@interface PNMSFilterDateCell () <SADatePickerViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *dateLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDUIButton *dateBtn;
@end


@implementation PNMSFilterDateCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.dateLabel];
    [self.bgView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.dateBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        //        make.right.mas_lessThanOrEqualTo(self.arrowImgView.mas_left).offset(kRealWidth(-15));
        //        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.equalTo(@(kRealWidth(20)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-12));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        make.left.mas_equalTo(self.dateLabel.mas_right);
    }];

    [self.dateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNMSBillFilterModel *)model {
    _model = model;
    if (WJIsStringNotEmpty(self.model.value)) {
        self.dateLabel.text = self.model.value;
        self.dateLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
    } else {
        self.dateLabel.text = self.model.titleName;
        self.dateLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
    }
}

/// 日期选择
- (void)handleSelectDay {
    SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
    vc.datePickStyle = SADatePickerStyleDMY;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    // 生日不要超过今天
    NSDate *maxDate = [NSDate date];
    // 年龄不超过 130
    NSDate *minDate = [maxDate dateByAddingTimeInterval:-130 * 365 * 24 * 60 * 60.0];

    vc.maxDate = maxDate;
    vc.minDate = minDate;
    vc.delegate = self;

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.viewController.navigationController presentViewController:vc animated:YES completion:nil];

    if (WJIsStringNotEmpty(self.model.value)) {
        NSString *currDateStr = self.model.value;
        [fmt setDateFormat:@"dd/MM/yyyy"];
        NSDate *currDate = [fmt dateFromString:currDateStr];
        if (currDate) {
            [vc setCurrentDate:currDate];
        }
    }
}

#pragma mark SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    NSString *selectDate = date;
    HDLog(@"%@", date);
    self.model.value = selectDate;
    self.dateLabel.text = selectDate;
    self.dateLabel.textColor = HDAppTheme.PayNowColor.c343B4D;

    !self.selectDateBlock ?: self.selectDateBlock(selectDate);
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGRect newFrame = layoutAttributes.frame;
    CGFloat itemW = floor((kScreenWidth - kRealWidth(15) * 3) / 2.f);
    newFrame.size.width = itemW;
    newFrame.size.height = kRealWidth(44);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)dateLabel {
    if (!_dateLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"select_date", @"选择开始时间");
        _dateLabel = label;
    }
    return _dateLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_down_small"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (HDUIButton *)dateBtn {
    if (!_dateBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click beginDate");
            @HDStrongify(self);
            [self handleSelectDay];
        }];

        _dateBtn = button;
    }
    return _dateBtn;
}

@end
