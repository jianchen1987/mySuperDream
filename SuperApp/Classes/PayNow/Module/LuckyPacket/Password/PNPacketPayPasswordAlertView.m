//
//  PNPacketPayPasswordAlertView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketPayPasswordAlertView.h"
#import "HDAppTheme+PayNow.h"
#import "HDUIButton.h"
#import "PNMultiLanguageManager.h"
#import "PNUtilMacro.h"
#import "PayHDCheckstandTextField.h"
#import "SALabel.h"
#import "SANotificationConst.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>


@interface PNPacketPayPasswordAlertView () <PayHDCheckstandTextFieldDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *closeBtn;
@property (nonatomic, strong) YYLabel *tipsLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HDUIButton *forgotPwdBtn;
/// 密码输入框
@property (nonatomic, strong) PayHDCheckstandTextField *textField;

@end


@implementation PNPacketPayPasswordAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

- (void)setModel:(PNPacketPayPasswordAlertViewModel *)model {
    _model = model;

    [self setNeedsLayout];
}

#pragma mark - override
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.centerY.equalTo(self.mas_centerY).offset(-kRealWidth(30));
        //        make.top.equalTo(self.mas_top).offset(kRealWidth(100));
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;

    if (WJIsStringNotEmpty(self.model.title)) {
        self.titleLabel.text = self.model.title;
    } else {
        self.titleLabel.text = PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"输入支付密码");
    }

    if (!WJIsObjectNil(self.model.subTitleAtt)) {
        self.tipsLabel.attributedText = self.model.subTitleAtt;
        self.tipsLabel.hidden = NO;
    } else {
        if (WJIsStringNotEmpty(self.model.subTitle)) {
            self.tipsLabel.text = self.model.subTitle;
            self.tipsLabel.hidden = NO;
        } else {
            self.tipsLabel.text = @"";
            self.tipsLabel.hidden = YES;
        }
    }
}

- (void)clearText {
    [self.textField clear];
    [self.textField becomeFirstResponder];
}

- (void)userLogoutHandler {
    [self dismiss];
}

- (void)setupContainerSubViews {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBtn];
    [self.containerView addSubview:self.tipsLabel];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.textField];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
    }];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(16));
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];

    if (!self.tipsLabel.hidden) {
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.containerView.mas_right).offset(-kRealWidth(12));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
        }];
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        if (self.tipsLabel.hidden) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(20));
        }
        make.height.equalTo(@(PixelOne));
    }];

    CGFloat textFieldW = kScreenWidth - 2 * kRealWidth(60);
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textFieldW);
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(textFieldW / 6.f);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kRealWidth(24));
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
}

#pragma mark - PayHDCheckstandTextFieldDelegate
- (void)checkStandTextFieldDidFinishedEditing:(PayHDCheckstandTextField *)paymentField {
    [self endEditing:YES];
    HDLog(@"%@", paymentField.text);
    [paymentField resignFirstResponder];

    if (self.pwdDelegate && [self.pwdDelegate respondsToSelector:@selector(pwd_textFieldDidFinishedEditing:businessObj:view:)]) {
        [self.pwdDelegate pwd_textFieldDidFinishedEditing:paymentField.text businessObj:self.model.businessObj view:self];
    }
}

#pragma mark
- (PayHDCheckstandTextField *)textField {
    if (!_textField) {
        _textField = [[PayHDCheckstandTextField alloc] initWithNumberOfCharacters:6 securityCharacterType:PayHDCheckstandSecurityCharacterTypeSecurityDot
                                                                       borderType:PayHDCheckstandTextFieldBorderTypeHaveRoundedCorner];
        _textField.tintColor = [HDAppTheme.color G4];
        _textField.delegate = self;
    }
    return _textField;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (YYLabel *)tipsLabel {
    if (!_tipsLabel) {
        YYLabel *label = [[YYLabel alloc] init];
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(100);

        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16;
        [button setImage:[UIImage imageNamed:@"pn_packet_pay_pwd_close"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(16), kRealWidth(16), 0);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [self dismiss];
        }];

        _closeBtn = button;
    }
    return _closeBtn;
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
