//
//  PNTransPhoneView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransPhoneView.h"
#import "HDPayOrderRspModel.h"
#import "HDTransferOrderBuildRspModel.h"
#import "NSString+matchs.h"
#import "PNCommonUtils.h"
#import "PNOrderResultViewController.h"
#import "PNPaymentComfirmViewController.h"
#import "PNTransPhoneViewModel.h"
#import "PNWalletAcountModel.h"
#import "PayActionSheet.h"
#import "PayHDTradeBuildOrderRspModel.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAMoneyModel.h"


@interface PNTransPhoneView () <HDUITextFieldDelegate, PNPaymentComfirmViewControllerDelegate>
@property (nonatomic, strong) UIImageView *topIconImgView;
@property (nonatomic, strong) SALabel *topTitleLabel;

@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) UIView *phoneBgView;
@property (nonatomic, strong) SALabel *phoneTitleLabel;
@property (nonatomic, strong) HDUITextField *phoneTextField;
@property (nonatomic, strong) SALabel *payAccountLabel;
@property (nonatomic, strong) UIView *balanceBgView;
@property (nonatomic, strong) HDUIButton *balanceButton;

@property (nonatomic, strong) HDUITextField *amountTextField;

@property (nonatomic, strong) SALabel *tipsLabel;

@property (nonatomic, strong) SAOperationButton *confirmButton;

@property (nonatomic, strong) PNTransPhoneViewModel *viewModel;
@end


@implementation PNTransPhoneView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (WJIsObjectNil(self.viewModel.walletAccountModel)) {
            self.scrollViewContainer.hidden = YES;
        } else {
            self.scrollViewContainer.hidden = NO;
            [self updateData];
        }
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.hidden = YES;

    [self.scrollViewContainer addSubview:self.topIconImgView];
    [self.scrollViewContainer addSubview:self.topTitleLabel];

    [self.scrollViewContainer addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.phoneTitleLabel];
    [self.contentBgView addSubview:self.phoneBgView];
    [self.phoneBgView addSubview:self.phoneTextField];

    [self.contentBgView addSubview:self.payAccountLabel];
    [self.contentBgView addSubview:self.balanceButton];

    [self.contentBgView addSubview:self.amountTextField];

    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.confirmButton];

    if (WJIsStringNotEmpty(self.viewModel.phoneNumber)) {
        [self.phoneTextField setTextFieldText:self.viewModel.phoneNumber];
    }
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.width.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.topIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(self.topIconImgView.image.size));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(15));
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
    }];

    [self.topTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.topIconImgView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.contentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.topTitleLabel.mas_bottom).offset(kRealWidth(15));
    }];

    [self.phoneTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(20));
        make.top.mas_equalTo(self.contentBgView.mas_top).offset(kRealWidth(20));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-20));
    }];

    [self.phoneBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(20));
        make.top.mas_equalTo(self.phoneTitleLabel.mas_bottom).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-20));
        make.height.equalTo(@(50));
    }];

    [self.phoneTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.phoneBgView.mas_right).offset(kRealWidth(-20));
        make.centerY.mas_equalTo(self.phoneBgView.mas_centerY).offset(kRealWidth(-6));
    }];

    [self.payAccountLabel sizeToFit];
    [self.payAccountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(20));
        make.top.mas_equalTo(self.phoneBgView.mas_bottom).offset(kRealWidth(20));
        make.right.mas_equalTo(self.balanceButton.mas_left).offset(kRealWidth(-10));
    }];

    [self.balanceButton sizeToFit];
    [self.balanceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payAccountLabel.mas_right).offset(kRealWidth(10));
        //        make.width.equalTo(@(self.balanceButton.width + 30));
        //        make.height.equalTo(@(self.balanceButton.height + 12));
        make.height.equalTo(@(kRealWidth(30)));
        make.centerY.equalTo(self.payAccountLabel);
    }];

    [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(20));
        make.top.mas_equalTo(self.payAccountLabel.mas_bottom).offset(kRealWidth(20));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-20));
        make.bottom.mas_equalTo(self.contentBgView.mas_bottom).offset(kRealWidth(-20));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-20));
        make.top.mas_equalTo(self.contentBgView.mas_bottom).offset(kRealWidth(10));
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(35));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(kRealWidth(-20));
    }];

    [super updateConstraints];
}

