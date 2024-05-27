//
//  PayHDCheckstandInputPwdViewController.m
//  customer
//
//  Created by VanJay on 2019/5/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandInputPwdViewController.h"
#import "HDAppTheme+PayNow.h"
#import "HDCheckstandDTO.h"
#import "HDPasswordManagerViewModel.h"
#import "NSString+AES.h"
#import "NSString+MD5.h"
#import "PNCommonUtils.h"
#import "PNMSEncryptFactorRspModel.h"
#import "PNMSPwdDTO.h"
#import "PNMSWitdrawDTO.h"
#import "PNRspModel.h"
#import "PayHDCheckstandTextField.h"
#import "PayHDPaymentProcessingHUD.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "PayHDTradeSubmitPaymentRspModel.h"
#import "SATalkingData.h"


@interface PayHDCheckstandInputPwdViewController () <PayHDCheckstandTextFieldDelegate>
@property (nonatomic, strong) HDPasswordManagerViewModel *pwdVM;
@property (nonatomic, strong) UILabel *tipLB;                           ///< 提示
@property (nonatomic, strong) PayHDCheckstandTextField *textField;      ///< 输入框
@property (nonatomic, assign) NSUInteger numberOfCharacters;            ///< 密码长度
@property (nonatomic, assign) BOOL isVeriftPwdStyle;                    ///< 是否验证交易密码
@property (nonatomic, copy) NSString *tipStr;                           ///< 提示文字
@property (nonatomic, copy) NSString *titleStr;                         ///< 标题
@property (nonatomic, strong) PayHDPaymentProcessingHUD *processingHUD; ///< 付款中 HUD
@property (nonatomic, strong) PNMSPwdDTO *msPwdDTO;                     ///商户
@property (nonatomic, strong) PNMSWitdrawDTO *withdrawDTO;              /// 商户 - 提现到银行卡
@property (nonatomic, strong) HDCheckstandDTO *standDTO;                //// 中台的
@end


@implementation PayHDCheckstandInputPwdViewController
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters {
    if (self = [super init]) {
        self.numberOfCharacters = numberOfCharacters;
    }
    return self;
}

- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters title:(NSString *)title tipStr:(NSString *)tipStr isVerifyPwd:(BOOL)isVerifyPwd {
    if (self = [super init]) {
        self.isVeriftPwdStyle = isVerifyPwd;
        self.numberOfCharacters = numberOfCharacters;
        self.titleStr = title;
        self.tipStr = tipStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self checkAndSetDefaultProperty];

    [self setupUI];

    // 默认弹出键盘
    [self.textField becomeFirstResponder];
}

- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType {
    return PayHDCheckstandPaymentOverTimeEndActionTypeInputPassword;
}

- (void)checkAndSetDefaultProperty {
    self.numberOfCharacters = self.numberOfCharacters <= 0 ? 6 : self.numberOfCharacters;
}

- (void)setupUI {
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        [self setTitleBtnImage:nil title:PNLocalizedString(@"pn_ms_input_transaction_pwd", @"输入交易密码") font:[HDAppTheme.font standard2Bold]];
    } else {
        if (WJIsStringNotEmpty(self.titleStr)) {
            [self setTitleBtnImage:nil title:self.titleStr font:[HDAppTheme.font standard2Bold]];
        } else {
            [self setTitleBtnImage:nil title:PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"请输入支付密码") font:[HDAppTheme.font standard2Bold]];
        }
    }

    [self.containerView addSubview:self.tipLB];
    self.tipLB.hidden = WJIsStringEmpty(self.tipStr);

    [self.containerView addSubview:self.textField];
}

- (void)updateViewConstraints {
    if (!self.tipLB.isHidden) {
        [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(20));
        }];
    }

    CGFloat textFieldW = self.view.width - 2 * kRealWidth(15);
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textFieldW);
        make.centerX.equalTo(self.containerView);
        if (!self.tipLB.isHidden) {
            make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(20));
        }
        make.height.mas_equalTo(textFieldW / (float)self.numberOfCharacters);
    }];

    [super updateViewConstraints];
}

