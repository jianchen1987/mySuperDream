//
//  SACancellationApplicationAssetsAndEquityTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationAssetsAndEquityTableViewCell.h"
#import "SAOperationButton.h"


@interface SACancellationApplicationAssetsAndEquityTableViewCell ()
/// 子容器
@property (nonatomic, strong) UIView *bgView;
/// 标题
@property (nonatomic, strong) SALabel *textLB;
/// 副标题
@property (nonatomic, strong) SALabel *subTextLB;
/// 去处理按钮
@property (nonatomic, strong) SAOperationButton *button;

@end


@implementation SACancellationApplicationAssetsAndEquityTableViewCell

- (void)hd_setupViews {
    self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;
    [self.button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.textLB];
    [self.bgView addSubview:self.subTextLB];
    [self.bgView addSubview:self.button];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(8));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(8));
    }];

    [self.textLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(margin);
        make.right.lessThanOrEqualTo(self.button.mas_left).offset(-margin);
    }];

    [self.subTextLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLB);
        make.top.equalTo(self.textLB.mas_bottom).offset(margin);
        make.bottom.equalTo(self.bgView).offset(-margin);
        make.right.lessThanOrEqualTo(self.button.mas_left).offset(-margin);
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.bgView);
        make.height.mas_equalTo(kRealWidth(26));
    }];

    [super updateConstraints];
}

#pragma mark setter
- (void)setModel:(SACancellationAssetModel *)model {
    _model = model;
    self.textLB.text = model.reason;
    self.subTextLB.text = model.suggest;
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bgView;
}

- (SALabel *)textLB {
    if (!_textLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.font = [HDAppTheme.font boldForSize:14];
        l.numberOfLines = 0;
        l.textColor = HDAppTheme.color.G1;
        _textLB = l;
    }
    return _textLB;
}

- (SALabel *)subTextLB {
    if (!_subTextLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.numberOfLines = 0;
        l.font = HDAppTheme.font.standard4;
        l.textColor = [UIColor hd_colorWithHexString:@"#999999"];
        _subTextLB = l;
    }
    return _subTextLB;
}

- (SAOperationButton *)button {
    if (!_button) {
        _button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:SALocalizedStringFromTable(@"go_manage", @"去处理", @"Buttons") forState:UIControlStateNormal];
        [_button applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
        _button.titleLabel.font = HDAppTheme.font.standard4;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

@end
