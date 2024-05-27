//
//  PNMSInputAmountView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSInputAmountView.h"
#import "NSString+matchs.h"
#import "PNCommonUtils.h"
#import "PNMSWithdrawViewModel.h"
#import "PNSingleSelectedAlertView.h"
#import "SAMoneyModel.h"


@interface PNMSInputAmountView ()
@property (nonatomic, strong) SALabel *titleLabe;
@property (nonatomic, strong) HDUIButton *currencyBtn;
@property (nonatomic, strong) SALabel *balanceLabel;
@property (nonatomic, strong) UIView *inputBgView;
@property (nonatomic, strong) SALabel *amountTitleLabel;
@property (nonatomic, strong) HDUITextField *inputTF;
@property (nonatomic, strong) YYLabel *canWithdrawLabel;
@property (nonatomic, strong) PNOperationButton *nextBtn;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;

@end


@implementation PNMSInputAmountView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.titleLabe];
    [self.scrollViewContainer addSubview:self.currencyBtn];
    [self.scrollViewContainer addSubview:self.balanceLabel];
    [self.scrollViewContainer addSubview:self.inputBgView];

    [self.inputBgView addSubview:self.amountTitleLabel];
    [self.inputBgView addSubview:self.inputTF];
    [self.inputBgView addSubview:self.canWithdrawLabel];

    [self addSubview:self.nextBtn];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSString *moneyStr = [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.viewModel.balanceInfoModel.balance] currencyCode:self.viewModel.balanceInfoModel.currency];
        [self setText];
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", PNLocalizedString(@"Balance", @"余额"), moneyStr];
        [self.currencyBtn setTitle:self.viewModel.selectCurrency forState:UIControlStateNormal];

        if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeKHR]) {
            HDUITextFieldConfig *config = [self.inputTF getCurrentConfig];
            config.maxDecimalsCount = 0;
            config.characterSetString = kCharacterSetStringNumber;
            config.leftLabelString = [PNCommonUtils getCurrencySymbolByCode:self.viewModel.selectCurrency];
            [self.inputTF setConfig:config];
        } else {
            HDUITextFieldConfig *config = [self.inputTF getCurrentConfig];
            config.maxDecimalsCount = 2;
            config.characterSetString = kCharacterSetStringAmount;
            config.leftLabelString = [PNCommonUtils getCurrencySymbolByCode:self.viewModel.selectCurrency];
            [self.inputTF setConfig:config];
        }
    }];

    [self.viewModel getMSBalance];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.nextBtn.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.titleLabe sizeToFit];
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(22));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
    }];

    [self.currencyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.titleLabe.mas_centerY);
        make.width.equalTo(@(150));
    }];

    [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(24));
        make.top.mas_equalTo(self.currencyBtn.mas_bottom);
    }];

    [self.inputBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.amountTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.inputBgView.mas_top).offset(kRealWidth(16));
        make.right.mas_equalTo(self.inputBgView.mas_right).offset(-kRealWidth(12));
    }];

    [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.inputBgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.amountTitleLabel.mas_bottom);
    }];

    [self.canWithdrawLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountTitleLabel);
        make.top.mas_equalTo(self.inputTF.mas_bottom).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.inputBgView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(20) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.inputTF.validInputText) && [self.inputTF.validInputText matches:REGEX_AMOUNT] && self.inputTF.validInputText.doubleValue > 0) {
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}

#pragma mark 币种切换
- (void)payBalanceBtnTap {
    HDLog(@"payBalanceBtnTap");
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNLocalizedString(@"USD_account", @"美元账户");
    model.itemId = [NSString stringWithFormat:@"%@", PNCurrencyTypeUSD];
    if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeUSD]) {
        model.isSelected = YES;
    }

    PNSingleSelectedModel *model2 = [[PNSingleSelectedModel alloc] init];
    model2.name = PNLocalizedString(@"KHR_account", @"瑞尔账户");
    model2.itemId = [NSString stringWithFormat:@"%@", PNCurrencyTypeKHR];
    if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeKHR]) {
        model2.isSelected = YES;
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:@[model, model2] title:PNLocalizedString(@"pn_Withdrawal_account", @"提现账户")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        HDLog(@"返回==%@", model.itemId);
        if ([model.itemId isEqualToString:PNCurrencyTypeUSD]) {
            self.viewModel.selectCurrency = PNCurrencyTypeUSD;
        } else {
            self.viewModel.selectCurrency = PNCurrencyTypeKHR;
        }
        [self.viewModel getMSBalance];
    };
    [alertView show];
}

