//
//  SALoginByThirdPartyTopView.m
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByThirdPartyTopView.h"


@interface SALoginByThirdPartyTopView ()

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UILabel *label;

@end


@implementation SALoginByThirdPartyTopView

- (void)hd_setupViews {
    [self addSubview:self.label];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(kRealWidth(46));
    }];

    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.right.equalTo(self.label.mas_left);
        make.height.mas_equalTo(1);
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.left.equalTo(self.label.mas_right);
        make.height.mas_equalTo(1);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = HDAppTheme.color.sa_C333;
        _label.font = HDAppTheme.font.sa_standard14;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"or";
    }
    return _label;
}

- (UIView *)leftView {
    if (!_leftView) {
        UIView *view = UIView.new;
        _leftView = view;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.startPoint = CGPointMake(0, 0.5);
            gl.endPoint = CGPointMake(1, 0.5);
            gl.colors = @[
                (__bridge id)[UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:0.0].CGColor,
                (__bridge id)[UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:1.0].CGColor
            ];
            gl.locations = @[@(0), @(1.0f)];
            [view.layer addSublayer:gl];
        };
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        UIView *view = UIView.new;
        _rightView = view;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.startPoint = CGPointMake(0, 0.5);
            gl.endPoint = CGPointMake(1, 0);
            gl.colors = @[
                (__bridge id)[UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:0.0].CGColor
            ];
            gl.locations = @[@(0), @(1.0f)];
            [view.layer addSublayer:gl];
        };
    }
    return _rightView;
}

@end
