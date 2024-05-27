//
//  SAWalletChargeViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletChargeViewController.h"
#import "HDCheckStandViewController.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "SAWalletChargeCreateRspModel.h"
#import "SAWalletDTO.h"


@interface SAWalletChargeViewController () <HDCheckStandViewControllerDelegate>
/// 输入框
@property (nonatomic, strong) HDUITextField *amountTF;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 钱包 DTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *amountModel;
@end


@implementation SAWalletChargeViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.amountTF];
    [self.view addSubview:self.confirmBTN];

    [self.confirmBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.amountTF distanceToRefViewBottom:20];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"top_up", @"充值");
}

- (void)hd_languageDidChanged {
    [self.amountTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"please_input_money", @"请输入金额"), @"floatingText": SALocalizedString(@"recharge_money", @"充值金额")}];
    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"next", @"下一步", @"Buttons") forState:UIControlStateNormal];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)fixconfirmBTNState {
    NSString *amount = self.amountTF.validInputText;
    double amountValue = amount.doubleValue;

    self.confirmBTN.enabled = amountValue >= 0.01 && amountValue <= 999999.99;
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    //    [HDMediator.sharedInstance navigaveToWalletChargeResultViewController:@{@"resultType": @(2),
    //                                                                            @"amountModel": self.amountModel}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        // 支付成功，跳支付结果页
        HDLog(@"支付成功，跳支付结果页");
        [HDMediator.sharedInstance navigaveToWalletChargeResultViewController:@{@"resultType": @(2), @"amountModel": self.amountModel}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissAnimated:true completion:^{
        HDLog(@"支付失败，跳支付结果页");
        [HDMediator.sharedInstance navigaveToWalletChargeResultViewController:@{@"resultType": @(3)}];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    HDLog(@"用户取消支付");
    [controller dismissAnimated:true completion:^{
        HDLog(@"支付失败，跳支付结果页");
        // 测试说用户取消支付不跳结果页
        // [HDMediator.sharedInstance navigaveToWalletChargeResultViewController:@{@"resultType": @(3)}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    HDLog(@"用户取消支付");
    [controller dismissAnimated:true completion:^{
        HDLog(@"支付失败，跳支付结果页");
        // 测试说用户取消支付不跳结果页
        // [HDMediator.sharedInstance navigaveToWalletChargeResultViewController:@{@"resultType": @(3)}];
    }];
}

#pragma mark - event response
- (void)clickedConfirmBTNHandler {
    [self.view endEditing:true];
    [self showloading];
    @HDWeakify(self);
    SAMoneyModel *amountModel = SAMoneyModel.new;
    amountModel.cy = @"USD";
    amountModel.cent = [SAMoneyTools yuanTofen:self.amountTF.validInputText];
    self.amountModel = amountModel;

    [self.walletDTO createChargeOrderWithPayAmt:amountModel success:^(SAWalletChargeCreateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        // TODO: 需要改造
        // 下单成功，支付
        HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
        buildModel.orderNo = rspModel.outBizNo;
        //            buildModel.outPayOrderNo = rspModel.tradeNo;
        buildModel.payableAmount = amountModel;

        HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
        checkStandVC.resultDelegate = self;
        [self presentViewController:checkStandVC animated:YES completion:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [self.amountTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self.view).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(20));
    }];

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (HDUITextField *)amountTF {
    if (!_amountTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"please_input_money", @"请输入金额") leftLabelString:@"$"];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.font boldForSize:30];
        config.textColor = HDAppTheme.color.G1;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.leftLabelFont = [HDAppTheme.font boldForSize:30];
        config.leftLabelColor = HDAppTheme.color.G1;
        config.floatingText = SALocalizedString(@"recharge_money", @"充值金额");
        config.floatingLabelColor = HDAppTheme.color.G2;
        config.floatingLabelFont = HDAppTheme.font.standard2;
        config.placeholderFont = [HDAppTheme.font forSize:23];
        config.placeholderColor = HDAppTheme.color.G3;
        config.maxDecimalsCount = 2;
        config.maxInputNumber = 999999.99;
        config.shouldAppendDecimalAfterEndEditing = true;
        config.characterSetString = kCharacterSetStringAmount;

        [textField setConfig:config];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self fixconfirmBTNState];
        };
        _amountTF = textField;
    }
    return _amountTF;
}

- (SAOperationButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN.enabled = false;
    }
    return _confirmBTN;
}

- (SAWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = SAWalletDTO.new;
    }
    return _walletDTO;
}
@end