#pragma mark
/// 更新数据
- (void)updateData {
    NSString *balanceMoneyStr = @"";
    if ([self.viewModel.selectCurrency isEqualToString:PNCurrencyTypeUSD]) {
        balanceMoneyStr = self.viewModel.walletAccountModel.USD.availableBalanceForWithdraw.amount;
    } else {
        balanceMoneyStr = self.viewModel.walletAccountModel.KHR.availableBalanceForWithdraw.amount;
    }

    NSString *balanceStr = [NSString stringWithFormat:@" %@(%@%@) ",
                                                      self.viewModel.selectCurrency,
                                                      PNLocalizedString(@"Balance", @"余额"),
                                                      [PNCommonUtils thousandSeparatorAmount:balanceMoneyStr currencyCode:self.viewModel.selectCurrency]];

    [self.balanceButton setTitle:balanceStr forState:0];

    [self ruleLimit];

    [self setNeedsUpdateConstraints];
}

/// 处理
- (void)ruleLimit {
    HDLog(@"按钮规则判断");
    /// 手机号  2-3 +6-7
    NSString *phoneStr = self.phoneTextField.validInputText;
    NSString *amountStr = self.amountTextField.validInputText;
    if (WJIsStringNotEmpty(phoneStr) && (phoneStr.length >= 8 && phoneStr.length <= 10) && WJIsStringNotEmpty(amountStr) && [amountStr matches:REGEX_AMOUNT] && amountStr.doubleValue > 0) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma mark
#pragma mark 切换币种账户
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
    model.textColor = HDAppTheme.PayNowColor.c343B4D;
    model.textFont = [HDAppTheme.font boldForSize:15];
    [arr addObject:model];

    model = PaySelectableTableViewCellModel.new;
    model.text = PNLocalizedString(@"KHR_account", @"瑞尔账户");
    model.value = @"KHR";
    model.textColor = HDAppTheme.PayNowColor.c343B4D;
    model.textFont = [HDAppTheme.font boldForSize:15];
    [arr addObject:model];
    @HDWeakify(self);
    [sheet showPayActionSheetView:arr CallBack:^(PaySelectableTableViewCellModel *model) {
        @HDStrongify(self);
        HDLog(@"返回==%@", model.value);
        if ([model.value isEqualToString:@"USD"]) {
            self.viewModel.selectCurrency = PNCurrencyTypeUSD;

            HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
            config.maxDecimalsCount = 2;
            config.characterSetString = kCharacterSetStringAmount;
            config.leftLabelString = @"$";
            [self.amountTextField setConfig:config];
        } else {
            self.viewModel.selectCurrency = PNCurrencyTypeKHR;

            HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
            config.maxDecimalsCount = 0;
            config.characterSetString = kCharacterSetStringNumber;
            config.leftLabelString = @"៛";
            [self.amountTextField setConfig:config];
        }

        [self.amountTextField setTextFieldText:@""];
        [self.viewModel getMyWalletBalance];
    }];
}

#pragma mark 确认转账
- (void)confirmTransferAction {
    NSString *payeePhoneNo = @"";
    if (![[self.phoneTextField.validInputText substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        payeePhoneNo = [NSString stringWithFormat:@"8550%@", self.phoneTextField.validInputText]; //补零
    } else {
        payeePhoneNo = [NSString stringWithFormat:@"855%@", self.phoneTextField.validInputText];
    }

    NSDictionary *dict = @{
        @"payeeNo": payeePhoneNo,
        @"amt": [PNCommonUtils yuanTofen:self.amountTextField.validInputText],
        @"cy": self.viewModel.selectCurrency,
        @"bizType": PNTransferTypeToPhone,
    };

    [self showloading];
    @HDWeakify(self);
    [self.viewModel confirmTransferToPhone:dict success:^(HDTransferOrderBuildRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
        buildModel.tradeNo = rspModel.tradeNo;
        buildModel.subTradeType = PNTradeSubTradeTypeToPhone;

        PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
        vc.delegate = self;
        [self.viewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark PNPaymentComfirmViewControllerDelegate
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];
    [self paymentComplete:payOrderRspModel];
    [controller removeFromParentViewController];
}

#pragma mark - 支付完成
//支付完成 跳转到 交易详情
- (void)paymentComplete:(HDPayOrderRspModel *)rspModel {
    PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] init];
    //    rspModel.subPayTradeType =
    rspModel.receiveBankName = @"";
    rspModel.remark = @"";
    rspModel.payeeStoreName = @"";
    rspModel.payeeStoreLocation = @"";

    vc.type = resultPage;
    vc.rspModel = rspModel;
    __weak __typeof(self) weakSelf = self;
    vc.clickedDoneBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf.viewController.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
    };
    [self.viewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark
#pragma mark HDUITextFiled Delegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.phoneTextField.inputTextField == textField) {
        self.phoneBgView.layer.borderWidth = 1;
    }

    return YES;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    if (self.phoneTextField.inputTextField == textField) {
        self.phoneBgView.layer.borderWidth = 0;
    }

    [self ruleLimit];
}

#pragma mark
- (UIImageView *)topIconImgView {
    if (!_topIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_trans_to_phone"];
        _topIconImgView = imageView;
    }
    return _topIconImgView;
}

- (SALabel *)topTitleLabel {
    if (!_topTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = [HDAppTheme.PayNowFont fontSemibold:19];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"pn_transfer_phone_number", @"向手机号转账");
        _topTitleLabel = label;
    }
    return _topTitleLabel;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _contentBgView = view;
    }
    return _contentBgView;
}

