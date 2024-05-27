//
//  WMOrderChangeReminderView.m
//  SuperApp
//
//  Created by wmz on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderChangeReminderView.h"


@interface WMOrderChangeReminderView () <UITextFieldDelegate>
///标题
@property (nonatomic, strong) HDLabel *tipLB;
///输入底图
@property (nonatomic, strong) SAView *inputV;
///输入框
@property (nonatomic, strong) UITextField *inputTF;
///单位
@property (nonatomic, strong) UIImageView *unitLB;
///美元
@property (nonatomic, strong) HDUIButton *doliBTN;
///瑞尔
@property (nonatomic, strong) HDUIButton *rielBTN;
///选中单位
@property (nonatomic, strong) UIButton *selectBTN;
/// 汇率
@property (nonatomic, strong) HDLabel *exchangeLB;
///提交
@property (nonatomic, strong) SAOperationButton *submitBTN;
///不再提醒
@property (nonatomic, strong) HDUIButton *dontshowBTN;
///单位
@property (nonatomic, copy) NSString *unit;
///汇率 4100
@property (nonatomic, assign) NSInteger rate;
@end


@implementation WMOrderChangeReminderView

- (void)hd_setupViews {
    [self addSubview:self.tipLB];
    [self addSubview:self.inputV];
    [self.inputV addSubview:self.unitLB];
    [self.inputV addSubview:self.inputTF];
    [self addSubview:self.doliBTN];
    [self addSubview:self.rielBTN];
    [self addSubview:self.exchangeLB];
    [self addSubview:self.submitBTN];
    [self.doliBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)updateConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(4));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.inputV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tipLB);
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.unitLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
    }];

    [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unitLB.mas_right).offset(kRealWidth(4));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.doliBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputV);
        make.top.equalTo(self.inputV.mas_bottom).offset(kRealWidth(10));
    }];

    [self.rielBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.doliBTN.mas_right).offset(kRealWidth(12));
        make.centerY.equalTo(self.doliBTN);
    }];

    [self.exchangeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputV);
        make.centerY.equalTo(self.doliBTN);
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputV);
        make.top.equalTo(self.doliBTN.mas_bottom).offset(kRealWidth(33));
        make.height.mas_equalTo(kRealWidth(44));
    }];

    if (self.isShowDontshowBTN) {
        [self addSubview:self.dontshowBTN];
        [self.dontshowBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.top.equalTo(self.submitBTN.mas_bottom).offset(kRealWidth(8));
        }];
    }
    [self.unitLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.unitLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setPayModel:(SAMoneyModel *)payModel {
    _payModel = payModel;
    
    NSString *exchangeRate = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyYumNowExchangeRate];
    if(HDIsStringEmpty(exchangeRate)) {
        exchangeRate = @"4100";
    }
    
    NSString *money = payModel.centFace;
    if (![self.unit isEqualToString:@"$"]) {
        money = [NSString stringWithFormat:@"%.0f", money.doubleValue * exchangeRate.integerValue];
    }
    self.inputTF.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:WMLocalizedString(@"order_submit_Order_payable", @"订单应付:%@%@"), self.unit, WMFillEmpty(money)]
                                        attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.CCCCCC}];
    self.exchangeLB.text = [NSString stringWithFormat:@"%@:1:%@", WMLocalizedString(@"exchange_rate", @"汇率"), exchangeRate];
    [self setNeedsUpdateConstraints];
}

- (void)changeAction:(UITextField *)te {
//    self.submitBTN.enabled = !HDIsStringEmpty(te.text) && [te.text doubleValue] > 0;
}

///限制只能输入金额
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self.unit isEqualToString:@"$"]) {
        if (toBeString.length > 9 || [toBeString doubleValue] > 999999.99)
            return NO;
    } else {
        if (toBeString.length > 13 || [toBeString doubleValue] > 9999999999.99)
            return NO;
    }
    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        if (toBeString.length > [toBeString rangeOfString:@"."].location + 3) {
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    if ([textField.text isEqualToString:@"0"]) {
        if (!([string isEqualToString:@"."] || [string isEqualToString:@""])) {
            return NO;
        }
    }
    if ([toBeString isEqualToString:@"."]) {
        textField.text = @"0";
        return YES;
    }
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    if (self.isShowDontshowBTN) {
        self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.dontshowBTN.frame) + kRealWidth(8));
    } else {
        self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.submitBTN.frame) + kRealWidth(8));
    }
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        HDLabel *la = HDLabel.new;
        la.numberOfLines = 0;
        la.textColor = HDAppTheme.WMColor.B6;
        la.text = WMLocalizedString(@"order_submit_Your_order_is_a_cash_on_delivery", @"如需找零，请填写您准备的金额，以便骑手能提前备好零钱");
        la.font = [HDAppTheme.WMFont wm_ForSize:14];
        _tipLB = la;
    }
    return _tipLB;
}

