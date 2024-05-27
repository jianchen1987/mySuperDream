//
//  TNModifyShoppingCountView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModifyShoppingCountView.h"
#import "TNModifyCountAlertView.h"


@interface TNModifyShoppingCountView () <HDUITextFieldDelegate>
/// 当前数量
@property (nonatomic, assign) NSUInteger count;
/// 减
@property (nonatomic, strong) HDUIButton *minusBTN;
/// 加
@property (nonatomic, strong) HDUIButton *plusBTN;
/// 输入框
@property (strong, nonatomic) HDUITextField *textField;
/// 上一次触发回调时的数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 键盘的附加视图
@property (strong, nonatomic) UIToolbar *toolBar;
/// 是否是输入框编辑了
@property (nonatomic, assign) BOOL isTextFieldEdit;
@end


@implementation TNModifyShoppingCountView
- (void)hd_setupViews {
    [self addSubview:self.minusBTN];
    [self addSubview:self.plusBTN];
    [self addSubview:self.textField];
    self.textField.inputTextField.inputAccessoryView = self.toolBar;
    self.step = 1;
    self.minCount = 1; //最小购买数为1
    self.firstStepCount = 1;
    self.oldCount = self.firstStepCount;
    self.maxCount = NSUIntegerMax;
    [self _updateCount:self.minCount];
}
- (void)updateConstraints {
    [self.minusBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(23), kRealWidth(23)));
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kRealWidth(50));
        make.height.mas_equalTo(kRealWidth(23));
        make.left.equalTo(self.minusBTN.mas_right);
    }];
    [self.plusBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.textField.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(23), kRealWidth(23)));
    }];
    [super updateConstraints];
}
- (void)enableOrDisableButton:(BOOL)yor {
    self.plusBTN.enabled = yor;
    self.minusBTN.enabled = yor;
}

- (void)enableOrDisablePlusButton:(BOOL)yor {
    self.plusBTN.enabled = yor;
}

- (void)enableOrDisableMinusButton:(BOOL)yor {
    self.minusBTN.enabled = yor;
}
- (void)updateCount:(NSUInteger)count {
    if (count < 0)
        return;
    self.oldCount = count;
    [self _updateCount:count];
}

#pragma mark - private methods
- (void)_setCount:(NSUInteger)count type:(TNModifyShoppingCountViewOperationType)type {
    [self _updateCount:count];

    if (self.isTextFieldEdit) {
        [self shouldCallHandlerWithCount:count type:type];
        self.isTextFieldEdit = NO;
    } else {
        [HDFunctionThrottle throttleWithInterval:0.3 key:@"com.tinhmnow.function.modifyShoppingCountView" handler:^{
            [self shouldCallHandlerWithCount:count type:type];
        }];
    }
}
- (void)shouldCallHandlerWithCount:(NSUInteger)count type:(TNModifyShoppingCountViewOperationType)type {
    BOOL shouldInvoke = false;
    if (type == TNModifyShoppingCountViewOperationTypePlus) {
        shouldInvoke = count > self.oldCount;
        self.oldCount = count;
    } else {
        shouldInvoke = self.oldCount > count;
        self.oldCount = count;
    }
    if (shouldInvoke) {
        !self.changedCountHandler ?: self.changedCountHandler(type, self.count);
    }
}
- (void)_updateCount:(NSUInteger)count {
    self.count = count;
    self.textField.inputTextField.text = [NSString stringWithFormat:@"%zd", count];
    [self enableOrDisablePlusButton:count < self.maxCount];
    [self setNeedsUpdateConstraints];
}
- (NSInteger)fixBatchNunberCount:(NSInteger)fixCount {
    if (self.step > 1) {
        //有倍数限制的  需要处理一下
        NSInteger temp = fixCount % self.step;
        if (temp != 0) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), self.step] type:HDTopToastTypeWarning];
        }
        if (temp > 0 && fixCount < self.step) {
            fixCount = self.step;

        } else if (temp > 0 && fixCount > self.step) {
            fixCount = fixCount + (self.step - temp);
        }
    }
    return fixCount;
}
#pragma mark -delegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.needShowModifyCountAlertView) {
        TNModifyCountAlertView *alertView = [[TNModifyCountAlertView alloc] initAlertWithCurrentCount:self.textField.validInputText maxCount:self.maxCount minCount:self.minCount];
        @HDWeakify(self);
        alertView.enterCountCallBack = ^(NSString *_Nonnull count) {
            @HDStrongify(self);
            NSInteger fixCount = [self fixBatchNunberCount:count.integerValue];
            [self enterCountFixData:fixCount];
        };
        [alertView show];
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)hd_textFieldShouldEndEditing:(UITextField *)textField {
    NSInteger count = [textField.text integerValue];
    if (self.oldCount == count) {
        return YES;
    }
    self.isTextFieldEdit = YES;
    NSInteger fixCount = [self fixBatchNunberCount:count];
    if (fixCount != count) {
        self.textField.inputTextField.text = [NSString stringWithFormat:@"%ld", fixCount];
    }
    [self enterCountFixData:fixCount];
    return YES;
}

