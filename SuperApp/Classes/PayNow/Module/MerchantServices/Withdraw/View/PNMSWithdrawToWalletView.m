//
//  PNMSCaseInView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawToWalletView.h"
#import "HDPayOrderRspModel.h"
#import "NSString+matchs.h"
#import "PNCommonUtils.h"
#import "PNMSOrderDetailsController.h"
#import "PNMSTransferCreateOrderRspModel.h"
#import "PNMSWithdrawViewModel.h"
#import "PNPaymentComfirmViewController.h"
#import "PayActionSheet.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAInfoView.h"
#import "SAMoneyModel.h"


@interface PNMSWithdrawToWalletView () <PNPaymentComfirmViewControllerDelegate>
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) SAInfoView *accountInfoView;
@property (nonatomic, strong) SAInfoView *receiverInfoView;
@property (nonatomic, strong) SAInfoView *balanceInfoView;
@property (nonatomic, strong) UIView *amountBgView;
@property (nonatomic, strong) SALabel *amountTitleLabel;
@property (nonatomic, strong) HDUITextField *amountTextField;
@property (nonatomic, strong) HDUIButton *confirmBtn;

@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSWithdrawToWalletView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSString *moneyStr = [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.viewModel.balanceInfoModel.usableBalance] currencyCode:self.viewModel.balanceInfoModel.currency];
        self.balanceInfoView.model.valueText = [NSString stringWithFormat:@"%@ (%@%@)", self.viewModel.selectCurrency, PNLocalizedString(@"Balance", @"余额"), moneyStr];
        [self.balanceInfoView setNeedsUpdateContent];

        if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeKHR]) {
            HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
            config.maxDecimalsCount = 0;
            config.characterSetString = kCharacterSetStringNumber;
            config.leftLabelString = [PNCommonUtils getCurrencySymbolByCode:self.viewModel.selectCurrency];
            [self.amountTextField setConfig:config];
        } else {
            HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
            config.maxDecimalsCount = 2;
            config.characterSetString = kCharacterSetStringAmount;
            config.leftLabelString = [PNCommonUtils getCurrencySymbolByCode:self.viewModel.selectCurrency];
            [self.amountTextField setConfig:config];
        }
    }];

    [self.viewModel getMSBalance];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.accountInfoView];
    [self.scrollViewContainer addSubview:self.receiverInfoView];
    [self.scrollViewContainer addSubview:self.balanceInfoView];
    [self.scrollViewContainer addSubview:self.amountBgView];
    [self.amountBgView addSubview:self.amountTitleLabel];
    [self.amountBgView addSubview:self.amountTextField];

    [self addSubview:self.confirmBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).offset(kRealWidth(-12));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(16));
    }];

    [self.accountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.receiverInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.accountInfoView.mas_bottom);
    }];

    [self.balanceInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.receiverInfoView.mas_bottom);
    }];

    [self.amountBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left);
        make.right.mas_equalTo(self.scrollViewContainer.mas_right);
        make.top.mas_equalTo(self.balanceInfoView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.amountTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.amountBgView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.amountBgView.mas_top).offset(kRealWidth(16));
    }];

    [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.amountBgView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.amountTitleLabel.mas_bottom).offset(kRealWidth(-6));
        make.bottom.mas_equalTo(self.amountBgView.mas_bottom).offset(kRealWidth(-16));
    }];

    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-20));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(20) + kiPhoneXSeriesSafeBottomHeight));
    }];
    [super updateConstraints];
}

#pragma mark
#pragma mark 币种切换
- (void)payBalanceBtnTap {
    HDLog(@"payBalanceBtnTap");
    PayActionSheet *sheet = PayActionSheet.new;
    if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeUSD]) {
        sheet.DefaultStr = PNLocalizedString(@"USD_account", @"美元账户");
    } else {
        sheet.DefaultStr = PNLocalizedString(@"KHR_account", @"瑞尔账户");
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    PaySelectableTableViewCellModel *model = PaySelectableTableViewCellModel.new;
    model.text = PNLocalizedString(@"USD_account", @"美元账户");
    model.value = @"USD";
    model.textColor = HDAppTheme.PayNowColor.c333333;
    model.textFont = [HDAppTheme.font boldForSize:15];
    [arr addObject:model];

    model = PaySelectableTableViewCellModel.new;
    model.text = PNLocalizedString(@"KHR_account", @"瑞尔账户");
    model.value = @"KHR";
    model.textColor = HDAppTheme.PayNowColor.c333333;
    model.textFont = [HDAppTheme.font boldForSize:15];
    [arr addObject:model];
    @HDWeakify(self);
    [sheet showPayActionSheetView:arr CallBack:^(PaySelectableTableViewCellModel *model) {
        @HDStrongify(self);
        HDLog(@"返回==%@", model.value);
        if ([model.value isEqualToString:PNCurrencyTypeUSD]) {
            self.viewModel.selectCurrency = PNCurrencyTypeUSD;
        } else {
            self.viewModel.selectCurrency = PNCurrencyTypeKHR;
        }
        [self.viewModel getMSBalance];
    }];
}

- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.amountTextField.validInputText) && [self.amountTextField.validInputText matches:REGEX_AMOUNT] && self.amountTextField.validInputText.doubleValue > 0) {
        [self.confirmBtn setEnabled:YES];
    } else {
        [self.confirmBtn setEnabled:NO];
    }
}

// MARK: 下单
- (void)doCreateOrder {
    NSString *amountStr = [self.amountTextField.validInputText hd_trim];

    PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
    buildModel.subTradeType = PNTradeSubTradeTypeMerchantToSelfWallet;
    buildModel.fromType = PNPaymentBuildFromType_MerchantWithdraw;
    buildModel.isShowUnifyPayResult = NO;
    PNPaymentBuildWithdrawExtendModel *extendModel = [[PNPaymentBuildWithdrawExtendModel alloc] init];
    SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", (NSInteger)(amountStr.doubleValue * 100)] currency:self.viewModel.selectCurrency];

    extendModel.caseInAmount = amountModel;
    extendModel.accountName = self.receiverInfoView.model.valueText;
    extendModel.accountNumber = self.accountInfoView.model.valueText;
    extendModel.bankName = @"CoolCash";
    extendModel.operatorNo = self.viewModel.operatorNo;
    extendModel.merchantNo = self.viewModel.merchantNo;
    buildModel.extendWithdrawModel = extendModel;

    PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
    vc.delegate = self;
    [self.viewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
}

#pragma mark
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];
    [self paymentComplete:payOrderRspModel];
    [controller removeFromParentViewController];
}

#pragma mark - 支付完成
//支付完成 跳转到 交易详情
- (void)paymentComplete:(HDPayOrderRspModel *)rspModel {
    @HDWeakify(self);
    void (^clickedDoneBtnHandler)(BOOL) = ^(BOOL success) {
        @HDStrongify(self);
        [self.viewController.navigationController popToViewControllerClass:NSClassFromString(@"PNMSHomeController") animated:YES];
    };

    PNMSOrderDetailsController *vc = [[PNMSOrderDetailsController alloc] initWithRouteParameters:@{
        @"model": [rspModel yy_modelToJSONObject],
        @"viewType": @(1),
        @"merchantNo": self.viewModel.merchantNo,
        @"callback": clickedDoneBtnHandler,
        @"needBalance": @(1),
    }];

    [self.viewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"ms_only_support_tips", @"仅支持提现到本人钱包账户");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = key;
    model.keyFont = HDAppTheme.PayNowFont.standard14B;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.backgroundColor = [UIColor whiteColor];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    return model;
}

- (SAInfoView *)accountInfoView {
    if (!_accountInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Withdrawal_account", @"提现账户")];
        model.valueText = VipayUser.shareInstance.loginName;
        view.model = model;
        _accountInfoView = view;
    }
    return _accountInfoView;
}

- (SAInfoView *)receiverInfoView {
    if (!_receiverInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"ms_receiver", @"收款人")];
        model.valueText = [NSString stringWithFormat:@"%@ %@", VipayUser.shareInstance.lastName ?: @"", VipayUser.shareInstance.firstName ?: @""];
        view.model = model;
        _receiverInfoView = view;
    }
    return _receiverInfoView;
}

- (SAInfoView *)balanceInfoView {
    if (!_balanceInfoView) {
        SAInfoView *view = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"ms_pay_balance", @"付款账户")];
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.enableTapRecognizer = YES;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self payBalanceBtnTap];
        };

        view.model = model;
        _balanceInfoView = view;
    }
    return _balanceInfoView;
}

- (UIView *)amountBgView {
    if (!_amountBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _amountBgView = view;
    }
    return _amountBgView;
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

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"acleda_amount_title", @"输入入金金额")
                                                      leftLabelString:[PNCommonUtils getCurrencySymbolByCode:self.viewModel.selectCurrency]];
        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];
        config.floatingText = @"";
        config.font = [HDAppTheme.PayNowFont fontDINBold:24];
        config.textColor = HDAppTheme.PayNowColor.c333333;
        config.marginBottomLineToTextField = 15;
        config.placeholderFont = [HDAppTheme.font forSize:14];
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];
        config.leftLabelColor = HDAppTheme.PayNowColor.c333333;
        config.leftLabelFont = [HDAppTheme.font boldForSize:24];
        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxInputLength = 10;
        config.characterSetString = kCharacterSetStringAmount;
        config.separatedSymbol = @",";
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.marginBottomLineToTextField = kRealWidth(4);
        [_amountTextField setConfig:config];
        @HDWeakify(self);
        _amountTextField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self ruleLimit];
        };

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountTextField.inputTextField;
        _amountTextField.inputTextField.inputView = kb;
    }
    return _amountTextField;
}

- (HDUIButton *)confirmBtn {
    if (!_confirmBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"confirm_next", @"确认") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        button.enabled = NO;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self doCreateOrder];
        }];

        _confirmBtn = button;
    }
    return _confirmBtn;
}

@end
