//
//  TransAmountVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTransAmountViewController.h"
#import "HDPayOrderRspModel.h"
#import "HDTransferOrderBuildRspModel.h"
#import "NSMutableAttributedString+Highlight.h"
#import "NSString+matchs.h"
#import "PNCommonUtils.h"
#import "PNDepositViewController.h"
#import "PNOrderResultViewController.h"
#import "PNPayInfoView.h"
#import "PNPaymentBuildModel.h"
#import "PNPaymentComfirmViewController.h"
#import "PNRspModel.h"
#import "PNTransListDTO.h"
#import "PNWalletAcountModel.h"
#import "PNWalletDTO.h"
#import "PayActionSheet.h"
#import "PayHDTradeBuildOrderRspModel.h"
#import "PayPassWordTip.h"
#import "SAAppEnvManager.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SASettingPayPwdViewController.h"
#import <HDVendorKit/HDWebImageManager.h>


@interface PNTransAmountViewController () <HDUITextFieldDelegate, PNPaymentComfirmViewControllerDelegate>
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *nameLB;
@property (nonatomic, strong) SALabel *acountLB;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *payacountLB;
@property (nonatomic, strong) UIView *payBalanceView;
@property (nonatomic, strong) HDUIButton *payBalanceBtn;
@property (nonatomic, strong) UIImageView *payBalanceImg;
@property (nonatomic, strong) HDUITextField *inputTF;
@property (nonatomic, strong) UIView *remarkView;
@property (nonatomic, strong) SALabel *amountLB;
@property (nonatomic, strong) SALabel *remarkLB;
@property (nonatomic, strong) HDUITextField *remarkInputTF;
@property (nonatomic, strong) SAOperationButton *nextBtn;
@property (nonatomic, strong) HDUIButton *navBtn;
//@property(nonatomic,copy)NSString *currency;
@property (nonatomic, copy) NSString *balance;
//收款店铺
@property (nonatomic, strong) PNPayInfoView *shopView;

@property (nonatomic, strong) PayHDTradeBuildOrderRspModel *buildModel; ///< 下单模型
///
@property (nonatomic, strong) PNTransListDTO *transDTO;
@property (nonatomic, strong) PNWalletDTO *walletDTO;
@property (nonatomic, assign) BOOL isContainCurrency;

@property (nonatomic, copy) NSString *bizType;

@end


@implementation PNTransAmountViewController

/// 风险警告
- (void)showRiskTips {
    if (!self.payeeInfo.certified) {
        NSString *msg = [NSString stringWithFormat:PNLocalizedString(@"pn_risk_tips", @"[%@]没有完成实名认证，您要继续交易吗？"), self.nameLB.text];
        [NAT showAlertWithMessage:msg confirmButtonTitle:PNLocalizedString(@"pn_continue", @"继续") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            [self.inputTF becomeFirstResponder];
        } cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
    if (WJIsStringEmpty(self.cy)) {
        self.cy = PNCurrencyTypeUSD;
        self.isContainCurrency = NO;
    } else {
        self.isContainCurrency = YES;
    }

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.iconImg];
    [self.scrollViewContainer addSubview:self.nameLB];
    [self.scrollViewContainer addSubview:self.acountLB];
    [self.scrollViewContainer addSubview:self.bgView];
    [self.bgView addSubview:self.payacountLB];
    [self.bgView addSubview:self.payBalanceView];
    [self.payBalanceView addSubview:self.payBalanceBtn];
    [self.bgView addSubview:self.inputTF];
    [self.bgView addSubview:self.payBalanceImg];

    [self.bgView addSubview:self.remarkView];
    [self.remarkView addSubview:self.remarkInputTF];
    [self.bgView addSubview:self.shopView];
    [self.scrollViewContainer addSubview:self.nextBtn];
    [self.scrollViewContainer addSubview:self.amountLB];

    [self getAcountBalance];
}

