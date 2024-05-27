//
//  PNAlertInputView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAlertInputView.h"
#import "HDAppTheme+PayNow.h"
#import "PNMultiLanguageManager.h"
#import "PNOperationButton.h"
#import "PNUtilMacro.h"
#import "SALabel.h"
#import "SANotificationConst.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface PNAlertInputView () <HDUITextFieldDelegate>
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 副文本
@property (nonatomic, strong) SALabel *subTitleLabel;
/// 取消按钮 背景view
@property (nonatomic, strong) UIView *cancelBtnBgView;
/// 取消按钮
@property (strong, nonatomic) HDUIButton *cancelBtn;
/// 确定按钮 背景view
@property (nonatomic, strong) UIView *doneBtnBgView;
/// 确定按钮
@property (strong, nonatomic) HDUIButton *doneBtn;
/// 按钮上面的横线
@property (nonatomic, strong) UIView *verLine;
/// 两个按钮之间的 竖线
@property (nonatomic, strong) UIView *horline;
/// 输入框TextField
@property (strong, nonatomic) HDUITextField *textField;
/// 输入框TextView
@property (nonatomic, strong) HDTextView *textView;

@property (nonatomic, strong) PNAlertInputViewConfig *config;
@end


@implementation PNAlertInputView

- (instancetype)initAlertWithConfig:(PNAlertInputViewConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}
#pragma mark - override
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.top.equalTo(self.mas_top).offset(kRealWidth(100));
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;
}

- (void)userLogoutHandler {
    [self dismiss];
}

- (void)setupContainerSubViews {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.subTitleLabel];
    [self.containerView addSubview:self.textField];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:self.cancelBtnBgView];
    [self.cancelBtnBgView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.doneBtnBgView];
    [self.doneBtnBgView addSubview:self.doneBtn];
    [self.containerView addSubview:self.horline];
    [self.containerView addSubview:self.verLine];

    // 设置控件属性
    if (HDIsStringNotEmpty(self.config.textValue)) {
        self.textField.inputTextField.text = self.config.textValue;
    }

    if (WJIsStringNotEmpty(self.config.title)) {
        self.titleLabel.text = self.config.title;
        self.titleLabel.font = self.config.titleFont;
        self.titleLabel.textColor = self.config.titleColor;
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
    }

    if (WJIsStringNotEmpty(self.config.subTitle)) {
        self.subTitleLabel.text = self.config.subTitle;
        self.subTitleLabel.font = self.config.subTitleFont;
        self.subTitleLabel.textColor = self.config.subTitleColor;
        self.subTitleLabel.hidden = NO;
    } else {
        self.subTitleLabel.hidden = YES;
    }

    [self.cancelBtn setTitle:self.config.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:self.config.cancelButtonColor forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = self.config.cancelButtonFont;
    self.cancelBtn.backgroundColor = self.config.cancelButtonBackgroundColor;
    self.cancelBtn.layer.cornerRadius = kRealWidth(4);
    [self.cancelBtn sizeToFit];

    [self.doneBtn setTitle:self.config.doneButtonTitle forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:self.config.doneButtonColor forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = self.config.doneButtonFont;
    self.doneBtn.backgroundColor = self.config.doneButtonBackgroundColor;
    self.doneBtn.layer.cornerRadius = kRealWidth(4);
    [self.doneBtn sizeToFit];

    if (self.config.maxInputLength > 0) {
        HDUITextFieldConfig *config = [self.textField getCurrentConfig];
        config.maxInputLength = self.config.maxInputLength;
        [self.textField setConfig:config];
    }

    if (WJIsStringNotEmpty(self.config.textViewPlaceholder)) {
        self.textView.placeholder = self.config.textViewPlaceholder;
    }
}

- (void)layoutContainerViewSubViews {
    if (!self.titleLabel.hidden) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        }];
    }

    if (!self.subTitleLabel.hidden) {
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.titleLabel.hidden) {
                make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
            }
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        }];
    }

    if (self.config.style == PNAlertInputStyle_textField) {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.subTitleLabel.hidden) {
                make.top.equalTo(self.subTitleLabel.mas_bottom).offset(kRealWidth(17));
            } else {
                if (!self.titleLabel.hidden) {
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(17));
                } else {
                    make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
                }
            }
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
            make.height.equalTo(@(kRealWidth(40)));
        }];
    } else {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.subTitleLabel.hidden) {
                make.top.equalTo(self.subTitleLabel.mas_bottom).offset(kRealWidth(17));
            } else {
                if (!self.titleLabel.hidden) {
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(17));
                } else {
                    make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
                }
            }
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
            make.height.equalTo(@(kRealWidth(68)));
        }];
    }

    [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        if (self.config.style == PNAlertInputStyle_textField) {
            make.top.mas_equalTo(self.textField.mas_bottom).offset(kRealWidth(32));
        } else {
            make.top.mas_equalTo(self.textView.mas_bottom).offset(kRealWidth(24));
        }
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kRealWidth(56));
        make.height.equalTo(@(1));
    }];

    [self.cancelBtnBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left);
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(0.5);
    }];

    [self.doneBtnBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelBtnBgView.mas_right);
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(0.5);
    }];

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.cancelBtnBgView);
        make.width.equalTo(@(self.cancelBtn.width + 32));
        make.height.mas_equalTo(kRealWidth(32));
    }];

    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.doneBtnBgView);
        make.width.equalTo(@(self.doneBtn.width + 32));
        make.height.mas_equalTo(kRealWidth(32));
    }];

    [self.horline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(@(1));
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
    }];

    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.textField becomeFirstResponder];
    //    });
}

