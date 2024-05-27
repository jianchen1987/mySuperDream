//
//  SACancellationApplicationVerifyIdentityView.m
//  SuperApp
//
//  Created by Tia on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationVerifyIdentityView.h"
#import "HDCountDownTimeManager.h"
#import "SACancellationApplicationVerifyIdentityViewModel.h"
#import "SACancelltionApplicationAlertView.h"
#import <YYText/YYText.h>


@interface SACancellationApplicationVerifyIdentityView () <HDUnitTextFieldDelegate>
/// VM
@property (nonatomic, strong) SACancellationApplicationVerifyIdentityViewModel *viewModel;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 提示文言
@property (nonatomic, strong) SALabel *titleLB;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *countDownBTN;
/// 下一步
@property (nonatomic, strong) SAOperationButton *nextBtn;
/// 取消
@property (nonatomic, strong) SAOperationButton *cancelBtn;
/// 协议
@property (nonatomic, strong) YYLabel *tipsLB;

@end


@implementation SACancellationApplicationVerifyIdentityView

static NSString *SACancellationApplicationVerifyIdentityViewCountDownWithKey = @"SACancellationApplicationVerifyIdentityViewCountDownWithKey";

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.normalBackground;

    [self addSubview:self.logoIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.textField];
    [self addSubview:self.countDownBTN];
    [self addSubview:self.tipsLB];

    [self addSubview:self.nextBtn];
    [self addSubview:self.cancelBtn];

    [self handleCountDownTime];
}

- (void)hd_bindViewModel {
    [self.countDownBTN setTitle:SALocalizedStringFromTable(@"get_verification_code", @"获取验证码", @"Buttons") forState:UIControlStateNormal];
    self.countDownBTN.normalStateWidth = [self.countDownBTN sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(20));
        make.centerX.equalTo(self);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(20));
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(20));
        CGFloat width = kScreenWidth - 2 * kRealWidth(25);
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [self updateCountDownBTNConstraints];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.equalTo(self.countDownBTN.mas_bottom).offset(margin);
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-kRealWidth(8));
    }];

    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
    }];

    [super updateConstraints];
}

- (void)updateCountDownBTNConstraints {
    [self.countDownBTN sizeToFit];
    [self.countDownBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(20));
        if (self.countDownBTN.shouldUseNormalStateWidth) {
            make.size.mas_equalTo(CGSizeMake(self.countDownBTN.normalStateWidth, CGRectGetHeight(self.countDownBTN.bounds)));
        } else {
            make.size.mas_equalTo(self.countDownBTN.bounds.size);
        }
    }];
}

- (void)updateSendSMSButtonBorder {
    if (_countDownBTN && !CGSizeIsEmpty(_countDownBTN.bounds.size)) {
        self.countDownBTN.layer.cornerRadius = CGRectGetHeight(self.countDownBTN.frame) * 0.5;
        self.countDownBTN.layer.borderWidth = 1;
        self.countDownBTN.layer.borderColor = [self.countDownBTN titleColorForState:self.countDownBTN.state].CGColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSendSMSButtonBorder];
}

#pragma mark - event response
- (void)clickedNextBtnHandler {
    if (self.textField.text.length != 6)
        return;
    [self showloading];
    [self.viewModel verifySMSCodeWithSmsCode:self.textField.text success:^(NSString *_Nullable apiTicket) {
        if (HDIsStringNotEmpty(apiTicket)) {
            [self.viewModel submitCanncellationApplicationWithApiTicket:apiTicket success:^{
                [self dismissLoading];
                !self.nextBlock ?: self.nextBlock();
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [self dismissLoading];
            }];
        } else {
            [self dismissLoading];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self dismissLoading];
    }];
}

- (void)clickedCancelBtnHandler {
    !self.cancelBlock ?: self.cancelBlock();
}

#pragma mark - private methods
- (void)updateTipsText {
    NSString *stringGray = SALocalizedString(@"ac_tips41", @"无法接收到短信？");
    NSString *stringBlack = SALocalizedString(@"ac_view_help", @"查看帮助");

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[stringGray stringByAppendingString:stringBlack]];
    text.yy_font = HDAppTheme.font.standard4;
    text.yy_color = [UIColor hd_colorWithHexString:@"999999"];
    [text yy_setTextHighlightRange:NSMakeRange(stringGray.length, stringBlack.length) color:HDAppTheme.color.sa_C1 backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             SACancelltionApplicationAlertView *alertView = SACancelltionApplicationAlertView.new;
                             [alertView show];
                         }];
    self.tipsLB.attributedText = text;
    self.tipsLB.textAlignment = NSTextAlignmentLeft;
}

