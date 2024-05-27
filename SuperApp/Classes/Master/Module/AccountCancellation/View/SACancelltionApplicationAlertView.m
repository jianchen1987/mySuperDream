//
//  SACancelltionApplicationAlertView.m
//  SuperApp
//
//  Created by Tia on 2022/6/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancelltionApplicationAlertView.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface SACancelltionApplicationAlertView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 子文本
@property (nonatomic, strong) UILabel *messageLabel;
/// 详情文本
@property (nonatomic, strong) UILabel *detailLabel;
/// 确认按钮
@property (nonatomic, strong) HDUIButton *button;

@end


@implementation SACancelltionApplicationAlertView

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    CGFloat margin = kRealWidth(16);
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.center.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };
    self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
    self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    self.allowTapBackgroundDismiss = false;
    self.solidBackgroundColorAlpha = 0.8;
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.messageLabel];
    [self.containerView addSubview:self.detailLabel];
    [self.containerView addSubview:self.button];
}

- (void)layoutContainerViewSubViews {
    CGFloat margin = kRealWidth(16);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(margin);
    }];

    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(margin);
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(kRealWidth(48));
        make.bottom.mas_equalTo(-margin);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(margin);
    }];
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"#333333"];
        l.font = [HDAppTheme.font boldForSize:16];
        l.textAlignment = NSTextAlignmentCenter;
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        l.text = SALocalizedString(@"ac_tips42", @"收不到验证码");
        _titleLabel = l;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"#333333"];
        l.font = [HDAppTheme.font forSize:14];
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        l.text = SALocalizedString(@"ac_tips43", @"如果没有收到手机验证码，建议您进行以下操作：");
        _messageLabel = l;
    }
    return _messageLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"#999999"];
        l.font = [HDAppTheme.font forSize:12];
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        l.text = [NSString stringWithFormat:@"1.%@\n2.%@\n3.%@",
                                            SALocalizedString(@"ac_tips44", @"检查您的手机是否停机或无网络"),
                                            SALocalizedString(@"ac_tips45", @"检查您的手机号是否输入正确"),
                                            SALocalizedString(@"ac_tips46", @"检查您的验证码短信是否被屏蔽")];
        _detailLabel = l;
    }
    return _detailLabel;
}

- (HDUIButton *)button {
    if (!_button) {
        _button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor hd_colorWithHexString:@"#FC2040"];
        [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _button.titleLabel.font = [HDAppTheme.font boldForSize:16];
        _button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _button;
}

@end