///获取账号余额
- (void)getAcountBalance {
    [self.view showloading];
    @HDWeakify(self);

    [self.walletDTO getMyWalletInfoSuccess:^(PNWalletAcountModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        PNWalletAcountModel *detailModel = rspModel;
        if ([self.cy isEqualToString:PNCurrencyTypeUSD]) {
            self.balance = detailModel.USD.availableBalanceForWithdraw.amount;
        } else {
            self.balance = detailModel.KHR.availableBalanceForWithdraw.amount;
        }
        [self.payBalanceBtn
            setTitle:[NSString stringWithFormat:@" %@(%@%@) ", self.cy, PNLocalizedString(@"Balance", @"余额"), [PNCommonUtils thousandSeparatorAmount:self.balance currencyCode:self.cy]]
            forState:UIControlStateNormal];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark - getters and setters
- (void)setPayeeStoreName:(NSString *)payeeStoreName {
    _payeeStoreName = payeeStoreName;
    if (_payeeStoreName.length > 0) {
        PNTypeModel *model = PNTypeModel.new;
        model.name = PNLocalizedString(@"Collection_shop", @"");
        model.value = self.payeeStoreName;
        [self.shopView.arr addObject:model];
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)setPayeeStoreLocation:(NSString *)payeeStoreLocation {
    _payeeStoreLocation = payeeStoreLocation;
    if (_payeeStoreLocation.length > 0) {
        PNTypeModel *model = PNTypeModel.new;
        model.name = PNLocalizedString(@"location", @"");
        model.value = self.payeeStoreLocation;
        [self.shopView.arr addObject:model];
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)setPayeeInfo:(HDPayeeInfoModel *)payeeInfo {
    _payeeInfo = payeeInfo;
    if (self.pageType == PNTradeSubTradeTypeToBakong) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.headUrl] placeholderImage:[UIImage imageNamed:@"toBakong"]];
        self.payeeAccountNo = _payeeInfo.accountId;
        self.payeeAccountName = _payeeInfo.name;
        NSString *str = @"";
        if (_payeeInfo.phone.length > 0) {
            str = _payeeInfo.payeeLoginName;
        } else {
            str = _payeeInfo.accountId;
        }
        self.nameLB.text = _payeeInfo.name;
        self.acountLB.text = str;
    } else if (self.pageType == PNTradeSubTradeTypeToBank) {
        if ([_payeeInfo.headUrl hasPrefix:@"http"]) {
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.headUrl] placeholderImage:[UIImage imageNamed:@"toBank1"]];
        } else {
            NSString *logoURLStr = [NSString stringWithFormat:@"%@/files/files/app/%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, self.logo];
            HDLog(@"%@", logoURLStr);
            [HDWebImageManager setImageWithURL:logoURLStr placeholderImage:[UIImage imageNamed:@"toBank1"] imageView:self.iconImg];
        }

        self.payeeBankCode = _payeeInfo.participantCode;
        self.payeeAccountNo = _payeeInfo.account;
        self.payeeAccountName = _payeeInfo.accountName;
        self.nameLB.text = _payeeInfo.accountName;
        self.acountLB.text = _payeeInfo.account;
    } else if (self.pageType == PNTradeSubTradeTypeToBakongCode) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.headUrl] placeholderImage:[UIImage imageNamed:@"toBakong"]];
        self.payeeAccountNo = _payeeInfo.accountId;
        self.payeeAccountName = _payeeInfo.name;
        self.nameLB.text = _payeeInfo.name;
        self.acountLB.text = _payeeInfo.payeeLoginName;

    } else if (self.pageType == PNTradeSubTradeTypeCoolCashCashOut) { //出金二维码
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.logoUrl] placeholderImage:[UIImage imageNamed:@"CoolCash"]];
        self.payeeAccountName = _payeeInfo.merName;
        self.nameLB.text = _payeeInfo.merName;
        self.inputTF.inputTextField.enabled = NO;
        [self.inputTF setTextFieldText:_payeeInfo.payAmt];
        self.payBalanceView.userInteractionEnabled = NO;
    } else if (self.pageType == PNTradeSubTradeTypeToAgent) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.headUrl] placeholderImage:[UIImage imageNamed:@"CoolCash"]];
        self.payeeAccountNo = _payeeInfo.accountId;
        self.payeeAccountName = _payeeInfo.name;
        self.nameLB.text = _payeeInfo.name;
        self.acountLB.text = _payeeInfo.payeeLoginName;
    } else if (self.pageType == PNTradeSubTradeTypeToCoolCash) {
        //转账到coolcash 固定coolcash 头像
        self.iconImg.image = [UIImage imageNamed:@"CoolCash"];
        NSString *nameStr = [NSString stringWithFormat:@"%@ %@", _payeeInfo.lastName ? _payeeInfo.lastName : @"", _payeeInfo.firstName ? _payeeInfo.firstName : @""];

        if (WJIsStringEmpty(payeeInfo.firstName) && WJIsStringEmpty(payeeInfo.lastName)) {
            nameStr = payeeInfo.accountName;
        }
        self.nameLB.text = nameStr;
        self.acountLB.text = _payeeInfo.payeeLoginName;
    } else if (self.pageType == PNTradeSubTradeTypeToBakongMerchant) { ///向商家付款
        self.iconImg.image = [UIImage imageNamed:@"CoolCash"];
        self.payeeAccountNo = _payeeInfo.accountId;
        self.payeeAccountName = _payeeInfo.name;
        if (!WJIsObjectNil(_payeeInfo.sceneQrCodeInfoDTO)) {
            if (_payeeInfo.sceneQrCodeInfoDTO.sceneType == 10) {
                self.nameLB.text = _payeeInfo.sceneQrCodeInfoDTO.merName;
            } else {
                NSString *hightStr = _payeeInfo.sceneQrCodeInfoDTO.merName;
                NSString *allStr = [NSString stringWithFormat:@"%@\n%@", hightStr, _payeeInfo.sceneQrCodeInfoDTO.storeName ?: @""];

                self.nameLB.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:[HDAppTheme.font boldForSize:19]
                                                                         highLightColor:HDAppTheme.PayNowColor.c343B4D
                                                                                norFont:[HDAppTheme.font forSize:15]
                                                                               norColor:HDAppTheme.PayNowColor.c9599A2];
            }
        } else {
            self.nameLB.text = _payeeInfo.name;
        }
        self.acountLB.text = _payeeInfo.bakongAccountID;
    } else {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_payeeInfo.headUrl] placeholderImage:[UIImage imageNamed:@"CoolCash"]];
        self.nameLB.text = [NSString stringWithFormat:@"%@ %@", _payeeInfo.lastName ? _payeeInfo.lastName : @"", _payeeInfo.firstName ? _payeeInfo.firstName : @""];
        self.acountLB.text = _payeeInfo.payeeLoginName;
    }

    if (!WJIsObjectNil(payeeInfo.orderAmt)) {
        self.cy = payeeInfo.orderAmt.cy;
        [self.inputTF setTextFieldText:[PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:payeeInfo.orderAmt.cent] currencyCode:payeeInfo.orderAmt.cy]];
        self.inputTF.userInteractionEnabled = NO;
        self.inputTF.hidden = YES;
        self.amountLB.text = [NSString stringWithFormat:@"%@  %@",
                                                        [PNCommonUtils getCurrencySymbolByCode:self.cy],
                                                        [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:payeeInfo.orderAmt.cent]
                                                                                                      currencyCode:payeeInfo.orderAmt.cy]];
        self.nextBtn.enabled = YES;
        self.payBalanceBtn.enabled = NO;
    } else {
        if (self.pageType == PNTradeSubTradeTypeToBakong || self.pageType == PNTradeSubTradeTypeToBank || self.pageType == PNTradeSubTradeTypeToBakongCode) {
            [self showRiskTips];
        } else {
            [self.inputTF becomeFirstResponder];
        }
    }

    if (self.isContainCurrency) {
        self.payBalanceBtn.enabled = NO;
        self.payBalanceImg.image = [UIImage imageNamed:@""];
    } else {
        self.payBalanceBtn.enabled = YES;
    }

    if (!WJIsObjectNil(self.billNumber)) {
        [self.remarkInputTF setTextFieldText:self.billNumber];
        self.remarkInputTF.userInteractionEnabled = NO;
        PNTypeModel *model = PNTypeModel.new;
        model.name = PNLocalizedString(@"remark", @"备注");
        model.value = self.billNumber;
        [self.shopView.arr addObject:model];
    }

    [self.view setNeedsUpdateConstraints];
}