- (void)handleCountDownTime {
    @HDWeakify(self);
    self.countDownBTN.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
        @HDStrongify(self);
        [self showloading];
        [self.viewModel getSMSCodeWithSuccess:^{
            [self dismissLoading];
            [self.textField becomeFirstResponder];
            self.countDownBTN.enabled = NO;
            [self.countDownBTN startCountDownWithSecond:60];
            [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:SACancellationApplicationVerifyIdentityViewCountDownWithKey maxSeconds:60];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            [self dismissLoading];
            self.countDownBTN.enabled = YES;
        }];
    };
    // 获取本地是否有剩余秒数记录
    NSInteger oldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:SACancellationApplicationVerifyIdentityViewCountDownWithKey];
    if (oldSeconds > 1) {
        self.countDownBTN.enabled = false;
        [self.countDownBTN startCountDownWithSecond:oldSeconds];
        // 号码正确才聚焦
        if (HDIsStringNotEmpty(self.viewModel.fullAccountNo)) {
            [self.textField becomeFirstResponder];
        }
    }
}

#pragma mark - HDUnitTextFieldDelegate
- (void)textFieldDidChangeEditing:(HDUnitTextField *)textField {
    self.nextBtn.enabled = textField.text.length == 6;
}

- (BOOL)unitTextField:(HDUnitTextField *)unitTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = nil;
    if (range.location >= unitTextField.text.length) {
        text = [unitTextField.text stringByAppendingString:string];
    } else {
        text = [unitTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return !text || text.hd_isPureDigitCharacters;
}

#pragma mark - lazy load
- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_icon_check_msg"]];
    }
    return _logoIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *l = SALabel.new;
        l.font = [HDAppTheme.font boldForSize:14];
        l.textColor = HDAppTheme.color.G1;
        l.numberOfLines = 0;
        NSString *text = [NSString stringWithFormat:SALocalizedString(@"ac_tips47", @"用手机号码 %@ 获取验证码"), self.viewModel.fullAccountNo];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeString addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.color.sa_C1} range:[text rangeOfString:self.viewModel.fullAccountNo]];
        l.attributedText = attributeString;
        _titleLB = l;
    }
    return _titleLB;
}

- (HDUnitTextField *)textField {
    if (!_textField) {
        _textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:6];
        _textField.trackTintColor = HDAppTheme.color.sa_C1;
        _textField.tintColor = HDAppTheme.color.G3;
        _textField.cursorColor = HDAppTheme.color.sa_C1;
        _textField.textFont = HDAppTheme.font.standard3Bold;
        _textField.borderRadius = 5;
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.delegate = self;
        _textField.unitSpace = kRealWidth(10);
        _textField.textFont = [HDAppTheme.font boldForSize:22];
        [_textField addTarget:self action:@selector(textFieldDidChangeEditing:) forControlEvents:UIControlEventEditingChanged];
        if (@available(iOS 12.0, *)) {
            _textField.textContentType = UITextContentTypeOneTimeCode;
        }
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.needListenToClickOntheBlankSpaceEvent = YES;
    }
    return _textField;
}

- (HDCountDownButton *)countDownBTN {
    if (!_countDownBTN) {
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        button.titleLabel.font = HDAppTheme.font.standard4;
        [button setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateDisabled];
        button.shouldUseNormalStateWidth = YES;
        @HDWeakify(self);
        button.countDownStateChangedHandler = ^(HDCountDownButton *_Nonnull countDownButton, BOOL enabled) {
            @HDStrongify(self);
            [self updateCountDownBTNConstraints];
        };
        button.notNormalStateWidthGreaterThanNormalBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self setNeedsUpdateConstraints];
        };
        button.restoreNormalStateWidthBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self updateCountDownBTNConstraints];
        };
        button.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return SALocalizedStringFromTable(@"reget", @"重新发送", @"Buttons");
        };

        _countDownBTN = button;
    }
    return _countDownBTN;
}

- (YYLabel *)tipsLB {
    if (!_tipsLB) {
        _tipsLB = [[YYLabel alloc] init];
        _tipsLB.preferredMaxLayoutWidth = SCREEN_WIDTH - kRealWidth(40 + 15); //自适应高度
        _tipsLB.numberOfLines = 0;
        _tipsLB.textColor = [UIColor hd_colorWithHexString:@"#999999"];
        _tipsLB.font = HDAppTheme.font.standard4;
        [self updateTipsText];
    }
    return _tipsLB;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(clickedNextBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:SALocalizedStringFromTable(@"confirm_deactivate", @"确定注销", @"Buttons") forState:UIControlStateNormal];
        [_nextBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}

- (SAOperationButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_cancelBtn addTarget:self action:@selector(clickedCancelBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        _cancelBtn.borderColor = HDAppTheme.color.sa_C1;
        [_cancelBtn applyPropertiesWithBackgroundColor:[UIColor clearColor]];
    }
    return _cancelBtn;
}

@end