- (SAView *)inputV {
    if (!_inputV) {
        _inputV = SAView.new;
        _inputV.layer.backgroundColor = HDAppTheme.WMColor.F6F6F6.CGColor;
    }
    return _inputV;
}

- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = UITextField.new;
        _inputTF.font = [HDAppTheme.WMFont wm_ForMoneyDinSize:16];
        _inputTF.keyboardType = UIKeyboardTypeDefault;
        _inputTF.delegate = self;
        _inputTF.returnKeyType = UIReturnKeyDone;
        _inputTF.textColor = HDAppTheme.WMColor.B3;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputTF addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTF;
}

- (UIImageView *)unitLB {
    if (!_unitLB) {
        _unitLB = UIImageView.new;
        _unitLB.image = [UIImage imageNamed:@"yn_icon_dollar"];
    }
    return _unitLB;
}

- (HDLabel *)exchangeLB {
    if (!_exchangeLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.WMColor.B6;
        la.font = [HDAppTheme.WMFont wm_ForSize:12];
        _exchangeLB = la;
    }
    return _exchangeLB;
}

- (HDUIButton *)doliBTN {
    if (!_doliBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedString(@"note_Dollar", @"美元") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_sel"] forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = false;
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        btn.spacingBetweenImageAndTitle = kRealWidth(2);
        btn.imagePosition = HDUIButtonImagePositionLeft;
        @HDWeakify(self)
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)
            if (self.selectBTN) {
                self.selectBTN.selected = NO;
            }
            self.unit = @"$";
            [self setPayModel:self.payModel];
            self.unitLB.image = [UIImage imageNamed:@"yn_icon_dollar"];
            btn.selected = YES;
            self.selectBTN = btn;
        }];
        btn.selected = YES;
        _doliBTN = btn;
    }
    return _doliBTN;
}

- (HDUIButton *)rielBTN {
    if (!_rielBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedString(@"note_Riel", @"瑞尔") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_sel"] forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = false;
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        btn.spacingBetweenImageAndTitle = kRealWidth(2);
        btn.imagePosition = HDUIButtonImagePositionLeft;
        @HDWeakify(self)
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)
            if (self.selectBTN) {
                self.selectBTN.selected = NO;
            }
            self.unit = @"៛";
            [self setPayModel:self.payModel];
            btn.selected = YES;
            self.unitLB.image = [UIImage imageNamed:@"yn_icon_riel"];
            self.selectBTN = btn;
        }];
        _rielBTN = btn;
    }
    return _rielBTN;
}

- (HDUIButton *)dontshowBTN {
    if (!_dontshowBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:HDAppTheme.WMColor.B9 forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedString(@"order_submit_Don't_remind_next_time", @"下次不再提醒") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_bottom_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_radio_bottom_sel"] forState:UIControlStateSelected];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.adjustsButtonWhenHighlighted = false;
        btn.spacingBetweenImageAndTitle = kRealWidth(4);
        btn.imagePosition = HDUIButtonImagePositionLeft;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            btn.selected = !btn.selected;
            NSString *key = [NSString stringWithFormat:@"%@_WM_ChangeReminder", SAUser.shared.operatorNo];
            if (btn.isSelected) {
                [NSUserDefaults.standardUserDefaults setValue:@(YES) forKey:key];
            } else {
                [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
            }
        }];
        _dontshowBTN = btn;
    }
    return _dontshowBTN;
}

- (HDUIButton *)submitBTN {
    if (!_submitBTN) {
        SAOperationButton *btn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        btn.adjustsButtonWhenHighlighted = false;
        btn.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        btn.layer.cornerRadius = kRealWidth(22);
        [btn applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
//        btn.enabled = NO;
        @HDWeakify(self)
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)
            NSString *resultStr = nil;
            if(!HDIsStringEmpty(self.inputTF.text)) {
                if ([self.unit isEqualToString:@"$"]) {
                    if (self.inputTF.text.doubleValue < self.payModel.centFace.doubleValue) {
                        [HDTips showError:WMLocalizedString(@"order_submit_Amount_entered_cannot_be_less_than_payable_amount", @"输入金额不可小于应付金额") inView:self];
                        return;
                    }
                } else {
                    NSString *exchangeRate = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyYumNowExchangeRate];
                    if(HDIsStringEmpty(exchangeRate)) {
                        exchangeRate = @"4100";
                    }
                    
                    if ((self.inputTF.text.doubleValue / exchangeRate.integerValue) < self.payModel.centFace.doubleValue) {
                        [HDTips showError:WMLocalizedString(@"order_submit_Amount_entered_cannot_be_less_than_payable_amount", @"输入金额不可小于应付金额") inView:self];
                        return;
                    }
                }
                resultStr = [NSString stringWithFormat:@"%@%@", self.unit, self.inputTF.text];
            }
            if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock(resultStr);
            }
        }];
        _submitBTN = btn;
    }
    return _submitBTN;
}

@end