- (void)enterCountFixData:(NSInteger)count {
    if (count <= 0) {
        count = self.minCount;
        self.textField.inputTextField.text = [NSString stringWithFormat:@"%zd", count];
    }
    if (self.oldCount == count) {
        return;
    }
    TNModifyShoppingCountViewOperationType type = TNModifyShoppingCountViewOperationTypeMinus;
    if (self.oldCount < count) {
        type = TNModifyShoppingCountViewOperationTypePlus;
    }
    [self _setCount:count type:type];
}
#pragma mark - event response
- (void)minusBTNClickedHander {
    !self.clickedMinusBTNHandler ?: self.clickedMinusBTNHandler();

    if (self.disableMinusLogic)
        return;

    NSUInteger tmpCount;
    if (self.count >= self.step) {
        tmpCount = self.count - self.step;
    } else {
        tmpCount = self.minCount;
    }
    // 判断是否小于第一步步进值
    if (tmpCount != self.minCount && tmpCount < self.firstStepCount) {
        tmpCount = self.minCount;
    }
    if (self.countShouldChange ? self.countShouldChange(TNModifyShoppingCountViewOperationTypeMinus, tmpCount) : YES) {
        [self _setCount:tmpCount type:TNModifyShoppingCountViewOperationTypeMinus];
    }
}

- (void)plusBTNClickedHander {
    !self.clickedPlusBTNHandler ?: self.clickedPlusBTNHandler();

    if (self.disablePlusLogic)
        return;

    NSUInteger step = self.step;
    // 如果是初始值，判断第一次步进值
    if (self.count == self.minCount) {
        step = self.firstStepCount;
    }

    if (self.count >= self.maxCount) {
        !self.maxCountLimtedHandler ?: self.maxCountLimtedHandler(self.maxCount);
        return;
    }
    NSUInteger tmpCount;
    if (self.count + step <= self.maxCount) {
        tmpCount = self.count + step;
    } else {
        tmpCount = self.maxCount;
    }

    if (self.countShouldChange ? self.countShouldChange(TNModifyShoppingCountViewOperationTypePlus, tmpCount) : YES) {
        [self _setCount:tmpCount type:TNModifyShoppingCountViewOperationTypePlus];
    }
}
- (void)setMaxCount:(NSUInteger)maxCount {
    _maxCount = maxCount;
}
- (HDUIButton *)minusBTN {
    if (!_minusBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"tn_shopping_minus"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tn_shopping_minus_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(minusBTNClickedHander) forControlEvents:UIControlEventTouchUpInside];
        _minusBTN = button;
    }
    return _minusBTN;
}
- (HDUIButton *)plusBTN {
    if (!_plusBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"tn_shopping_add"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tn_shopping_add_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(plusBTNClickedHander) forControlEvents:UIControlEventTouchUpInside];
        _plusBTN = button;
    }
    return _plusBTN;
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
        config.firstDigitCanNotEnterZero = YES;
        config.characterSetString = kCharacterSetStringNumber;
        config.bottomLineNormalHeight = 0;
        [textField setConfig:config];
        textField.hd_borderPosition = HDViewBorderPositionTop | HDViewBorderPositionBottom;
        textField.hd_borderColor = HDAppTheme.TinhNowColor.cADB6C8;
        textField.hd_borderWidth = 0.5;
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

/** @lazy toolBar */
- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(45))];
        HDUIButton *cancelBtn = [[HDUIButton alloc] init];
        [cancelBtn setTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HDAppTheme.TinhNowColor.G3 forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        @HDWeakify(self);
        [cancelBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.textField resignFirstResponder];
        }];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];

        HDUIButton *doneBtn = [[HDUIButton alloc] init];
        [doneBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [doneBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        [doneBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.textField resignFirstResponder];
        }];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        [_toolBar setItems:@[cancelItem, doneItem]];
    }
    return _toolBar;
}
@end
