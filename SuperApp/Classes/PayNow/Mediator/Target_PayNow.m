#import "Target_PayNow.h"
#import "PNAccountInfoViewController.h"
#import "PNAddAndEditReciverInfoViewController.h"
#import "PNApartmentComfirmViewController.h"
#import "PNApartmentListViewController.h"
#import "PNApartmentOrderListViewController.h"
#import "PNApartmentRecordDetailViewController.h"
#import "PNApartmentRecordListViewController.h"
#import "PNApartmentRejectViewController.h"
#import "PNApartmentResultViewController.h"
#import "PNApartmentUploadVoucherViewController.h"
#import "PNBankListViewController.h"
#import "PNBillListViewController.h"
#import "PNBillModifyAmountViewController.h"
#import "PNBillPaymentListViewController.h"
#import "PNBillSupplierListViewController.h"
#import "PNContactUSViewController.h"
#import "PNDepositViewController.h"
#import "PNForgotPasswordVerifySMSCodeController.h"
#import "PNGameListViewController.h"
#import "PNGuaranteeBuyerViewController.h"
#import "PNGuaranteeInitViewController.h"
#import "PNGuaranteeListViewController.h"
#import "PNGuaranteeSalerInitViewController.h"
#import "PNGuarateenRecordDetailViewController.h"
#import "PNHandOutLuckyPacketViewController.h"
#import "PNIDVerifyViewController.h"
#import "PNInterRransferRecordDetailViewController.h"
#import "PNInterTransferChannelViewController.h"
#import "PNInterTransferIndexViewController.h"
#import "PNInterTransferLimitController.h"
#import "PNInterTransferManageViewController.h"
#import "PNInterTransferManager.h"
#import "PNInterTransferRateController.h"
#import "PNInterTransferReciverInfoViewController.h"
#import "PNInterTransferRecordsViewController.h"
#import "PNInterTransferResultViewController.h"
#import "PNLuckPacketHomeViewController.h"
#import "PNLuckyPacketRecordsRootViewController.h"
#import "PNMSAddBankCardViewController.h"
#import "PNMSAddOrEditOperatorViewController.h"
#import "PNMSAgreementWarpViewController.h"
#import "PNMSAskTradePwdViewController.h"
#import "PNMSBindController.h"
#import "PNMSBindResultController.h"
#import "PNMSCollectionController.h"
#import "PNMSForgotPasswordVerifySMSCodeController.h"
#import "PNMSHomeController.h"
#import "PNMSHomeManager.h"
#import "PNMSInputAmountViewController.h"
#import "PNMSIntroductionController.h"
#import "PNMSMapAddressController.h"
#import "PNMSMerchantInfoViewController.h"
#import "PNMSOpenController.h"
#import "PNMSOpenResultController.h"
#import "PNMSOperatorManagerViewController.h"
#import "PNMSOrderDetailsController.h"
#import "PNMSOrderListController.h"
#import "PNMSPasswordContactAdminViewController.h"
#import "PNMSPasswordContactUSController.h"
#import "PNMSPreBindController.h"
#import "PNMSPwdSendSMSViewController.h"
#import "PNMSReceiveCodeViewController.h"
#import "PNMSSettingViewController.h"
#import "PNMSStoreAddOrEditViewController.h"
#import "PNMSStoreInfoViewController.h"
#import "PNMSStoreManagerViewController.h"
#import "PNMSStoreOperatorAddOrEditViewController.h"
#import "PNMSStoreOperatorManagerViewController.h"
#import "PNMSTradePwdController.h"
#import "PNMSUploadVoucherViewController.h"
#import "PNMSVoucherListViewController.h"
#import "PNMSWithdrawListViewController.h"
#import "PNMSWithdrawToBankViewController.h"
#import "PNMSWithdrawToWalletViewController.h"
#import "PNMStoreMiddleViewController.h"
#import "PNMVoucherDetailViewController.h"
#import "PNNewInteTransferRateViewController.h"
#import "PNNewInterTransferLimitViewController.h"
#import "PNNewInterTransferReciverInfoViewController.h"
#import "PNOpenWalletInputVC.h"
#import "PNOpenWalletVC.h"
#import "PNOrderResultViewController.h"
#import "PNOutletViewController.h"
#import "PNPacketMessageViewController.h"
#import "PNPacketOpenViewController.h"
#import "PNPacketRecordDetailsViewController.h"
#import "PNPasswordContactUSController.h"
#import "PNPaymentCodeViewController.h"
#import "PNPaymentComfirmViewController.h"
#import "PNPaymentOrderDetailsViewController.h"
#import "PNQueryWaterPaymentViewController.h"
#import "PNReceiveCodeViewController.h"
#import "PNSetAmountViewController.h"
#import "PNSubmitWaterPaymentViewController.h"
#import "PNTermsViewController.h"
#import "PNTransListViewController.h"
#import "PNTransPhoneController.h"
#import "PNUpgradeAccountViewController.h"
#import "PNUpgradeResultViewController.h"
#import "PNUploadImageViewController.h"
#import "PNUtilitiesViewController.h"
#import "PNWalletController.h"
#import "PNWalletLimitVC.h"
#import "PNWalletOrderDetailViewController.h"
#import "PNWalletOrderListViewController.h"
#import "PNWalletSettingViewController.h"
#import "PNWaterPaymentResultViewController.h"
#import "PNWebViewController.h"
#import "WQCodeScanner.h"
#import "PNMSOperatorManagerViewController.h"
#import "PNMSAddOrEditOperatorViewController.h"
#import "PNMSStoreManagerViewController.h"
#import "PNMSStoreAddOrEditViewController.h"
#import "PNMSStoreInfoViewController.h"
#import "PNMSWithdrawListViewController.h"
#import "PNMSWithdrawToBankViewController.h"
#import "PNMSAddBankCardViewController.h"
#import "PNMStoreMiddleViewController.h"
#import "PNMSInputAmountViewController.h"
#import "PNMSStoreOperatorManagerViewController.h"
#import "PNMSStoreOperatorAddOrEditViewController.h"
#import "PNMSVoucherListViewController.h"
#import "PNMSUploadVoucherViewController.h"
#import "PNMVoucherDetailViewController.h"
#import "PNMSPasswordContactAdminViewController.h"
#import "PNInterTransferChannelViewController.h"
#import "PNApartmentListViewController.h"
#import "PNApartmentComfirmViewController.h"
#import "PNApartmentRecordListViewController.h"
#import "PNApartmentRecordDetailViewController.h"
#import "PNApartmentRejectViewController.h"
#import "PNApartmentResultViewController.h"
#import "PNApartmentUploadVoucherViewController.h"
#import "PNApartmentOrderListViewController.h"
#import "PNLuckPacketHomeViewController.h"
#import "PNLuckyPacketRecordsRootViewController.h"
#import "PNHandOutLuckyPacketViewController.h"
#import "PNPacketMessageViewController.h"
#import "PNPacketOpenViewController.h"
#import "PNPacketRecordDetailsViewController.h"
#import "PNWalletOrderListViewController.h"
#import "PNWalletOrderDetailViewController.h"
#import "PNPaymentComfirmViewController.h"
#import "PNGuaranteeListViewController.h"
#import "PNGuaranteeInitViewController.h"
#import "PNGuaranteeSalerInitViewController.h"
#import "PNGuaranteeBuyerViewController.h"
#import "PNGuarateenRecordDetailViewController.h"
#import "PNMSMerchantInfoViewController.h"
#import "PNPreCheckCreditViewController.h"
#import "PNCreditManager.h"
#import "PNBindMarketingViewController.h"
#import "PNMarketingDetailViewController.h"
#import "PNMarketingBindListViewController.h"
#import "PNMarketingManager.h"
#import "PNCheckMarketingRspModel.h"
#import "PNForgotPinCodeSendSMSViewController.h"


