//
//  PNInfoSwitchView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoSwitchView.h"


@interface PNInfoSwitchView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *subTitleLabel;
@property (nonatomic, strong) UISwitch *valueSwitch;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation PNInfoSwitchView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.valueSwitch];
    [self addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(self.model.titleEdgeInsets.left);
        make.right.mas_equalTo(self.valueSwitch.mas_left).offset(-self.model.titleEdgeInsets.right);
        make.top.mas_equalTo(self.mas_top).offset(self.model.titleEdgeInsets.top);
        if (self.subTitleLabel.hidden) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.titleEdgeInsets.bottom);
        }
    }];

    if (!self.subTitleLabel.hidden) {
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.model.subTitleEdgeInsets.left);
            make.right.mas_equalTo(self.valueSwitch.mas_left).offset(-self.model.subTitleEdgeInsets.right);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(self.model.subTitleEdgeInsets.top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.subTitleEdgeInsets.bottom);
        }];
    }

    [self.valueSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-self.model.switchEdgeInsets.right);
        make.centerY.mas_equalTo(self.model.isCenterToView ? self.mas_centerY : self.titleLabel.mas_centerY);
    }];

    [self.valueSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(self.model.bottomLineSpaceToLeft);
        make.right.mas_equalTo(self.mas_right).offset(-self.model.bottomLineSpaceToRight);
        make.height.equalTo(@(self.model.bottomLineHeight));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.bottomLineHeight);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNInfoSwitchModel *)model {
    _model = model;

    self.backgroundColor = model.backgroundColor;

    self.titleLabel.text = model.title;
    self.titleLabel.textColor = model.titleColor;
    self.titleLabel.font = model.titleFont;

    if (WJIsStringNotEmpty(model.subTitle)) {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = model.subTitle;
        self.subTitleLabel.textColor = model.subTitleColor;
        self.subTitleLabel.font = model.subTitleFont;
    } else {
        self.subTitleLabel.hidden = YES;
    }

    self.valueSwitch.on = model.switchValue;
    self.valueSwitch.onTintColor = model.onTintColor;

    self.lineView.backgroundColor = model.bottomLineColor;
    self.valueSwitch.enabled = model.enable;

    [self setNeedsUpdateConstraints];
}

- (void)update {
    self.model = self.model;
}

- (void)switchOn {
    self.model.switchValue = self.valueSwitch.on;
    !self.model.valueBlock ?: self.model.valueBlock(self.valueSwitch.on);
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        label.hidden = YES;
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UISwitch *)valueSwitch {
    if (!_valueSwitch) {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.onTintColor = HDAppTheme.PayNowColor.mainThemeColor;
        [sw addTarget:self action:@selector(switchOn) forControlEvents:UIControlEventValueChanged];

        _valueSwitch = sw;
    }
    return _valueSwitch;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

@end