- (void)setPageType:(PNTradeSubTradeType)pageType {
    _pageType = pageType;
    if (self.pageType == PNTradeSubTradeTypeToBakong) {
        self.boldTitle = PNLocalizedString(@"transfer_bakong", @"转账到bakong");
        self.bizType = PNTransferTypePersonalToBaKong;
    } else if (self.pageType == PNTradeSubTradeTypeToBank) {
        self.boldTitle = PNLocalizedString(@"transfer_bank", @"转账到银行");
        self.bizType = PNTransferTypePersonalToBank;
    } else if (self.pageType == PNTradeSubTradeTypeToBakongCode) {
        self.boldTitle = PNLocalizedString(@"transfer_bakong", @"转账到bakong");
        self.bizType = PNTransferTypePersonalScanQRToBakong;
    } else if (self.pageType == PNTradeSubTradeTypeCoolCashCashOut) {
        self.boldTitle = PNLocalizedString(@"CoolCashGoldOut", @"CoolCash出金");
        self.bizType = self.payeeInfo.bizType;
    } else if (self.pageType == PNTradeSubTradeTypeToAgent) {
        self.boldTitle = PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账");
        self.bizType = PNTransferTypePersonalScanQRToBakong;
    } else if (self.pageType == PNTradeSubTradeTypeToBakongMerchant) {
        self.boldTitle = PNLocalizedString(@"pn_pay_to_merchant", @"向商户付款");
        self.bizType = PNTransferTypePersonalScanQRToBakong;
    } else if (self.pageType == PNTradeSubTradeTypeToCoolCash) {
        self.boldTitle = PNLocalizedString(@"VIEW_TEXT_TRANSFER_TO_ACC", @"转到CoolCash账号");
        self.bizType = PNTransferTypeToCoolcash;
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)setCy:(PNCurrencyType)cy {
    _cy = cy;
    if ([_cy isEqualToString:PNCurrencyTypeKHR]) {
        HDUITextFieldConfig *config = [self.inputTF getCurrentConfig];
        config.maxDecimalsCount = 0;
        config.characterSetString = kCharacterSetStringNumber;
        config.leftLabelString = @"៛";
        [self.inputTF setConfig:config];
    } else {
        HDUITextFieldConfig *config = [self.inputTF getCurrentConfig];
        config.maxDecimalsCount = 2;
        config.characterSetString = kCharacterSetStringAmount;
        config.leftLabelString = @"$";
        [self.inputTF setConfig:config];
    }

    [self.view setNeedsUpdateConstraints];
}

- (BOOL)hd_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 0) {
        self.nextBtn.enabled = YES;
    }
    return YES;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
    }
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollViewContainer);
        make.top.equalTo(self.scrollViewContainer.mas_top).offset(kRealHeight(15));
        make.width.mas_equalTo(kRealWidth(80));
        make.height.mas_equalTo(kRealWidth(80));
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImg);
        make.top.equalTo(self.iconImg.mas_bottom).offset(kRealHeight(15));
        make.left.equalTo(self.scrollViewContainer).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];
    [self.acountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImg);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(self.scrollViewContainer).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.acountLB.mas_bottom).offset(kRealHeight(15));
        make.bottom.equalTo(self.shopView.mas_bottom).offset(kRealHeight(20));
    }];
    [self.payacountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(20));
        make.centerY.equalTo(self.payBalanceBtn);
    }];
    [self.payBalanceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payacountLB.mas_right).offset(kRealWidth(10));
        make.top.equalTo(self.bgView.mas_top).offset(kRealHeight(20));
        make.bottom.equalTo(self.payBalanceBtn.mas_bottom).offset(kRealHeight(10));
        make.right.equalTo(self.payBalanceImg.mas_right).offset(kRealHeight(10));
    }];

    [self.payBalanceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payBalanceView.mas_left).offset(kRealWidth(10));
        make.top.equalTo(self.payBalanceView.mas_top).offset(kRealHeight(10));
    }];
    [self.payBalanceImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payBalanceBtn);
        make.left.equalTo(self.payBalanceBtn.mas_right).offset(kRealWidth(5));
        make.width.mas_equalTo(kRealWidth(5));
        make.height.mas_equalTo(kRealWidth(9));
    }];
    [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.payBalanceBtn.mas_bottom).offset(kRealHeight(30));
        if (self.payeeInfo.orderAmt.cent.length > 0) {
            make.height.mas_equalTo(kRealHeight(0));
        } else {
            make.height.mas_equalTo(kRealHeight(70));
        }
    }];
    [self.amountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.inputTF.mas_bottom);
        if (self.payeeInfo.orderAmt.cent.length <= 0) {
            make.height.mas_equalTo(kRealHeight(0));
        }
    }];
    [self.remarkView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.amountLB.mas_bottom).offset(kRealHeight(20));
        make.bottom.equalTo(self.remarkInputTF).offset(kRealHeight(20));
        if (self.billNumber.length > 0) {
            make.height.mas_equalTo(kRealHeight(0));
        }
    }];
    [self.remarkInputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkView).offset(kRealWidth(10));
        make.right.equalTo(self.remarkView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.remarkView).offset(kRealWidth(10));
        if (self.billNumber.length > 0) {
            make.height.mas_equalTo(kRealHeight(0));
        } else {
            make.height.mas_equalTo(kRealHeight(50));
        }
    }];
    [self.shopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        if ((self.payeeStoreName.length > 0 || self.payeeStoreLocation.length > 0) && self.shopView.lastLB) {
            make.top.equalTo(self.remarkView.mas_bottom).offset(kRealHeight(20));
            make.bottom.equalTo(self.shopView.lastLB.mas_bottom);
        } else {
            make.top.equalTo(self.remarkView.mas_bottom).offset(kRealHeight(0));
            make.height.mas_equalTo(0);
        }
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(kRealHeight(50));
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealHeight(50));
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-(kRealWidth(20) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    if (self.pageType != PNTradeSubTradeTypeCoolCashCashOut) {
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
    }
}