#pragma mark
/// 清除文本
- (void)clearText {
    if (self.config.style == PNAlertInputStyle_textField) {
        [self.textField setTextFieldText:@""];
    } else {
        [self.textView setText:@""];
    }
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;

        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.numberOfLines = 0;

        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UIView *)cancelBtnBgView {
    if (!_cancelBtnBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft radius:kRealWidth(8)];
        };
        _cancelBtnBgView = view;
    }
    return _cancelBtnBgView;
}

- (HDUIButton *)cancelBtn {
    if (!_cancelBtn) {
        HDUIButton *btn = [[HDUIButton alloc] init];

        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.config.cancelHandler ?: self.config.cancelHandler(self);
        }];

        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (UIView *)doneBtnBgView {
    if (!_doneBtnBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomRight radius:kRealWidth(8)];
        };
        _doneBtnBgView = view;
    }
    return _doneBtnBgView;
}

- (HDUIButton *)doneBtn {
    if (!_doneBtn) {
        HDUIButton *btn = [[HDUIButton alloc] init];
        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.config.style == PNAlertInputStyle_textField) {
                if (WJIsStringNotEmpty(self.textField.validInputText)) {
                    !self.config.doneHandler ?: self.config.doneHandler(self.textField.validInputText, self);
                }
            } else {
                if (WJIsStringNotEmpty(self.textView.text)) {
                    !self.config.doneHandler ?: self.config.doneHandler(self.textView.text, self);
                }
            }
        }];

        _doneBtn = btn;
    }
    return _doneBtn;
}

- (UIView *)verLine {
    if (!_verLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _verLine = view;
    }
    return _verLine;
}

- (UIView *)horline {
    if (!_horline) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _horline = view;
    }
    return _horline;
}

- (HDUITextField *)textField {
    if (!_textField) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.PayNowFont.standard14;
        config.textColor = HDAppTheme.PayNowColor.c333333;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.textAlignment = NSTextAlignmentCenter;
        config.keyboardType = UIKeyboardTypeDefault;
        config.clearButtonMode = UITextFieldViewModeWhileEditing;

        [textField setConfig:config];
        textField.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textField.layer.cornerRadius = kRealWidth(4);
        textField.delegate = self;

        _textField = textField;
    }
    return _textField;
}

- (HDTextView *)textView {
    if (!_textView) {
        HDTextView *view = HDTextView.new;
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.textColor = HDAppTheme.PayNowColor.c343B4D;
        view.tintColor = HDAppTheme.PayNowColor.mainThemeColor;
        view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        view.maximumTextLength = 500;
        view.placeholderColor = HDAppTheme.color.G3;
        view.font = HDAppTheme.PayNowFont.standard15B;
        view.bounces = YES;
        view.showsVerticalScrollIndicator = false;
        view.scrollEnabled = YES;
        _textView = view;
    }
    return _textView;
}
@end
