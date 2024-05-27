//
//  SAMessageCenterHeaderView.m
//  SuperApp
//
//  Created by Tia on 2023/4/23.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMessageCenterHeaderView.h"


@interface SAMessageCenterHeaderView ()

///  背景图
@property (nonatomic, strong) UIImageView *bgView;

@end


@implementation SAMessageCenterHeaderView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.readButton];
}

- (void)updateConstraints {
    CGFloat margin = 12;

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(kStatusBarH + margin);
        make.height.mas_equalTo(margin * 2.5);
    }];

    [self.readButton sizeToFit];
    [self.readButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-margin);
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo(24);
    }];

    [super updateConstraints];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_bg"]];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.text = SALocalizedString(@"mc_Information", @"消息");
    }
    return _titleLabel;
}

- (HDUIButton *)readButton {
    if (!_readButton) {
        _readButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _readButton.imagePosition = HDUIButtonImagePositionLeft;
        [_readButton setImage:[UIImage imageNamed:@"msg_icon_read"] forState:UIControlStateNormal];
        [_readButton setTitle:SALocalizedString(@"mc_All_Seen", @"全部已读") forState:UIControlStateNormal];
        _readButton.spacingBetweenImageAndTitle = 4;
        _readButton.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 8);
        _readButton.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 0);
        [_readButton setTitleColor:HDAppTheme.color.sa_C666 forState:UIControlStateNormal];
        _readButton.titleLabel.font = HDAppTheme.font.sa_standard12;
        _readButton.layer.borderWidth = 0.5;
        _readButton.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor;
        _readButton.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5000].CGColor;
        _readButton.layer.cornerRadius = 12;
        @HDWeakify(self);
        [_readButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.allRealClickBlock ?: self.allRealClickBlock();
        }];
    }
    return _readButton;
}


@end