- (BOOL)needCheckPayPwd {
    return YES;
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (void)nextTap {
    [self.view endEditing:YES];
    [self doTransferOrderBuild];
}

#pragma mark---- coolcash 出金 提交 ----
- (void)confirmCoolCashCashOut {
    [self.view showloading];
    @HDWeakify(self);
    [self.transDTO coolcashOutConfirmOrderWithFeeAmt:self.payeeInfo.feeAmt payAmt:self.payeeInfo.payAmt orderNo:self.payeeInfo.orderNo purpose:self.remarkInputTF.validInputText
        success:^(HDTransferOrderBuildRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            PNPaymentBuildModel *model = [[PNPaymentBuildModel alloc] init];
            model.tradeNo = rspModel.tradeNo;
            model.subTradeType = PNTradeSubTradeTypeCoolCashCashOut;

            PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{
                @"data": [model yy_modelToJSONData],
            }];
            vc.delegate = self;
            [SAWindowManager.visibleViewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
}
#pragma mark - 下单
- (void)doTransferOrderBuild {
    if (self.pageType == PNTradeSubTradeTypeCoolCashCashOut) {
        [self confirmCoolCashCashOut];
        return;
    }
    NSDictionary *dic = @{
        @"payeeNo": self.payeeInfo.payeeLoginName,
        @"amt": [PNCommonUtils yuanTofen:self.inputTF.validInputText],
        @"cy": self.cy,
        @"bizType": self.bizType,
        @"payeeBankCode": self.payeeBankCode,
        @"payeeAccountNo": self.payeeAccountNo,
        @"payeeAccountName": self.payeeAccountName,
        @"payeeBankName": self.payeeBankName,
        @"purpose": self.remarkInputTF.validInputText,
        @"payeeStoreName": self.payeeStoreName,
        @"payeeStoreLocation": self.payeeStoreLocation,
        @"outBizNo": self.payeeInfo.terminalLabel,
        @"merchantId": self.merchantId,
        @"qrData": self.qrData ?: @"",
        @"subBizType": self.subBizType,
    };
    [self.view showloading];
    @HDWeakify(self);

    [self.transDTO outConfirmOrderWithParams:dic shouldAlertErrorMsgExceptSpecCode:NO success:^(HDTransferOrderBuildRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        PNPaymentBuildModel *model = [[PNPaymentBuildModel alloc] init];
        model.tradeNo = rspModel.tradeNo;

        if (self.pageType == PNTradeSubTradeTypeToBank) {
            model.subTradeType = PNTradeSubTradeTypeToBank;
        } else if (self.pageType == PNTradeSubTradeTypeToBakong) {
            model.subTradeType = PNTradeSubTradeTypeToBakong;
        } else if (self.pageType == PNTradeSubTradeTypeToBakongCode) {
            model.subTradeType = PNTradeSubTradeTypeToBakongCode;
            model.qrData = self.qrData;
        } else if (self.pageType == PNTradeSubTradeTypeToAgent) {
            model.subTradeType = PNTradeSubTradeTypeToAgent;
        }

        PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{
            @"data": [model yy_modelToJSONData],
        }];
        vc.delegate = self;
        [SAWindowManager.visibleViewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];

        /// 额外处理特殊的code
        if (WJIsObjectNil(rspModel)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
        } else {
            if ([rspModel.code isEqualToString:@"U2040"]) {
                //转账到银行页面，输入转账金额，点击确认后，判断付款账户是否设置了姓名，未设置时弹窗提示，点击【立即前往】跳转【账户信息】页面；点击【取消】关闭弹窗，停留在该页面
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] confirmButtonTitle:PNLocalizedString(@"go_now", @"立即前往")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        [HDMediator.sharedInstance navigaveToPayNowAccountInfoVC:@{}];
                    }
                    cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            } else {
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            }
        }
    }];
}

