//
//  PNMSTimeView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSTimeView.h"
#import "PNTimePickerViewController.h"

typedef void (^BtnClickBlock)(void);


@interface PNMSTimeItemView : PNView
@property (nonatomic, copy) BtnClickBlock clickBlock;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *dateLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDUIButton *dateBtn;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *showValue;
@end


@implementation PNMSTimeItemView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.dateLabel];
    [self.bgView addSubview:self.arrowImgView];
    [self addSubview:self.dateBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
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
- (void)setShowValue:(NSString *)showValue {
    _showValue = showValue;

    self.dateLabel.text = self.showValue;
    self.dateLabel.textColor = HDAppTheme.PayNowColor.c333333;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.dateLabel.text = self.titleStr;
    [self setNeedsUpdateConstraints];
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
        label.text = PNLocalizedString(@"select_start_date", @"选择开始时间");
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
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock();
        }];

        _dateBtn = button;
    }
    return _dateBtn;
}
@end


@interface PNMSTimeView () <PNTimePickerViewDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) PNMSTimeItemView *startView;
@property (nonatomic, strong) PNMSTimeItemView *endView;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) NSInteger currentSelect;
@end


@implementation PNMSTimeView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.itemWidth = (kScreenWidth - kRealWidth(12) * 3) / 2.f;
    [self addSubview:self.titleLabel];
    [self addSubview:self.startView];
    [self addSubview:self.endView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
    }];

    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.width.mas_equalTo(self.itemWidth);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.endView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startView.mas_right).offset(kRealWidth(12));
        make.width.mas_equalTo(self.startView);
        make.top.bottom.equalTo(self.startView);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)setStart:(NSString *)start end:(NSString *)end {
    NSArray *startArray = [start componentsSeparatedByString:@":"];
    if (startArray.count > 1) {
        self.startHour = [startArray objectAtIndex:0];
        self.startMinute = [startArray objectAtIndex:1];
    }

    NSArray *endArray = [end componentsSeparatedByString:@":"];
    if (endArray.count > 1) {
        self.endHour = [endArray objectAtIndex:0];
        self.endMinute = [endArray objectAtIndex:1];
    }

    self.startView.showValue = start;
    self.endView.showValue = end;
}

- (void)selectHandle:(NSInteger)type {
    self.currentSelect = type;

    PNTimePickerViewController *vc = [[PNTimePickerViewController alloc] init];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[SAWindowManager visibleViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)cityPickerView:(PNTimePickerView *)pickView didSelectHour:(NSString *)hour minute:(NSString *)minute {
    NSString *showValue = [NSString stringWithFormat:@"%@:%@", hour, minute];
    if (self.currentSelect == 0) {
        self.startHour = hour;
        self.startMinute = minute;
        self.startView.showValue = showValue;
    } else {
        self.endHour = hour;
        self.endMinute = minute;
        self.endView.showValue = showValue;
    }

    NSString *start = @"";
    if (WJIsStringNotEmpty(self.startHour) && WJIsStringNotEmpty(self.startMinute)) {
        start = [NSString stringWithFormat:@"%@:%@", self.startHour, self.startMinute];
    }
    NSString *end = @"";
    if (WJIsStringNotEmpty(self.endHour) && WJIsStringNotEmpty(self.endMinute)) {
        end = [NSString stringWithFormat:@"%@:%@", self.endHour, self.endMinute];
    }
    !self.selectBlock ?: self.selectBlock(start, end);
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"pn_Operation_time", @"营业时间");
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNMSTimeItemView *)startView {
    if (!_startView) {
        _startView = [[PNMSTimeItemView alloc] init];
        _startView.titleStr = PNLocalizedString(@"select_start_date", @"选择开始时间");
        @HDWeakify(self);
        _startView.clickBlock = ^{
            @HDStrongify(self);
            [self selectHandle:0];
        };
    }
    return _startView;
}

- (PNMSTimeItemView *)endView {
    if (!_endView) {
        _endView = [[PNMSTimeItemView alloc] init];
        _endView.titleStr = PNLocalizedString(@"select_end_date", @"选择结束日期");
        @HDWeakify(self);
        _endView.clickBlock = ^{
            @HDStrongify(self);
            [self selectHandle:1];
        };
    }
    return _endView;
}
@end
