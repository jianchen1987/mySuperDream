//
//  HDCheckStandInputPwdViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandInputPwdViewController.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "HDCheckStandTextField.h"
#import "HDPaymentProcessingHUD.h"


@interface HDCheckStandInputPwdViewController () <HDCheckStandTextFieldDelegate>
@property (nonatomic, strong) UILabel *tipLB;                        ///< 提示
@property (nonatomic, strong) HDCheckStandTextField *textField;      ///< 输入框
@property (nonatomic, assign) NSUInteger numberOfCharacters;         ///< 密码长度
@property (nonatomic, assign) BOOL isVeriftPwdStyle;                 ///< 是否验证交易密码
@property (nonatomic, copy) NSString *tipStr;                        ///< 提示文字
@property (nonatomic, copy) NSString *titleStr;                      ///< 标题
@property (nonatomic, strong) HDPaymentProcessingHUD *processingHUD; ///< 验证密码 HUD
/// 验证支付密码或者提交支付对象
@property (nonatomic, weak) CMNetworkRequest *submitOrVerifyRequest;
@end


@implementation HDCheckStandInputPwdViewController
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters {
    if (self = [super init]) {
        self.numberOfCharacters = numberOfCharacters;
    }
    return self;
}

- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters title:(NSString *)title tipStr:(NSString *)tipStr {
    if (self = [super init]) {
        self.isVeriftPwdStyle = true;

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

- (HDCheckStandPaymentOverTimeEndActionType)preferedPaymentOverTimeEndActionType {
    return HDCheckStandPaymentOverTimeEndActionTypeInputPassword;
}

- (void)checkAndSetDefaultProperty {
    self.numberOfCharacters = self.numberOfCharacters <= 0 ? 6 : self.numberOfCharacters;
}

- (void)setupUI {
    if (HDIsStringNotEmpty(self.titleStr)) {
        [self setTitleBtnImage:nil title:self.titleStr font:HDAppTheme.font.standard2Bold];
    } else {
        [self setTitleBtnImage:nil title:SALocalizedString(@"please_input_pay_password", @"请输入支付密码") font:HDAppTheme.font.standard2Bold];
    }
    [self setHd_statusBarStyle:UIStatusBarStyleDefault];
    [self.containerView addSubview:self.tipLB];
    self.tipLB.hidden = HDIsStringEmpty(self.tipStr);

    [self.containerView addSubview:self.textField];
}

- (void)updateViewConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLB.isHidden) {
            make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(20));
        }
    }];

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
/** 校验支付密码 */
- (void)verifyPwdPaymentPassword {
    self.processingHUD = [HDPaymentProcessingHUD showLoadingIn:self.view offset:CGRectGetMaxY(self.textField.frame) * 0.5];

    @HDWeakify(self);
    self.submitOrVerifyRequest = [self.checkStandDTO verifyPayPwd:self.textField.text success:^(NSString *_Nonnull token, NSString *_Nonnull index, NSString *_Nonnull pwdSecurityStr) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self.processingHUD showSuccessCompletion:^{
            @HDStrongify(self);
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyPwdPaymentPasswordSuccess:index:password:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand verifyPwdPaymentPasswordSuccess:token index:index password:pwdSecurityStr];
            } else {
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            }
        }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [HDPaymentProcessingHUD hideFor:self.view];

        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyPwdPaymentPasswordfailureWithRspModel:errorType:error:)]) {
            [self.checkStand.resultDelegate checkStandViewController:self.checkStand verifyPwdPaymentPasswordfailureWithRspModel:rspModel errorType:errorType error:error];
        }
    }];
}

/** 支付 */
- (void)pay {
    self.processingHUD = [HDPaymentProcessingHUD showLoadingIn:self.view offset:CGRectGetMaxY(self.textField.frame) * 0.5];

    @HDWeakify(self);
    self.submitOrVerifyRequest = [self.checkStandDTO tradeSubmitPaymentWithPayPwd:self.textField.text tradeNo:self.model.tradeNo voucherNo:self.model.voucherNo outBizNo:self.model.outBizNo
        success:^(HDTradeSubmitPaymentRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            @HDWeakify(self);
            [self.processingHUD showSuccessCompletion:^{
                @HDStrongify(self);
                if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
                    HDCheckStandWechatPayResultResp *resultResp = HDCheckStandWechatPayResultResp.new;
                    [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentSuccess:resultResp];
                } else {
                    [self.navigationController dismissViewControllerAnimated:true completion:nil];
                }
            }];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            // 隐藏 loading 动画
            [HDPaymentProcessingHUD hideFor:self.view];
            [self dealingWithRspModel:rspModel errorType:errorType error:error];
        }];
}

#pragma mark - HDCheckStandTextFieldDelegate
- (void)checkStandTextFieldDidFinishedEditing:(HDCheckStandTextField *)paymentField {
    [self.view endEditing:YES];

    [paymentField resignFirstResponder];

    if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:completedInputPassword:)]) {
        [self.checkStand.resultDelegate checkStandViewController:self.checkStand completedInputPassword:paymentField];
    }

    if (self.isVeriftPwdStyle) {
        // 校验支付密码
        [self verifyPwdPaymentPassword];
    } else {
        // 支付
        [self pay];
    }
}

#pragma mark - private methods
/** 支付失败 */
- (void)dealingWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    [self dismissLoading];

    if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:verifyPwdPaymentPasswordfailureWithRspModel:errorType:error:)]) {
        [self.checkStand.resultDelegate checkStandViewController:self.checkStand verifyPwdPaymentPasswordfailureWithRspModel:rspModel errorType:errorType error:error];
    } else {
        if (!self.submitOrVerifyRequest.shouldAlertErrorMsgExceptSpecCode) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
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
        _tipLB.font = HDAppTheme.font.standard3;
        _tipLB.textColor = HDAppTheme.color.G2;
        _tipLB.numberOfLines = 0;
    }
    return _tipLB;
}

- (HDCheckStandTextField *)textField {
    if (!_textField) {
        _textField = [[HDCheckStandTextField alloc] initWithNumberOfCharacters:self.numberOfCharacters securityCharacterType:HDCheckStandSecurityCharacterTypeSecurityDot
                                                                    borderType:HDCheckStandTextFieldBorderTypeHaveRoundedCorner];
        _textField.tintColor = HDAppTheme.color.G4;
        _textField.delegate = self;
    }
    return _textField;
}
@end