#pragma mark PNPaymentComfirmViewControllerDelegate
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    //    [controller.navigationController popViewControllerAnimated:YES];
    [self paymentComplete:rspModel];
    [controller removeFromParentViewController];
}

//支付完成 跳转到 交易详情
- (void)paymentComplete:(PayHDTradeSubmitPaymentRspModel *)rspModel {
    PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] init];
    vc.type = resultPage;
    HDPayOrderRspModel *model = [HDPayOrderRspModel new];
    model.tradeNo = rspModel.tradeNo;
    model.tradeType = rspModel.tradeType;
    model.payOrderStatus = rspModel.status;
    vc.rspModel = model;
    __weak __typeof(self) weakSelf = self;
    vc.clickedDoneBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        HDLog(@"%@", strongSelf.navigationController.viewControllers);
        BOOL isGotoWalletHome = NO;
        BOOL isGotoSANewHome = NO;
        for (UIViewController *viewcontroller in self.navigationController.viewControllers) {
            if ([NSStringFromClass(viewcontroller.class) isEqualToString:@"PNWalletController"]) {
                isGotoWalletHome = YES;
            }
            if ([NSStringFromClass(viewcontroller.class) isEqualToString:@"WNHomeViewController"]) {
                isGotoSANewHome = YES;
            }
        }
        if (isGotoWalletHome) {
            [strongSelf.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
        }

        if (isGotoSANewHome) {
            [strongSelf.navigationController popToViewControllerClass:NSClassFromString(@"WNHomeViewController") animated:YES];
        }
    };
    [self presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark 币种切换
- (void)payBalanceBtnTap {
    HDLog(@"payBalanceBtnTap");
    PayActionSheet *sheet = PayActionSheet.new;
    if ([self.cy isEqualToString:PNCurrencyTypeUSD]) {
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
            self.cy = PNCurrencyTypeUSD;
        } else {
            self.cy = PNCurrencyTypeKHR;
        }
        [self getAcountBalance];
    }];
}