#pragma mark - Data
- (NSString *)encrypMerchantServerPwd:(NSString *)encrypFactor {
    NSString *md5_1String = [NSString stringWithFormat:@"%@%@%@", @"Chaos", self.textField.text, @"technology"];
    NSString *md5_1 = [md5_1String MD5];
    NSString *md5_2String = [NSString stringWithFormat:@"%@%@", md5_1, @"We!are@Family#"];
    NSString *md5_2 = [md5_2String MD5];
    NSString *AES_password = [md5_2 AES128CBCEncryptWithKey:encrypFactor andVI:@"A-16-Byte-String"];

    return AES_password;
}

/** 获取加密因子 */
- (void)getEncryptFactor {
    NSString *random = [PNCommonUtils getRandomKey];
    @HDWeakify(self);

    if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank
        || (self.isVeriftPwdStyle && self.actionType == BusinessActionType_CheckMerchantServicePayPassword)) {
        [self.msPwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];

            NSString *AES_password = [self encrypMerchantServerPwd:rspModel.encrypFactor];

            if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet) {
                [self ms_payWithSecurityText:AES_password index:rspModel.index];
            } else if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
                [self ms_payWithdrawToBankCardWithSecurityText:AES_password index:rspModel.index];
            } else {
                /// 校验
                if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandViewBaseController:merchantPwd:password:)]) {
                    [self.delegate checkStandViewBaseController:self merchantPwd:rspModel.index password:AES_password];
                }
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [PayHDPaymentProcessingHUD hideFor:self.view];
            [self dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
    } else {
        // 获取加密因子
        [self.pwdVM getEncryptFactorWithRandom:random finish:^(NSString *index, NSString *factor) {
            @HDStrongify(self);
            [self dismissLoading];

            if (self.isVeriftPwdStyle) {
                if (self.actionType == BusinessActionType_GetPaymentCode) {
                    [self getPaymentCodeWithSecurityText:self.textField.text index:index factor:factor];
                } else if (self.actionType == BusinessActionType_OpenPayment) {
                    [self verifyOpenPaymentWithSecurityText:self.textField.text index:index factor:factor];
                } else {
                    // actionType == BusinessActionType_CheckPayPassword
                    // 校验支付密码
                    [self verifyPwdPaymentPasswordWithSecurityText:self.textField.text index:index factor:factor];
                }
            } else {
                // 支付
                [self payWithSecurityText:self.textField.text index:index factor:factor];
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [PayHDPaymentProcessingHUD hideFor:self.view];
            [self dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
    }
}

/** 校验支付密码 - 开通付款码 */
- (void)verifyOpenPaymentWithSecurityText:(NSString *)securityText index:(NSString *)index factor:(NSString *)factor {
    NSString *securityTxt = [RSACipher encrypt:securityText publicKey:factor];

    __weak __typeof(self) weakSelf = self;

    [self.pwdVM requestOpenPaymentWithBusinessType:self.businessModel.businessType payCertifiedType:self.businessModel.certifiedType index:index password:securityTxt
        success:^(NSString *authKey, NSString *payerUsrToken) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            [strongSelf.processingHUD showSuccessCompletion:^{
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandViewBaseController:verifyOpenPaymentPasswordSuccess:index:password:authKey:pwd:)]) {
                    [strongSelf.delegate checkStandViewBaseController:strongSelf verifyOpenPaymentPasswordSuccess:payerUsrToken index:index password:securityTxt authKey:authKey pwd:securityText];
                }
            }];

            [SATalkingData trackEvent:[NSString stringWithFormat:@"验证支付密码_成功"]];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [PayHDPaymentProcessingHUD hideFor:strongSelf.view];
            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
            [SATalkingData trackEvent:@"验证开通付款码密码_失败" label:[NSString stringWithFormat:@"网络错误_%@", error.localizedDescription]];
        }];
}

/** 获取 付款码二维码 */
- (void)getPaymentCodeWithSecurityText:(NSString *)securityText index:(NSString *)index factor:(NSString *)factor {
    NSString *securityTxt = [RSACipher encrypt:securityText publicKey:factor];

    __weak __typeof(self) weakSelf = self;
    [self.pwdVM requestPaymentQRCodeWithBusinessType:self.businessModel.businessType index:index password:securityTxt success:^(NSDictionary *rspData) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __weak __typeof(strongSelf) weakSelf2 = strongSelf;
        [strongSelf.processingHUD showSuccessCompletion:^{
            __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
            if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandViewBaseController:verifyGetPaymentQRCodeSuccess:index:password:)]) {
                [strongSelf2.delegate checkStandViewBaseController:strongSelf verifyGetPaymentQRCodeSuccess:rspData index:index password:securityTxt];
            }
        }];

        [SATalkingData trackEvent:[NSString stringWithFormat:@"获取付款码二维码_成功"]];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [PayHDPaymentProcessingHUD hideFor:strongSelf.view];
        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        [SATalkingData trackEvent:@"获取付款码二维码_失败" label:[NSString stringWithFormat:@"网络错误_%@", error.localizedDescription]];
    }];
}

