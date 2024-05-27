//
//  PNBillModifyAccountView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillModifyAmountView.h"
#import "PNBillModifyAmountViewModel.h"
#import "SAInfoView.h"


@interface PNBillModifyAmountView ()
@property (nonatomic, strong) SAInfoView *sectionBalancesInfoView;
@property (nonatomic, strong) UIView *balancesBgView;
@property (nonatomic, strong) UIView *amountBgView;
@property (nonatomic, strong) SALabel *amountTitleLabel;
@property (nonatomic, strong) HDUIButton *currencyButton;
@property (nonatomic, strong) HDUITextField *amountTextField;
@property (nonatomic, strong) HDUIButton *predictButton;

@property (nonatomic, strong) SAInfoView *feeInfoView;
@property (nonatomic, strong) SAInfoView *promotionInfoView;
@property (nonatomic, strong) SAInfoView *totalAmountInfoView;

@property (nonatomic, strong) SAOperationButton *confirmButton;

@property (nonatomic, strong) PNBillModifyAmountViewModel *viewModel;
@end


@implementation PNBillModifyAmountView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.amountTextField setTextFieldText:self.viewModel.balancesInfoModel.billAmount.amount];
        //                                 [self.amountTextField becomeFirstResponder];

        //        if (self.viewModel.balancesInfoModel.feeAmount.amount.doubleValue > 0) {
        //            self.feeInfoView.model.valueText =  self.viewModel.balancesInfoModel.feeAmount.thousandSeparatorAmount;
        //            [self.feeInfoView setNeedsUpdateContent];
        //            self.feeInfoView.hidden = NO;
        //        } else {
        //            self.feeInfoView.hidden = YES;
        //        }
        //
        //        if (self.viewModel.balancesInfoModel.marketingBreadks.amount.doubleValue > 0) {
        //            self.promotionInfoView.model.valueText = self.viewModel.balancesInfoModel.marketingBreadks.thousandSeparatorAmount;
        //            [self.promotionInfoView setNeedsUpdateContent];
        //            self.promotionInfoView.hidden = NO;
        //        } else {
        //            self.promotionInfoView.hidden = YES;
        //        }

        //        if (self.viewModel.balancesInfoModel.totalAmount.amount.doubleValue > 0) {
        //            self.totalAmountInfoView.model.valueText = self.viewModel.balancesInfoModel.totalAmount.thousandSeparatorAmount;
        //            [self.totalAmountInfoView setNeedsUpdateContent];
        //            self.totalAmountInfoView.hidden = NO;
        //        } else {
        //            self.totalAmountInfoView.hidden = YES;
        //        }
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.sectionBalancesInfoView];
    [self.scrollViewContainer addSubview:self.balancesBgView];
    [self.balancesBgView addSubview:self.amountTitleLabel];
    [self.balancesBgView addSubview:self.amountBgView];
    [self.amountBgView addSubview:self.currencyButton];
    [self.amountBgView addSubview:self.amountTextField];
    //    [self.amountBgView addSubview:self.predictButton];
    //    [self.balancesBgView addSubview:self.feeInfoView];
    //    [self.balancesBgView addSubview:self.promotionInfoView];
    //    [self.balancesBgView addSubview:self.totalAmountInfoView];

    [self addSubview:self.confirmButton];

    [self.currencyButton setTitle:self.viewModel.balancesInfoModel.currency forState:0];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(kRealWidth(-20));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    [self.sectionBalancesInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top);
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
    }];

    [self.balancesBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.sectionBalancesInfoView.mas_bottom);
    }];

    [self.amountTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balancesBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.balancesBgView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.balancesBgView.mas_top).offset(kRealWidth(20));
    }];

    [self.amountBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balancesBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.balancesBgView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.amountTitleLabel.mas_bottom).offset(kRealWidth(10));
        make.height.equalTo(@(kRealWidth(44)));
        make.bottom.mas_equalTo(self.balancesBgView.mas_bottom).offset(kRealWidth(-10));
    }];

    [self.currencyButton sizeToFit];
    [self.currencyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.mas_equalTo(self.amountBgView);
        make.width.equalTo(@((self.currencyButton.width + 30)));
    }];

    //    [self.predictButton mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.amountBgView.mas_right).offset(kRealWidth(-7));
    //        make.top.mas_equalTo(self.amountBgView.mas_top).offset(kRealWidth(7));
    //        make.bottom.mas_equalTo(self.amountBgView.mas_bottom).offset(kRealWidth(-7));
    //        make.width.mas_equalTo(@(self.predictButton.width + 20));
    //    }];

    [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currencyButton.mas_right);
        make.right.mas_equalTo(self.amountBgView.mas_right).offset(kRealWidth(-10));
        make.top.mas_equalTo(self.amountBgView.mas_top).offset(kRealWidth(-6));
    }];

    //    UIView *lastView = self.amountBgView;

    //    if (!self.feeInfoView.hidden) {
    //        [self.feeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.right.equalTo(self.balancesBgView);
    //            make.top.mas_equalTo(self.amountBgView.mas_bottom);
    //        }];
    //        lastView = self.feeInfoView;
    //    }

    //    if (!self.promotionInfoView.hidden) {
    //        [self.promotionInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.right.equalTo(self.balancesBgView);
    //            make.top.mas_equalTo(lastView.mas_bottom);
    //        }];
    //        lastView = self.promotionInfoView;
    //    }

    //    [self.totalAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.balancesBgView);
    //        make.top.mas_equalTo(lastView.mas_bottom);
    //        make.bottom.mas_equalTo(self.balancesBgView.mas_bottom);
    //    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneXSeries ? -kiPhoneXSeriesSafeBottomHeight : kRealWidth(-20));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    NSString *amountStr = [self.amountTextField.validInputText hd_trim];
    if (amountStr.doubleValue > 0) {
        self.predictButton.enabled = YES;
    } else {
        self.predictButton.enabled = NO;
    }
}

