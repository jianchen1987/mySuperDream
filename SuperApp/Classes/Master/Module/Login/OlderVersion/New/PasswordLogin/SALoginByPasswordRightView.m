//
//  SALoginByPasswordRightView.m
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByPasswordRightView.h"


@interface SALoginByPasswordRightView ()
/// 显示密码按钮
@property (nonatomic, strong) HDUIButton *hiddenBtn;

@end


@implementation SALoginByPasswordRightView

- (void)hd_setupViews {
    [self addSubview:self.hiddenBtn];
}

- (void)updateConstraints {
    [self.hiddenBtn sizeToFit];
    [self.hiddenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        make.size.mas_equalTo(self.hiddenBtn.frame.size);
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (CGSize)layoutImmediately {
    CGFloat maxHeight = 0;
    [self.hiddenBtn sizeToFit];
    if (CGRectGetHeight(self.hiddenBtn.frame) > maxHeight) {
        maxHeight = CGRectGetHeight(self.hiddenBtn.frame);
    }
    return CGSizeMake(CGRectGetWidth(self.hiddenBtn.frame) + [HDHelper pixelOne], maxHeight);
}

#pragma mark - Event handler
- (void)clickOnHiddenButton:(HDUIButton *)button {
    if (self.showPlainPwdButtonClickedHandler) {
        self.showPlainPwdButtonClickedHandler(button);
    }
}

#pragma mark - config
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - lazy load
/** @lazy hiddenButton */
- (HDUIButton *)hiddenBtn {
    if (!_hiddenBtn) {
        HDUIButton *eyeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        eyeBTN.adjustsButtonWhenHighlighted = false;
        [eyeBTN addTarget:self action:@selector(clickOnHiddenButton:) forControlEvents:UIControlEventTouchUpInside];
        [eyeBTN setImage:[UIImage imageNamed:@"icon_login_password_hide"] forState:UIControlStateNormal];
        [eyeBTN setImage:[UIImage imageNamed:@"icon_login_password_show"] forState:UIControlStateSelected];
        [eyeBTN sizeToFit];
        _hiddenBtn = eyeBTN;
    }
    return _hiddenBtn;
}

@end