@implementation _Target (PayNow)

- (void)_Action(openWallet):(NSDictionary *)params {
    PNOpenWalletVC *vc = [[PNOpenWalletVC alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(deposit):(NSDictionary *)params {
    PNDepositViewController *vc = [[PNDepositViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(payWebView):(NSDictionary *)params {
    PNWebViewController *vc = [[PNWebViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(orderResult):(NSDictionary *)params {
    PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(wallet):(NSDictionary *)params {
    //    if (SAUser.shared.tradePwdExist) {//存在支付密码即开通了钱包,...不准。。。
    PNWalletController *vc = [[PNWalletController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
    //    }else{
    //        OpenWalletVC *vc = [[OpenWalletVC alloc] initWithRouteParameters:params];
    //        [SAWindowManager navigateToViewController:vc parameters:params];
    //    }
}

/// 银行列表
- (void)_Action(bankList):(NSDictionary *)params {
    PNBankListViewController *vc = [[PNBankListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 限额说明
- (void)_Action(walletLimit):(NSDictionary *)params {
    PNWalletLimitVC *vc = [[PNWalletLimitVC alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 交易记录列表
- (void)_Action(billList):(NSDictionary *)params {
    PNBillListViewController *vc = [[PNBillListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 扫一扫
- (void)_Action(pnScanner):(NSDictionary *)params {
    WQCodeScanner *vc = [[WQCodeScanner alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 付款码
- (void)_Action(paymentCode):(NSDictionary *)params {
    PNPaymentCodeViewController *vc = [[PNPaymentCodeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 收款码
- (void)_Action(receiveCode):(NSDictionary *)params {
    PNReceiveCodeViewController *vc = [[PNReceiveCodeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 收款码 - 设置金额
- (void)_Action(setReceiveAmount):(NSDictionary *)params {
    PNSetAmountViewController *vc = [[PNSetAmountViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 开通钱包输入资料
- (void)_Action(openWalletInput):(NSDictionary *)params {
    PNOpenWalletInputVC *vc = [[PNOpenWalletInputVC alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 用户上传证件图片
- (void)_Action(uploadImage):(NSDictionary *)params {
    PNUploadImageViewController *vc = [[PNUploadImageViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 转账列表
- (void)_Action(transList):(NSDictionary *)params {
    PNTransListViewController *vc = [[PNTransListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 升级账户
- (void)_Action(upgradeAccount):(NSDictionary *)params {
    PNUpgradeAccountViewController *vc = [[PNUpgradeAccountViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 升级账户 - 结果页面
- (void)_Action(upgradeAccountResult):(NSDictionary *)params {
    PNUpgradeResultViewController *vc = [[PNUpgradeResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 账户信息
- (void)_Action(accountInfo):(NSDictionary *)params {
    PNAccountInfoViewController *vc = [[PNAccountInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 钱包 - 设置
- (void)_Action(payNowSetting):(NSDictionary *)params {
    PNWalletSettingViewController *vc = [[PNWalletSettingViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 账单支付 - Utilities
- (void)_Action(utilities):(NSDictionary *)params {
    PNUtilitiesViewController *vc = [[PNUtilitiesViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 水费账单 - 查询
- (void)_Action(queryWaterPayment):(NSDictionary *)params {
    PNQueryWaterPaymentViewController *vc = [[PNQueryWaterPaymentViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 水费账单 - 提交
- (void)_Action(submitWaterPayment):(NSDictionary *)params {
    PNSubmitWaterPaymentViewController *vc = [[PNSubmitWaterPaymentViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 水费账单 - 交易结果
- (void)_Action(paymentResult):(NSDictionary *)params {
    PNWaterPaymentResultViewController *vc = [[PNWaterPaymentResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 水费账单 - 账单详情
- (void)_Action(paymentOrderDetails):(NSDictionary *)params {
    PNPaymentOrderDetailsViewController *vc = [[PNPaymentOrderDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 修改账单金额
- (void)_Action(billModifyAccount):(NSDictionary *)params {
    PNBillModifyAmountViewController *vc = [[PNBillModifyAmountViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// Coolcash网点
- (void)_Action(coolcashOutlet):(NSDictionary *)params {
    PNOutletViewController *vc = [[PNOutletViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 供应商列表
- (void)_Action(supplierList):(NSDictionary *)params {
    PNBillSupplierListViewController *vc = [[PNBillSupplierListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 转账到手机
- (void)_Action(transToPhone):(NSDictionary *)params {
    PNTransPhoneController *vc = [[PNTransPhoneController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商家服务介绍
- (void)_Action(merchantServicesIntroduction):(NSDictionary *)params {
    PNMSIntroductionController *vc = [[PNMSIntroductionController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商家服务 - 申请开通
- (void)_Action(merchantServicesApplyOpen):(NSDictionary *)params {
    PNMSOpenController *vc = [[PNMSOpenController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商家服务首页
- (void)_Action(merchantServicesHome):(NSDictionary *)params {
    [PNMSHomeManager adjustCheckMerchantServicesCompletion:^(BOOL isSuccess,
                                                             NSString *_Nonnull merchantNo,
                                                             NSString *_Nonnull merchantName,
                                                             NSString *_Nonnull operatorNo,
                                                             PNMSRoleType role,
                                                             NSArray *_Nonnull merchantMenus,
                                                             NSArray *_Nonnull permission,
                                                             NSString *_Nonnull storeNo,
                                                             NSString *_Nonnull storeName) {
        if (isSuccess) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
            [dict setObject:merchantNo forKey:@"merchantNo"];
            [dict setObject:operatorNo forKey:@"operatorNo"];
            [dict setObject:@(role) forKey:@"role"];
            [dict setObject:merchantMenus forKey:@"merchantMenus"];
            [dict setObject:merchantName forKey:@"merchantName"];
            [dict setObject:permission forKey:@"permission"];
            [dict setObject:storeNo ?: @"" forKey:@"storeNo"];
            [dict setObject:storeName ?: @"" forKey:@"storeName"];
            PNMSHomeController *vc = [[PNMSHomeController alloc] initWithRouteParameters:dict];
            [SAWindowManager navigateToViewController:vc parameters:dict];
        }
    }];
}

/// 关联商户 - 输入商户ID
- (void)_Action(merchantServicesPreBind):(NSDictionary *)params {
    PNMSPreBindController *vc = [[PNMSPreBindController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 关联商户
- (void)_Action(merchantServicesBind):(NSDictionary *)params {
    PNMSBindController *vc = [[PNMSBindController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 关联商户结果页
- (void)_Action(merchantServicesBindResult):(NSDictionary *)params {
    PNMSBindResultController *vc = [[PNMSBindResultController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 开通商户结果页
- (void)_Action(merchantServicesOpenResult):(NSDictionary *)params {
    PNMSOpenResultController *vc = [[PNMSOpenResultController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 入金【转账】
- (void)_Action(merchantServicesWithdrawToWallet):(NSDictionary *)params {
    PNMSWithdrawToWalletViewController *vc = [[PNMSWithdrawToWalletViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户收款
- (void)_Action(merchantServicesCollection):(NSDictionary *)params {
    PNMSCollectionController *vc = [[PNMSCollectionController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 交易列表
- (void)_Action(merchantServicesOrderList):(NSDictionary *)params {
    PNMSOrderListController *vc = [[PNMSOrderListController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 交易详情
- (void)_Action(merchantServicesOrderDetails):(NSDictionary *)params {
    PNMSOrderDetailsController *vc = [[PNMSOrderDetailsController alloc] initWithRouteParameters:params];
    BOOL isPresent = [[params valueForKey:@"isPresent"] boolValue];
    if (isPresent) {
        [SAWindowManager presentViewController:vc parameters:params needNavCWrapper:YES];
        //        [SAWindowManager presentViewController:vc parameters:params];

    } else {
        [SAWindowManager navigateToViewController:vc parameters:params];
    }
}

/// 商户服务 - 设置交易密码
- (void)_Action(merchantServicesSetPwd):(NSDictionary *)params {
    PNMSTradePwdController *vc = [[PNMSTradePwdController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 地址选择
- (void)_Action(merchantServicesMapAddress):(NSDictionary *)params {
    PNMSMapAddressController *vc = [[PNMSMapAddressController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账
- (void)_Action(internationalTransfer):(NSDictionary *)params {
    [PNInterTransferManager adjustChecKInterTransferCompletion:^(BOOL isSuccess) {
        if (isSuccess) {
            PNInterTransferIndexViewController *vc = [[PNInterTransferIndexViewController alloc] initWithRouteParameters:params];
            [SAWindowManager navigateToViewController:vc parameters:params];
        }
    }];
}

/// 国际转账 - 交易记录列表
- (void)_Action(internationalTransferRecordsList):(NSDictionary *)params {
    PNInterTransferRecordsViewController *vc = [[PNInterTransferRecordsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 交易记录详情
- (void)_Action(internationalTransferRecordsDetail):(NSDictionary *)params {
    PNInterRransferRecordDetailViewController *vc = [[PNInterRransferRecordDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 转账管理
- (void)_Action(internationalTransferManager):(NSDictionary *)params {
    PNInterTransferManageViewController *vc = [[PNInterTransferManageViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 收款人信息列表[指定渠道]
- (void)_Action(internationalTransferReciverInfoListWithChannel):(NSDictionary *)params {
    PNInterTransferReciverInfoViewController *vc = [[PNInterTransferReciverInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 收款人信息列表
- (void)_Action(internationalTransferReciverInfoList):(NSDictionary *)params {
    PNNewInterTransferReciverInfoViewController *vc = [[PNNewInterTransferReciverInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 收款人信息(新增/编辑)
- (void)_Action(internationalTransferAddOrUpdateReciverInfo):(NSDictionary *)params {
    PNAddAndEditReciverInfoViewController *vc = [[PNAddAndEditReciverInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 手续费[带渠道 单个显示]
- (void)_Action(internationalTransferRateWithChannel):(NSDictionary *)params {
    PNInterTransferRateController *vc = [[PNInterTransferRateController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 手续费
- (void)_Action(internationalTransferRate):(NSDictionary *)params {
    PNNewInteTransferRateViewController *vc = [[PNNewInteTransferRateViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 限额[带渠道 单个显示]
- (void)_Action(internationalTransferLimitWithChannel):(NSDictionary *)params {
    PNInterTransferLimitController *vc = [[PNInterTransferLimitController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 限额
- (void)_Action(internationalTransferLimit):(NSDictionary *)params {
    PNNewInterTransferLimitViewController *vc = [[PNNewInterTransferLimitViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 联系我们
- (void)_Action(contactUS):(NSDictionary *)params {
    PNContactUSViewController *vc = [[PNContactUSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 设置
- (void)_Action(merchantServicesSetting):(NSDictionary *)params {
    PNMSSettingViewController *vc = [[PNMSSettingViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 收款码
- (void)_Action(merchantServicesReceiveCode):(NSDictionary *)params {
    PNMSReceiveCodeViewController *vc = [[PNMSReceiveCodeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 修改交易密码 [询问页]
- (void)_Action(merchantServicesAskTradePassword):(NSDictionary *)params {
    PNMSAskTradePwdViewController *vc = [[PNMSAskTradePwdViewController alloc] initWithRouteParameters:params];
    if ([params[@"present"] boolValue]) {
        [SAWindowManager presentViewController:vc parameters:params];
    } else {
        [SAWindowManager navigateToViewController:vc parameters:params];
    }
}

/// 商户服务 - 发送短信【忘记密码 重置密码】
- (void)_Action(merchantServicesPwdSendSMS):(NSDictionary *)params {
    PNMSPwdSendSMSViewController *vc = [[PNMSPwdSendSMSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 商户服务协议 中间页
- (void)_Action(merchantServicesArgeementWarp):(NSDictionary *)params {
    PNMSAgreementWarpViewController *vc = [[PNMSAgreementWarpViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 协议和条款
- (void)_Action(terms):(NSDictionary *)params {
    PNTermsViewController *vc = [[PNTermsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 忘记密码 - 联系客服
- (void)_Action(passwordContactUS):(NSDictionary *)params {
    PNPasswordContactUSController *vc = [[PNPasswordContactUSController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 忘记密码 - 校验验证码
- (void)_Action(forgotPasswordVerifySMSCode):(NSDictionary *)params {
    PNForgotPasswordVerifySMSCodeController *vc = [[PNForgotPasswordVerifySMSCodeController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 忘记密码 - 联系客服
- (void)_Action(merchantServicesPasswordContactUS):(NSDictionary *)params {
    PNMSPasswordContactUSController *vc = [[PNMSPasswordContactUSController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 忘记密码 - 校验验证码
- (void)_Action(merchantServicesForgotPasswordVerifySMSCode):(NSDictionary *)params {
    PNMSForgotPasswordVerifySMSCodeController *vc = [[PNMSForgotPasswordVerifySMSCodeController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 进入钱包 - 身份校验
- (void)_Action(idVerify):(NSDictionary *)params {
    PNIDVerifyViewController *vc = [[PNIDVerifyViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 操作员管理
- (void)_Action(merchantServicesOperatorManager):(NSDictionary *)params {
    PNMSOperatorManagerViewController *vc = [[PNMSOperatorManagerViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 添加或者编辑操作员管理
- (void)_Action(merchantServicesAddOrEditOperator):(NSDictionary *)params {
    PNMSAddOrEditOperatorViewController *vc = [[PNMSAddOrEditOperatorViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 门店管理
- (void)_Action(merchantServicesStoreManager):(NSDictionary *)params {
    PNMSStoreManagerViewController *vc = [[PNMSStoreManagerViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 门店操作员管理
- (void)_Action(merchantServicesStoreOperatorManager):(NSDictionary *)params {
    PNMSStoreOperatorManagerViewController *vc = [[PNMSStoreOperatorManagerViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 新增/编辑 门店操作员管理
- (void)_Action(merchantServicesStoreOperatorAddOrEdit):(NSDictionary *)params {
    PNMSStoreOperatorAddOrEditViewController *vc = [[PNMSStoreOperatorAddOrEditViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 新增/编辑 门店
- (void)_Action(merchantServicesAddOrEditStore):(NSDictionary *)params {
    PNMSStoreAddOrEditViewController *vc = [[PNMSStoreAddOrEditViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 门店中间页
- (void)_Action(merchantServicesStoreMiddle):(NSDictionary *)params {
    PNMStoreMiddleViewController *vc = [[PNMStoreMiddleViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 门店详情
- (void)_Action(merchantServicesStoreInfo):(NSDictionary *)params {
    PNMSStoreInfoViewController *vc = [[PNMSStoreInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 提现 【提现方式的列表】
- (void)_Action(merchantServicesWithdrawList):(NSDictionary *)params {
    PNMSWithdrawListViewController *vc = [[PNMSWithdrawListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 提现金额输入页面
- (void)_Action(merchantServicesWithdrawInputAmount):(NSDictionary *)params {
    PNMSInputAmountViewController *vc = [[PNMSInputAmountViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 提现到银行
- (void)_Action(merchantServicesWithdrawToBank):(NSDictionary *)params {
    PNMSWithdrawToBankViewController *vc = [[PNMSWithdrawToBankViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 添加银行卡
- (void)_Action(merchantServicesAddWithdrawBankCard):(NSDictionary *)params {
    PNMSAddBankCardViewController *vc = [[PNMSAddBankCardViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 凭证列表
- (void)_Action(merchantServicesVoucherList):(NSDictionary *)params {
    PNMSVoucherListViewController *vc = [[PNMSVoucherListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 上传凭证
- (void)_Action(merchantServicesUploadVoucher):(NSDictionary *)params {
    PNMSUploadVoucherViewController *vc = [[PNMSUploadVoucherViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 凭证详情
- (void)_Action(merchantServicesVoucherDetail):(NSDictionary *)params {
    PNMVoucherDetailViewController *vc = [[PNMVoucherDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 操作员密码【中间页】
- (void)_Action(merchantServicesContactAdmin):(NSDictionary *)params {
    PNMSPasswordContactAdminViewController *vc = [[PNMSPasswordContactAdminViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 国际转账 - 渠道
- (void)_Action(internationalTransferChannel):(NSDictionary *)params {
    PNInterTransferChannelViewController *vc = [[PNInterTransferChannelViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费
- (void)_Action(apartmentHome):(NSDictionary *)params {
    PNApartmentListViewController *vc = [[PNApartmentListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费 确认页
- (void)_Action(apartmentComfirm):(NSDictionary *)params {
    PNApartmentComfirmViewController *vc = [[PNApartmentComfirmViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费记录列表
- (void)_Action(apartmentRecordList):(NSDictionary *)params {
    PNApartmentRecordListViewController *vc = [[PNApartmentRecordListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓账单详情
- (void)_Action(apartmentRecordDetail):(NSDictionary *)params {
    PNApartmentRecordDetailViewController *vc = [[PNApartmentRecordDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费 - 拒绝
- (void)_Action(apartmentReject):(NSDictionary *)params {
    PNApartmentRejectViewController *vc = [[PNApartmentRejectViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费 - 结果页【拒绝 和 上传凭证】
- (void)_Action(apartmentResult):(NSDictionary *)params {
    PNApartmentResultViewController *vc = [[PNApartmentResultViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费 - 上传凭证
- (void)_Action(apartmentUploadVoucher):(NSDictionary *)params {
    PNApartmentUploadVoucherViewController *vc = [[PNApartmentUploadVoucherViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 公寓缴费 - 订单页面[中转页面]
- (void)_Action(apartmentOrderList):(NSDictionary *)params {
    PNApartmentOrderListViewController *vc = [[PNApartmentOrderListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 游戏账单支付
- (void)_Action(gamePayment):(NSDictionary *)params {
    PNGameListViewController *vc = [[PNGameListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 红包首页
- (void)_Action(luckPacketHome):(NSDictionary *)params {
    PNLuckPacketHomeViewController *vc = [[PNLuckPacketHomeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 红包消息记录
- (void)_Action(luckPacketRecords):(NSDictionary *)params {
    PNLuckyPacketRecordsRootViewController *vc = [[PNLuckyPacketRecordsRootViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 发红包 页面
- (void)_Action(handoutPacket):(NSDictionary *)params {
    PNHandOutLuckyPacketViewController *vc = [[PNHandOutLuckyPacketViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 红包消息 页面
- (void)_Action(luckPacketMessage):(NSDictionary *)params {
    PNPacketMessageViewController *vc = [[PNPacketMessageViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 开红包
- (void)_Action(openPacket):(NSDictionary *)params {
    PNPacketOpenViewController *vc = [[PNPacketOpenViewController alloc] initWithParam:params];

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[SAWindowManager visibleViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

/// 红包领取详情
- (void)_Action(packetDetail):(NSDictionary *)params {
    PNPacketRecordDetailsViewController *vc = [[PNPacketRecordDetailsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 账单支付交易列表
- (void)_Action(billPaymentList):(NSDictionary *)params {
    PNBillPaymentListViewController *vc = [[PNBillPaymentListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 商户服务 - 商户信息
- (void)_Action(merchantServicesMerchantInfo):(NSDictionary *)params {
    PNMSMerchantInfoViewController *vc = [[PNMSMerchantInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 担保交易首页
- (void)_Action(guaranteeHome):(NSDictionary *)params {
    PNGuaranteeListViewController *vc = [[PNGuaranteeListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 发起担保交易 - 中间页
- (void)_Action(guaranteeInitSelect):(NSDictionary *)params {
    PNGuaranteeInitViewController *vc = [[PNGuaranteeInitViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 卖方发起交易
- (void)_Action(guaranteeSalerInit):(NSDictionary *)params {
    PNGuaranteeSalerInitViewController *vc = [[PNGuaranteeSalerInitViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 买方发起交易
- (void)_Action(guaranteeBuyerInit):(NSDictionary *)params {
    PNGuaranteeBuyerViewController *vc = [[PNGuaranteeBuyerViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 担保交易详情
- (void)_Action(guaranteenRecordDetail):(NSDictionary *)params {
    PNGuarateenRecordDetailViewController *vc = [[PNGuarateenRecordDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 钱包明细列表
- (void)_Action(walletOrderList):(NSDictionary *)params {
    PNWalletOrderListViewController *vc = [[PNWalletOrderListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 钱包明细详情
- (void)_Action(walletOrderDetail):(NSDictionary *)params {
    PNWalletOrderDetailViewController *vc = [[PNWalletOrderDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 确认支付 - 新的
- (void)_Action(walletPaymentComfirm):(NSDictionary *)params {
    PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 信贷
- (void)_Action(loanMain):(NSDictionary *)params {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    [PNCreditManager.sharedInstance checkCreditAuthorizationCompletion:^(BOOL needAuth, NSDictionary *_Nonnull rspData) {
        if (needAuth) {
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:params];
            [newDict setValue:rspData forKey:@"data"];
            PNPreCheckCreditViewController *vc = [[PNPreCheckCreditViewController alloc] initWithRouteParameters:newDict];
            [SAWindowManager navigateToViewController:vc parameters:newDict];
        } else {
            HDLog(@"有错误有错误有错误有错误有错误");
        }
    }];
}

/// 绑定 推广员
- (void)_Action(bindMarketing):(NSDictionary *)params {
    PNBindMarketingViewController *vc = [[PNBindMarketingViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

/// 推广专员统计页面
- (void)_Action(marketingHome):(NSDictionary *)params {
    [PNMarketingManager checkUser:^(PNCheckMarketingRspModel *_Nonnull rspModel) {
        if (rspModel.isPromoter) {
            PNMarketingDetailViewController *vc = [[PNMarketingDetailViewController alloc] initWithRouteParameters:@{
                @"data": [rspModel yy_modelToJSONObject],
            }];
            [SAWindowManager navigateToViewController:vc parameters:params];
        } else {
            if (!rspModel.isBinded) {
                PNBindMarketingViewController *vc = [[PNBindMarketingViewController alloc] initWithRouteParameters:@{
                    @"data": [rspModel yy_modelToJSONObject],
                }];
                [SAWindowManager navigateToViewController:vc parameters:params];
            } else {
                NSString *msg = [NSString
                    stringWithFormat:PNLocalizedString(@"IcCJ6eMk", @"您已经与我司推广专员%@（%@ %@）绑定,无需再次绑定"), rspModel.promoterLoginName, rspModel.promoterSurName, rspModel.promoterName];
                [NAT showAlertWithMessage:msg buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
            }
        }
    }];
}

/// 推广绑定详情
- (void)_Action(marketingBindList):(NSDictionary *)params {
    PNMarketingBindListViewController *vc = [[PNMarketingBindListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(forgotPinCodeSendSMS):(NSDictionary *)params {
    PNForgotPinCodeSendSMSViewController *vc = [[PNForgotPinCodeSendSMSViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

@end