- (void)goToBankListVC {
    if ([[PNCommonUtils yuanTofen:self.inputTF.validInputText] integerValue] > self.viewModel.balanceInfoModel.usableBalance.integerValue) {
        [NAT showAlertWithMessage:PNLocalizedString(@"pn_can_not_withdraw_alert", @"不能超过可提现金额") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
                          handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                          }];

        return;
    }

    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesWithdrawToBankVC:@{
        @"currency": self.viewModel.selectCurrency,
        @"amount": self.inputTF.validInputText,
    }];
}

#pragma mark
- (SALabel *)titleLabe {
    if (!_titleLabe) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"pn_witdhdraw_account", @"提现账号");
        _titleLabe = label;
    }
    return _titleLabe;
}

- (HDUIButton *)currencyBtn {
    if (!_currencyBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.viewModel.selectCurrency forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        [button setImage:[UIImage imageNamed:@"pn_icon_black_arrow"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = NO;
        button.imagePosition = HDUIButtonImagePositionRight;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(10), kRealWidth(10), 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(payBalanceBtnTap) forControlEvents:UIControlEventTouchUpInside];

        _currencyBtn = button;
    }
    return _currencyBtn;
}

- (SALabel *)balanceLabel {
    if (!_balanceLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _balanceLabel = label;
    }
    return _balanceLabel;
}

- (UIView *)inputBgView {
    if (!_inputBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
        _inputBgView = view;
    }
    return _inputBgView;
}

- (SALabel *)amountTitleLabel {
    if (!_amountTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"pn_withdarw_amount", @"提现金额");
        _amountTitleLabel = label;
    }
    return _amountTitleLabel;
}

- (YYLabel *)canWithdrawLabel {
    if (!_canWithdrawLabel) {
        _canWithdrawLabel = [[YYLabel alloc] init];
        _canWithdrawLabel.font = HDAppTheme.PayNowFont.standard12;
        _canWithdrawLabel.textColor = HDAppTheme.PayNowColor.c999999;
        [self setText];
    }
    return _canWithdrawLabel;
}

- (void)setText {
    NSString *moneyStr = [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.viewModel.balanceInfoModel.usableBalance] currencyCode:self.viewModel.balanceInfoModel.currency];

    NSString *tempStr = [NSString stringWithFormat:@"%@%@ %@", PNLocalizedString(@"pn_can_withdarw_amount", @"可提现金额:"), moneyStr, PNLocalizedString(@"pn_withdraw_all", @"全部提现")];

    // 1
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tempStr];
    text.yy_lineSpacing = 6;
    text.yy_font = HDAppTheme.PayNowFont.standard12;
    text.yy_color = HDAppTheme.PayNowColor.c999999;

    // 2
    NSString *h1 = PNLocalizedString(@"pn_withdraw_all", @"全部提现");
    [text yy_setTextHighlightRange:[tempStr rangeOfString:h1] color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                             NSString *amountStr = [PNCommonUtils fenToyuan:self.viewModel.balanceInfoModel.usableBalance];
                             [self.inputTF setTextFieldText:amountStr];
                         }];

    _canWithdrawLabel.attributedText = text;
}

- (HDUITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"Please_enter_the_transfer_amount", @"") leftLabelString:@"$"];
        HDUITextFieldConfig *config = [_inputTF getCurrentConfig];
        config.floatingText = @"";
        config.font = [HDAppTheme.PayNowFont fontDINBold:24];
        config.textColor = HDAppTheme.color.G1;
        config.marginBottomLineToTextField = 15;
        config.placeholderFont = [HDAppTheme.font forSize:24];
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];
        config.leftLabelColor = HDAppTheme.PayNowColor.c333333;
        config.leftLabelFont = [HDAppTheme.font boldForSize:24];
        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxInputLength = 10;
        config.characterSetString = kCharacterSetStringAmount;
        config.marginFloatingLabelToTextField = 7;
        config.separatedSymbol = @",";

        [_inputTF setConfig:config];
        __weak __typeof(self) weakSelf = self;
        _inputTF.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleLimit];
        };

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _inputTF.inputTextField;
        _inputTF.inputTextField.inputView = kb;
    }
    return _inputTF;
}

- (PNOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(goToBankListVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
@end
