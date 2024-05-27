//
//  SALoginByThirdPartyOrView.m
//  SuperApp
//
//  Created by Tia on 2023/6/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SALoginByThirdPartyOrView.h"


@interface SALoginByThirdPartyOrView ()

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UILabel *label;

@end


@implementation SALoginByThirdPartyOrView


- (void)hd_setupViews {
    [self addSubview:self.label];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.right.equalTo(self.label.mas_left).offset(-27);
        make.height.mas_equalTo(1);
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.left.equalTo(self.label.mas_right).offset(27);
        ;
        make.height.mas_equalTo(1);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = UIColor.sa_C333;
        _label.font = HDAppTheme.font.sa_standard16;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = SALocalizedString(@"login_new2_Or", @"或");
    }
    return _label;
}

- (UIView *)leftView {
    if (!_leftView) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
        _leftView = view;
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
        _rightView = view;
    }
    return _rightView;
}

@end