#pragma mark - 按钮点亮限制
- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.inputTF.validInputText) && [self.inputTF.validInputText matches:REGEX_AMOUNT] && self.inputTF.validInputText.doubleValue > 0) {
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = UIImageView.new;
        _iconImg.image = [UIImage imageNamed:@"pay_coolcash_icon"];
    }
    return _iconImg;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:19];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)acountLB {
    if (!_acountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:15];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _acountLB = label;
    }
    return _acountLB;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _bgView;
}

- (SALabel *)payacountLB {
    if (!_payacountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:15];
        label.text = PNLocalizedString(@"pay_account", @"付款账户");
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        _payacountLB = label;
    }
    return _payacountLB;
}

- (UIImageView *)payBalanceImg {
    if (!_payBalanceImg) {
        _payBalanceImg = UIImageView.new;
        _payBalanceImg.image = [UIImage imageNamed:@"pay_more_grey"];
    }
    return _payBalanceImg;
}

- (HDUIButton *)payBalanceBtn {
    if (!_payBalanceBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.font forSize:14];
        button.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self payBalanceBtnTap];
        }];
        _payBalanceBtn = button;
    }
    return _payBalanceBtn;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"Limit_description", @"限额说明") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowWalletLimitVC:@{}];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (HDUITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"Please_enter_the_transfer_amount", @"") leftLabelString:@"$"];
        HDUITextFieldConfig *config = [_inputTF getCurrentConfig];
        config.floatingText = @"";
        config.font = [HDAppTheme.font boldForSize:30];
        config.textColor = HDAppTheme.color.G1;
        config.marginBottomLineToTextField = 15;
        config.placeholderFont = [HDAppTheme.font forSize:25];
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftLabelFont = [HDAppTheme.font boldForSize:36];
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

