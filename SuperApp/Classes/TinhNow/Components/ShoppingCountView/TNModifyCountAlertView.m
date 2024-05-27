//
//  TNModifyCountAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModifyCountAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore.h>
#import <Masonry.h>


@interface TNModifyCountAlertView () <HDUITextFieldDelegate>
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 取消按钮
@property (strong, nonatomic) HDUIButton *cancelBtn;
/// 确定按钮
@property (strong, nonatomic) HDUIButton *doneBtn;
/// 输入框
@property (strong, nonatomic) HDUITextField *textField;
/// 当前数量
@property (nonatomic, copy) NSString *currentCount;
/// 最大购买数
@property (nonatomic, assign) NSInteger maxCount;
/// 最小购买数
@property (nonatomic, assign) NSInteger minCount;
@end


@implementation TNModifyCountAlertView
- (instancetype)initAlertWithCurrentCount:(NSString *)count maxCount:(NSInteger)maxCount minCount:(NSInteger)minCount {
    if (self = [super init]) {
        self.currentCount = count;
        self.maxCount = maxCount;
        self.minCount = minCount;
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
    if (HDIsStringNotEmpty(self.currentCount) && [self.currentCount integerValue] > 0) {
        self.textField.inputTextField.text = self.currentCount;
    }
}

- (void)layoutContainerViewSubViews {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(17));
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(30)));
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
        _titleLB.text = TNLocalizedString(@"hWVJYzUP", @"修改购买数量");
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
                !self.enterCountCallBack ?: self.enterCountCallBack(self.textField.validInputText);
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
        config.font = HDAppTheme.TinhNowFont.standard15B;
        config.textColor = HDAppTheme.TinhNowColor.G2;
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.bottomLineSelectedHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.textAlignment = NSTextAlignmentCenter;
        config.characterSetString = kCharacterSetStringNumber;
        config.firstDigitCanNotEnterZero = YES;
        [textField setConfig:config];
        textField.layer.borderColor = HDAppTheme.TinhNowColor.c5d667f.CGColor;
        textField.layer.borderWidth = 0.5;
        textField.delegate = self;
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            NSInteger count = [text integerValue];
            @HDStrongify(self);
            if (count > self.maxCount) {
                self.textField.inputTextField.text = [NSString stringWithFormat:@"%ld", self.maxCount];
            }
        };
        _textField = textField;
    }
    return _textField;
}
@end