/** 校验支付密码 */
- (void)verifyPwdPaymentPasswordWithSecurityText:(NSString *)securityText index:(NSString *)index factor:(NSString *)factor {
    NSString *securityTxt = [RSACipher encrypt:securityText publicKey:factor];

    __weak __typeof(self) weakSelf = self;
    [self.pwdVM verifyPayPwdByIndex:index Password:securityTxt finish:^(NSString *token) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __weak __typeof(strongSelf) weakSelf2 = strongSelf;
        [strongSelf.processingHUD showSuccessCompletion:^{
            __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
            if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandViewBaseController:verifyPwdPaymentPasswordSuccess:index:password:)]) {
                [strongSelf.delegate checkStandViewBaseController:strongSelf2 verifyPwdPaymentPasswordSuccess:token index:index password:securityTxt];
            }
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        // 隐藏 loading 动画
        [PayHDPaymentProcessingHUD hideFor:strongSelf.view];

        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}

- (void)cashOutSubmit:(NSString *)index pwd:(NSString *)securityTxt {
    __weak __typeof(self) weakSelf = self;

    [self.pwdVM coolCashOutPaymentSubmitWithVoucherNo:self.buildModel.confirmRspMode.voucherNo index:index payPwd:securityTxt success:^(PayHDTradeSubmitPaymentRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        // 支付成功
        __weak __typeof(strongSelf) weakSelf2 = strongSelf;
        [strongSelf.processingHUD showSuccessCompletion:^{
            __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
            if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandBaseViewController:paymentSuccess:)]) {
                [strongSelf2.delegate checkStandBaseViewController:strongSelf2 paymentSuccess:rspModel];
            }
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        // 隐藏 loading 动画
        [PayHDPaymentProcessingHUD hideFor:strongSelf.view];

        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}

/** 支付 */
- (void)payWithSecurityText:(NSString *)securityText index:(NSString *)index factor:(NSString *)factor {
    NSString *securityTxt = [RSACipher encrypt:securityText publicKey:factor];
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        return;
    }

    if (self.buildModel.subTradeType == PNTradeSubTradeTypeCoolCashCashOut) { //出金二维码
        [self cashOutSubmit:index pwd:securityTxt];
        return;
    }
    __weak __typeof(self) weakSelf = self;

    [self.pwdVM pn_tradeSubmitPaymentWithIndex:index payPwd:securityTxt tradeNo:self.buildModel.confirmRspMode.tradeNo voucherNo:self.buildModel.confirmRspMode.voucherNo
        outBizNo:self.buildModel.confirmRspMode.outBizNo
        qrData:self.buildModel.qrData
        payWay:self.buildModel.payWay success:^(PayHDTradeSubmitPaymentRspModel *_Nonnull rspModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            // 支付成功
            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            [strongSelf.processingHUD showSuccessCompletion:^{
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandBaseViewController:paymentSuccess:)]) {
                    [strongSelf2.delegate checkStandBaseViewController:strongSelf2 paymentSuccess:rspModel];
                }
            }];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            // 隐藏 loading 动画
            [PayHDPaymentProcessingHUD hideFor:strongSelf.view];

            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
}

/// 商户 - 确定支付
- (void)ms_payWithSecurityText:(NSString *)securityText index:(NSString *)index {
    __weak __typeof(self) weakSelf = self;
    [self.pwdVM pn_tradeSubmitPaymentWithIndex:index payPwd:securityText tradeNo:self.buildModel.confirmRspMode.tradeNo voucherNo:self.buildModel.confirmRspMode.voucherNo outBizNo:@""
        qrData:self.buildModel.qrData
        payWay:@"" success:^(PayHDTradeSubmitPaymentRspModel *_Nonnull rspModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            // 支付成功
            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            [strongSelf.processingHUD showSuccessCompletion:^{
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandBaseViewController:paymentSuccess:)]) {
                    [strongSelf2.delegate checkStandBaseViewController:strongSelf2 paymentSuccess:rspModel];
                }
            }];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            // 隐藏 loading 动画
            [PayHDPaymentProcessingHUD hideFor:strongSelf.view];

            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
}