- (UIView *)payBalanceView {
    if (!_payBalanceView) {
        _payBalanceView = UIView.new;
        _payBalanceView.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
        _payBalanceView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:15];
        };
    }
    return _payBalanceView;
}

- (UIView *)remarkView {
    if (!_remarkView) {
        _remarkView = UIView.new;
        _remarkView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        _remarkView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _remarkView;
}

- (HDUITextField *)remarkInputTF {
    if (!_remarkInputTF) {
        HDUITextField *textField =
            [[HDUITextField alloc] initWithPlaceholder:[NSString stringWithFormat:@"%@(64%@)", PNLocalizedString(@"remark", @"备注"), PNLocalizedString(@"limit_words", @"个字符以内")]
                                       leftLabelString:@""];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.floatingText = @"";
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 64;
        config.font = HDAppTheme.font.standard3;
        config.textColor = HDAppTheme.color.G1;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;

        config.placeholderFont = [HDAppTheme.font forSize:15];
        config.placeholderColor = HDAppTheme.PayNowColor.c9599A2;
        [textField setConfig:config];

        _remarkInputTF = textField;
    }
    return _remarkInputTF;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"confirm_next", @"确认") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(nextTap) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = NO;
        button.adjustsButtonWhenDisabled = YES;
        _nextBtn = button;
    }
    return _nextBtn;
}

- (PNPayInfoView *)shopView {
    if (!_shopView) {
        _shopView = PNPayInfoView.new;
    }
    return _shopView;
}

- (SALabel *)amountLB {
    if (!_amountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:36];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        _amountLB = label;
    }
    return _amountLB;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}

- (PNWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = [[PNWalletDTO alloc] init];
    }
    return _walletDTO;
}
@end