- (SALabel *)phoneTitleLabel {
    if (!_phoneTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [HDAppTheme.PayNowColor.c343B4D colorWithAlphaComponent:0.5];
        label.font = HDAppTheme.PayNowFont.standard15;
        label.text = PNLocalizedString(@"receive_phone", @"收款手机号");
        _phoneTitleLabel = label;
    }
    return _phoneTitleLabel;
}

- (UIView *)phoneBgView {
    if (!_phoneBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.borderWidth = 0;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = kRealWidth(12);
        //        view.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(12)];
        //        };
        _phoneBgView = view;
    }
    return _phoneBgView;
}

- (HDUITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"phone_number", @"") leftLabelString:@" +855(0) "];
        _phoneTextField.delegate = self;
        HDUITextFieldConfig *config = [_phoneTextField getCurrentConfig];
        config.leftLabelFont = HDAppTheme.PayNowFont.standard15;
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.floatingText = @"";
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.maxInputLength = 10;
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];

        [_phoneTextField setConfig:config];
        __weak __typeof(self) weakSelf = self;
        _phoneTextField.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleLimit];
        };
    }
    return _phoneTextField;
}

- (SALabel *)payAccountLabel {
    if (!_payAccountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [HDAppTheme.PayNowColor.c343B4D colorWithAlphaComponent:0.5];
        label.font = HDAppTheme.PayNowFont.standard15;
        label.text = PNLocalizedString(@"pay_account", @"付款账户");
        _payAccountLabel = label;
    }
    return _payAccountLabel;
}

- (HDUIButton *)balanceButton {
    if (!_balanceButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button setTitle:@"USD" forState:0];
        button.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        [button setImage:[UIImage imageNamed:@"pn_arrow_gray_small"] forState:0];
        button.spacingBetweenImageAndTitle = 5;
        [button setImagePosition:HDUIButtonImagePositionRight];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        button.layer.cornerRadius = kRealWidth(15);
        button.layer.masksToBounds = YES;
        button.adjustsButtonWhenHighlighted = NO;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self payBalanceBtnTap];
        }];

        _balanceButton = button;
    }
    return _balanceButton;
}

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"Please_enter_the_transfer_amount", @"") leftLabelString:@"$"];
        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];
        config.floatingText = @"";
        config.font = [HDAppTheme.PayNowFont fontSemibold:25];
        config.textColor = HDAppTheme.color.G1;
        config.marginBottomLineToTextField = 15;
        config.placeholderFont = [HDAppTheme.PayNowFont fontSemibold:18];
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftLabelFont = [HDAppTheme.PayNowFont fontSemibold:36];
        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxInputLength = 10;
        config.characterSetString = kCharacterSetStringAmount;
        config.marginFloatingLabelToTextField = 7;
        config.separatedSymbol = @",";
        config.bottomLineSelectedColor = HDAppTheme.PayNowColor.cFD7127;

        [_amountTextField setConfig:config];
        __weak __typeof(self) weakSelf = self;
        _amountTextField.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleLimit];
        };

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountTextField.inputTextField;
        _amountTextField.inputTextField.inputView = kb;
    }
    return _amountTextField;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFD7127;
        label.font = HDAppTheme.PayNowFont.standard13;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"trans_to_phone_tips", @"说明：转账成功后，收款人可凭提现码、收款手机号前往CoolCash任意网点提现");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:0];
        _confirmButton.enabled = NO;
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self endEditing:YES];
            [self confirmTransferAction];
        }];
    }
    return _confirmButton;
}

@end
