//
//  PNBindMarketingItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBindMarketingItemView.h"
#import "PNMarketingListItemModel.h"


@interface PNBindMarketingItemView ()
@property (nonatomic, assign) PNBindMarketingItemViewType type;
@property (nonatomic, strong) SALabel *oneLabel;
@property (nonatomic, strong) SALabel *twoLabel;
@property (nonatomic, strong) SALabel *thirdLabel;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation PNBindMarketingItemView


- (instancetype)initWithType:(PNBindMarketingItemViewType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.oneLabel];
    [self addSubview:self.twoLabel];
    [self addSubview:self.thirdLabel];
    [self addSubview:self.lineView];
}

- (void)updateConstraints {
    /// 比例 4:4:2
    [self.oneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        if (self.type == PNBindMarketingItemView_Title) {
            make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(12));
        } else {
            make.top.mas_equalTo(self.mas_top).offset(kRealWidth(8));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(8));
        }

        make.width.equalTo(@(kScreenWidth * 0.4));
    }];

    [self.twoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oneLabel.mas_right);
        make.bottom.top.equalTo(self.oneLabel);
        make.width.equalTo(@(kScreenWidth * 0.4));
    }];

    [self.thirdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.twoLabel.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.top.equalTo(self.oneLabel);
    }];

    if (!self.lineView.isHidden) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.equalTo(@(1));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNMarketingListItemModel *)model {
    _model = model;

    self.oneLabel.text = model.friendLoginName;
    self.twoLabel.text = model.friendName ?: @"";

    if (self.type == PNBindMarketingItemView_Title) {
        self.oneLabel.font = HDAppTheme.PayNowFont.standard16B;
        self.twoLabel.font = HDAppTheme.PayNowFont.standard16B;
        self.thirdLabel.font = HDAppTheme.PayNowFont.standard16B;
        self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        self.lineView.hidden = YES;

        self.thirdLabel.text = model.tradeStr;
    } else {
        self.oneLabel.font = HDAppTheme.PayNowFont.standard16;
        self.twoLabel.font = HDAppTheme.PayNowFont.standard16;
        self.thirdLabel.font = HDAppTheme.PayNowFont.standard16;
        self.lineView.hidden = NO;

        self.thirdLabel.text = model.friendSatisfied == 10 ? PNLocalizedString(@"Select_Yes", @"是") : PNLocalizedString(@"Select_NO", @"否");

        if (model.friendSatisfied == 10) {
            self.thirdLabel.textColor = [UIColor hd_colorWithHexString:@"#80BE1F"];
        } else {
            self.thirdLabel.textColor = [UIColor hd_colorWithHexString:@"#F5222D"];
        }
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)oneLabel {
    if (!_oneLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _oneLabel = label;
    }
    return _oneLabel;
}

- (SALabel *)twoLabel {
    if (!_twoLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _twoLabel = label;
    }
    return _twoLabel;
}

- (SALabel *)thirdLabel {
    if (!_thirdLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _thirdLabel = label;
    }
    return _thirdLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

@end