/// 确定提现 - 银行卡
- (void)ms_payWithdrawToBankCardWithSecurityText:(NSString *)securityText index:(NSString *)index {
    __weak __typeof(self) weakSelf = self;
    [self.withdrawDTO ms_withdrawAutoWithOrderNo:self.buildModel.confirmRspMode.orderNo cashVoucherNo:self.buildModel.confirmRspMode.cashVoucherNo payPwd:securityText index:index
        funcCtl:@"withdraw_to_bank" success:^(PNRspModel *_Nonnull rspModel) {
            PayHDTradeSubmitPaymentRspModel *model = [PayHDTradeSubmitPaymentRspModel yy_modelWithJSON:rspModel.data];
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            // 支付成功
            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            [strongSelf.processingHUD showSuccessCompletion:^{
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                if (strongSelf2.delegate && [strongSelf2.delegate respondsToSelector:@selector(checkStandBaseViewController:paymentSuccess:)]) {
                    [strongSelf2.delegate checkStandBaseViewController:strongSelf2 paymentSuccess:model];
                }
            }];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            // 隐藏 loading 动画
            [PayHDPaymentProcessingHUD hideFor:strongSelf.view];

            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
}

#pragma mark - private methods
/** 支付失败 */
- (void)dealingWithTransactionFailure:(NSString *)reason code:(NSString *)code {
    [self dismissLoading];

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewController:transactionFailure:code:)]) {
        [self.delegate checkStandBaseViewController:self transactionFailure:reason code:code];
    } else {
        [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            [self.navigationController dismissAnimated:YES completion:nil];
        }];
    }
}

#pragma mark - event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - PayHDCheckstandTextFieldDelegate
- (void)checkStandTextFieldDidFinishedEditing:(PayHDCheckstandTextField *)paymentField {
    [self.view endEditing:YES];

    [paymentField resignFirstResponder];

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandViewBaseController:completedInputPassword:)]) {
        [self.delegate checkStandViewBaseController:self completedInputPassword:paymentField];
    }

    // 获取加密因子
    [self getEncryptFactor];
    self.processingHUD = [PayHDPaymentProcessingHUD showLoadingIn:self.view offset:CGRectGetMaxY(self.textField.frame) * 0.5];
}

#pragma mark - override
- (void)clickOnBackBarButtonItem {
    [self.view endEditing:YES];

    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self.navigationController dismissAnimated:true completion:nil];
    }
}

#pragma mark - lazy load
- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] init];
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = self.tipStr;
        _tipLB.font = [HDAppTheme.PayNowFont fontDINBold:24];
        _tipLB.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        _tipLB.numberOfLines = 0;
    }
    return _tipLB;
}

- (PayHDCheckstandTextField *)textField {
    if (!_textField) {
        _textField = [[PayHDCheckstandTextField alloc] initWithNumberOfCharacters:self.numberOfCharacters securityCharacterType:PayHDCheckstandSecurityCharacterTypeSecurityDot
                                                                       borderType:PayHDCheckstandTextFieldBorderTypeHaveRoundedCorner];
        _textField.tintColor = [HDAppTheme.color G4];
        _textField.delegate = self;
    }
    return _textField;
}

- (HDPasswordManagerViewModel *)pwdVM {
    if (!_pwdVM) {
        _pwdVM = [[HDPasswordManagerViewModel alloc] init];
    }
    return _pwdVM;
}

- (PNMSPwdDTO *)msPwdDTO {
    if (!_msPwdDTO) {
        _msPwdDTO = [[PNMSPwdDTO alloc] init];
    }
    return _msPwdDTO;
}

- (PNMSWitdrawDTO *)withdrawDTO {
    if (!_withdrawDTO) {
        _withdrawDTO = [[PNMSWitdrawDTO alloc] init];
    }
    return _withdrawDTO;
}

- (HDCheckstandDTO *)standDTO {
    if (!_standDTO) {
        _standDTO = [[HDCheckstandDTO alloc] init];
    }
    return _standDTO;
}
@end
