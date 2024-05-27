//
//  TNTextFeildAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTextFeildAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore.h>
#import <Masonry.h>


@interface TNTextFeildAlertView () <HDUITextFieldDelegate>
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 取消按钮
@property (strong, nonatomic) HDUIButton *cancelBtn;
/// 确定按钮
@property (strong, nonatomic) HDUIButton *doneBtn;
/// 输入框
@property (strong, nonatomic) HDUITextField *textField;
/// 当前数量
@property (nonatomic, copy) NSString *valueText;

@end


@implementation TNTextFeildAlertView
- (instancetype)initAlertWithTitle:(NSString *)title valueText:(NSString *)valueText placeHold:(NSString *)placeHold {
    if (self = [super init]) {
        self.titleLB.text = title;
        self.textField.inputTextField.text = valueText;
        HDUITextFieldConfig *config = [self.textField getCurrentConfig];
        config.placeholder = placeHold;
        [self.textField setConfig:config];
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

#pragma mark -delegate
- (BOOL)hd_textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - override
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.centerY.equalTo(self.mas_centerY).offset(-kRealWidth(30));
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;
}

- (void)setupContainerSubViews {
    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.textField];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.doneBtn];
}

- (void)layoutContainerViewSubViews {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(17));
        make.height.mas_equalTo(kRealWidth(35));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.containerView);
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(27));
        make.width.equalTo(self.doneBtn.mas_width);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.containerView);
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(27));
        make.left.equalTo(self.cancelBtn.mas_right);
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.textField becomeFirstResponder];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLB.font = [HDAppTheme.TinhNowFont fontSemibold:15];
    }
    return _titleLB;
}
/** @lazy cancelBtn */
- (HDUIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[HDUIButton alloc] init];
        _cancelBtn.backgroundColor = HDAppTheme.TinhNowColor.G5;
        [_cancelBtn setTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        @HDWeakify(self);
        [_cancelBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _cancelBtn;
}
/** @lazy cancelBtn */
- (HDUIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[HDUIButton alloc] init];
        _doneBtn.backgroundColor = HDAppTheme.TinhNowColor.G5;
        [_doneBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [_doneBtn setTitleColor:HDAppTheme.TinhNowColor.C3 forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        @HDWeakify(self);
        [_doneBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            if (HDIsStringNotEmpty(self.textField.validInputText)) {
                !self.enterValueCallBack ?: self.enterValueCallBack(self.textField.validInputText);
            }
        }];
    }
    return _doneBtn;
}
/** @lazy textField */
- (HDUITextField *)textField {
    if (!_textField) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.bottomLineSelectedHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.textAlignment = NSTextAlignmentCenter;
        //        config.characterSetString = kCharacterSetStringNumber;
        //        config.firstDigitCanNotEnterZero = YES;
        [textField setConfig:config];
        textField.layer.borderColor = HDAppTheme.TinhNowColor.cD6DBE8.CGColor;
        textField.layer.borderWidth = 0.5;
        textField.delegate = self;
        _textField = textField;
    }
    return _textField;
}
@end