#pragma mark
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.c9599A2;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
    return model;
}

- (SAInfoView *)sectionBalancesInfoView {
    if (!_sectionBalancesInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"balances_info", @"Balances Info")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:17];
        view.model = model;
        _sectionBalancesInfoView = view;
    }
    return _sectionBalancesInfoView;
}

- (UIView *)balancesBgView {
    if (!_balancesBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _balancesBgView = view;
    }
    return _balancesBgView;
}

- (SALabel *)amountTitleLabel {
    if (!_amountTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.text = PNLocalizedString(@"bill_amount", @"Bill Amount");
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = [HDAppTheme.PayNowFont fontSemibold:14];
        _amountTitleLabel = label;
    }
    return _amountTitleLabel;
}

- (UIView *)amountBgView {
    if (!_amountBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5)];
        };
        _amountBgView = view;
    }
    return _amountBgView;
}

- (HDUIButton *)currencyButton {
    if (!_currencyButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        //        [button setTitle:@"USD" forState:0];
        //        [button setImage:[UIImage imageNamed:@"pn_arrow_down"] forState:0];
        //        [button setImagePosition:HDUIButtonImagePositionRight];
        button.spacingBetweenImageAndTitle = kRealWidth(10);
        button.adjustsButtonWhenHighlighted = NO;
        [button sizeToFit];
        _currencyButton = button;
    }
    return _currencyButton;
}

- (HDUIButton *)predictButton {
    if (!_predictButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        [button setTitle:@"Predict Fee" forState:0];
        button.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        [button sizeToFit];
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(2)];
        };

        //        @HDWeakify(self);
        //        [button addTouchUpInsideHandler:^(UIButton * _Nonnull btn) {
        //            @HDStrongify(self);
        //            [self.amountTextField resignFirstResponder];
        //            NSString *amountStr = [self.amountTextField.validInputText hd_trim];
        //            [self.viewModel billModifyAmount:amountStr];
        //        }];

        _predictButton = button;
    }
    return _predictButton;
}

- (SAInfoView *)feeInfoView {
    if (!_feeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"fee", @"fee")];
        view.model = model;
        _feeInfoView = view;
    }
    return _feeInfoView;
}

- (SAInfoView *)promotionInfoView {
    if (!_promotionInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"promotion", @"promotion")];
        model.valueColor = HDAppTheme.PayNowColor.cFD7127;
        view.model = model;
        _promotionInfoView = view;
    }
    return _promotionInfoView;
}

- (SAInfoView *)totalAmountInfoView {
    if (!_totalAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"total_amount", @"Total Amount")];
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:14.f];
        model.keyColor = HDAppTheme.PayNowColor.c9599A2;
        model.valueFont = [HDAppTheme.PayNowFont fontSemibold:15.f];
        model.lineWidth = 0;
        view.model = model;
        _totalAmountInfoView = view;
    }
    return _totalAmountInfoView;
}

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"please_input_amout", @"请输入金额") leftLabelString:@""];
        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];
        config.floatingText = @"";
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.color.G1;
        config.marginFloatingLabelToTextField = kRealWidth(4);
        config.marginBottomLineToTextField = kRealWidth(15);
        config.placeholderFont = HDAppTheme.PayNowFont.standard15;
        config.placeholderColor = HDAppTheme.color.G3;
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftLabelFont = HDAppTheme.PayNowFont.standard15;
        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        //        config.maxInputLength = 10;
        config.characterSetString = kCharacterSetStringAmount;
        config.textAlignment = NSTextAlignmentLeft;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;

        double max = self.viewModel.balancesInfoModel.maxAmount.thousandSeparatorAmount.integerValue / 100.f;
        config.maxInputNumber = max;

        [_amountTextField setConfig:config];

        //        __weak __typeof(self) weakSelf = self;
        //        _amountTextField.textFieldDidChangeBlock = ^(NSString *text) {
        //            __strong __typeof(weakSelf) strongSelf = weakSelf;
        //            [strongSelf ruleButton];
        //        };

        _amountTextField.delegate = (id)self;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountTextField.inputTextField;
        _amountTextField.inputTextField.inputView = kb;
    }
    return _amountTextField;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") forState:0];
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.viewModel.balancesInfoModel) {
                @HDStrongify(self);
                [self.amountTextField resignFirstResponder];
                NSString *amountStr = [self.amountTextField.validInputText hd_trim];
                if (amountStr.doubleValue == 0) {
                    [NAT showAlertWithMessage:PNLocalizedString(@"input_correct_amount", @"请输入正确的金额") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                                      handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                          [alertView dismiss];
                                      }];
                    return;
                }

                [self.viewModel billModifyAmount:amountStr];
            }
            HDLog(@"click");
        }];
    }
    return _confirmButton;
}

@end
