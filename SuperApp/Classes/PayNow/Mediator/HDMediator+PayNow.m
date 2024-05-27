#import "HDMediator+PayNow.h"
#import "SAAppEnvManager.h"


@implementation HDMediator (PayNow)

/// 开通钱包
- (void)navigaveToPayNowOpenWalletVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"openWallet" params:params];
}

- (void)navigaveToPayNowPayWebViewViewController:(NSDictionary *)params {
    NSString *url = [params valueForKey:@"url"];
    if (HDIsStringEmpty(url)) {
        NSString *path = [params valueForKey:@"path"];
        SAAppEnvConfig *model = SAAppEnvManager.sharedInstance.appEnvConfig;
        url = [NSString stringWithFormat:@"%@%@%@", model.payH5Url, [path hasPrefix:@"/"] ? @"" : @"/", path];
    }
    [self performActionWithURL:url];
}

/// 打开一个webView 【coolcash 服务协议】
- (void)navigaveToPayNowPayWebViewVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"payWebView" params:params];
}

/// 入金
- (void)navigaveToPayNowDepositVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"deposit" params:params];
}

/// 交易详情/账单详情
- (void)navigaveToPayNowOrderResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"orderResult" params:params];
}

/// 钱包主页
- (void)navigaveToPayNowWalletVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"wallet" params:params];
}

/// 银行列表
- (void)navigaveToPayNowBankList:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"bankList" params:params];
}

/// 限额说明
- (void)navigaveToPayNowWalletLimitVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"walletLimit" params:params];
}

/// 交易记录列表
- (void)navigaveToPayNowBillListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"billList" params:params];
}

/// 扫一扫
- (void)navigaveToPayNowScannerVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"pnScanner" params:params];
}

/// 付款码
- (void)navigaveToPayNowPaymentCodeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"paymentCode" params:params];
}

/// 收款码
- (void)navigaveToPayNowReceiveCodeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"receiveCode" params:params];
}

/// 收款码 - 设置金额
- (void)navigaveToPayNowSetReceiveAmountVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"setReceiveAmount" params:params];
}

/// 开通钱包输入资料
- (void)navigaveToPayNowOpenWalletInputVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"openWalletInput" params:params];
}

/// 用户上传证件图片
- (void)navigaveToPayNowUploadImageVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"uploadImage" params:params];
}

/// 转账列表
- (void)navigaveToPayNowTransListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"transList" params:params];
}

/// 升级账户
- (void)navigaveToPayNowUpgradeAccountVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"upgradeAccount" params:params];
}

/// 升级账户 - 结果页
- (void)navigaveToPayNowUpgradeAccountResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"upgradeAccountResult" params:params];
}

/// 账户信息
- (void)navigaveToPayNowAccountInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"accountInfo" params:params];
}

/// 钱包 - 设置
- (void)navigaveToPayNowSettingVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"payNowSetting" params:params];
}

/// 账单支付 - Utilities
- (void)navigaveToPayNowUtilitiesVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"utilities" params:params];
}

/// 水费账单 - 查询
- (void)navigaveToPayNowQueryWaterPaymentVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"queryWaterPayment" params:params];
}

/// 水费账单 - 提交
- (void)navigaveToPayNowSubmitWaterPaymentVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"submitWaterPayment" params:params];
}

/// 水费账单 - 交易结果
- (void)navigaveToPayNowPaymentResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"paymentResult" params:params];
}

/// 水费账单 - 账单详情
- (void)navigaveToPayNowPaymentBillOrderDetailsVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"paymentOrderDetails" params:params];
}

/// 修改账单金额
- (void)navigaveToPayNowPaymentBillModifyAccountVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"billModifyAccount" params:params];
}

/// Coolcash网点
- (void)navigaveToPayNowCoolcashOutletVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"coolcashOutlet" params:params];
}

/// 供应商列表
- (void)navigaveToPayNowSupplierListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"supplierList" params:params];
}

/// 转账到手机
- (void)navigaveToPayNowTransToPhoneVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"transToPhone" params:params];
}

/// 商家服务介绍
- (void)navigaveToPayNowMerchantServicesIntroductionVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesIntroduction" params:params];
}

/// 商家服务 - 申请开通
- (void)navigaveToPayNowMerchantServicesApplyOpenVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesApplyOpen" params:params];
}

/// 商家服务首页
- (void)navigaveToPayNowMerchantServicesHomeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesHome" params:params];
}

/// 关联商户 - 输入商户ID
- (void)navigaveToPayNowMerchantServicesPreBindVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesPreBind" params:params];
}

/// 关联商户
- (void)navigaveToPayNowMerchantServicesBindVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesBind" params:params];
}

/// 关联商户结果页
- (void)navigaveToPayNowMerchantServicesBindResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesBindResult" params:params];
}

/// 开通商户结果页
- (void)navigaveToPayNowMerchantServicesOpenResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesOpenResult" params:params];
}

/// 商户服务 - 入金【转账】
- (void)navigaveToPayNowMerchantServicesWithdrawToWalletVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesWithdrawToWallet" params:params];
}

/// 商户收款
- (void)navigaveToPayNowMerchantServicesCollectionVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesCollection" params:params];
}

/// 商户服务 - 交易列表
- (void)navigaveToPayNowMerchantServicesOrderListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesOrderList" params:params];
}

/// 商户服务 - 交易详情
- (void)navigaveToPayNowMerchantServicesOrderDetailsVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesOrderDetails" params:params];
}

/// 商户服务 - 设置交易密码
- (void)navigaveToPayNowMerchantServicesSetTradePwdVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesSetPwd" params:params];
}

/// 商户服务 - 地址选择
- (void)navigaveToPayNowMerchantServicesMapAddressVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesMapAddress" params:params];
}

/// 国际转账
- (void)navigaveToInternationalTransferIndexVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransfer" params:params];
}

/// 国际转账 - 交易记录列表
- (void)navigaveToInternationalTransferRecordsListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferRecordsList" params:params];
}

/// 国际转账 - 交易记录详情
- (void)navigaveToInternationalTransferRecordsDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferRecordsDetail" params:params];
}

/// 国际转账 - 转账管理
- (void)navigaveToInternationalTransferManagerVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferManager" params:params];
}

/// 国际转账 - 收款人信息列表
- (void)navigaveToInternationalTransferReciverInfoListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferReciverInfoList" params:params];
}

/// 国际转账 - 收款人信息列表[指定渠道]
- (void)navigaveToInternationalTransferReciverInfoListWithChannelVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferReciverInfoListWithChannel" params:params];
}

/// 国际转账 - 收款人信息(新增/编辑)
- (void)navigaveToInternationalTransferAddOrUpdateReciverInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferAddOrUpdateReciverInfo" params:params];
}

/// 国际转账 - 手续费[带渠道 单个显示]
- (void)navigaveToInternationalTransferRateWithChannelVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferRateWithChannel" params:params];
}

/// 国际转账 - 手续费
- (void)navigaveToInternationalTransferRateVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferRate" params:params];
}

/// 国际转账 - 限额[带渠道 单个显示]
- (void)navigaveToInternationalTransferLimitWithChannelVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferLimitWithChannel" params:params];
}

/// 国际转账 - 限额
- (void)navigaveToInternationalTransferLimitVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferLimit" params:params];
}

/// 联系我们
- (void)navigaveToPayNowContacUSVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"contactUS" params:params];
}

/// 商户服务 - 设置
- (void)navigaveToPayNowMerchantServicesSettingVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesSetting" params:params];
}

/// 商户服务 - 收款码
- (void)navigaveToPayNowMerchantServicesReceiveCodeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesReceiveCode" params:params];
}

/// 商户服务 - 修改交易密码
- (void)navigaveToPayNowMerchantServicesAskTradePasswordVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesAskTradePassword" params:params];
}

/// 商户服务 - 发送短信【忘记密码 重置密码】
- (void)navigaveToPayNowMerchantServicesPwdSendSMSVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesPwdSendSMS" params:params];
}

/// 商户服务 - 商户服务协议 中间页
- (void)navigaveToPayNowMerchantServicesArgeementWarpVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesArgeementWarp" params:params];
}

/// 协议和条款
- (void)navigaveToPayNowTermsVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"terms" params:params];
}

/// 忘记密码 - 联系客服
- (void)navigaveToPayNowPasswordContactUSVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"passwordContactUS" params:params];
}

/// 忘记密码 - 校验验证码
- (void)navigaveToPayNowForgotPasswordVerifySMSCodeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"forgotPasswordVerifySMSCode" params:params];
}

/// 商户服务 忘记密码 - 联系客服
- (void)navigaveToPayNowMerchantServicesPasswordContactUSVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesPasswordContactUS" params:params];
}

/// 商户服务 忘记密码 - 校验验证码
- (void)navigaveToPayNowMerchantServicesForgotPasswordVerifySMSCodeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesForgotPasswordVerifySMSCode" params:params];
}

/// 进入钱包 - 身份校验
- (void)navigaveToPayNowIdVerifyVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"idVerify" params:params];
}

/// 商户服务 - 操作员管理
- (void)navigaveToPayNowMerchantServicesOperatorManagerVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesOperatorManager" params:params];
}

/// 商户服务 - 添加或者编辑操作员管理
- (void)navigaveToPayNowMerchantServicesAddOrEditOperatorVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesAddOrEditOperator" params:params];
}

/// 商户服务 - 门店管理
- (void)navigaveToPayNowMerchantServicesStoreManagerVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesStoreManager" params:params];
}

/// 商户服务 - 门店操作员管理
- (void)navigaveToPayNowMerchantServicesStoreOperatorManagerVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesStoreOperatorManager" params:params];
}

/// 商户服务 - 新增/编辑 门店操作员管理
- (void)navigaveToPayNowMerchantServicesStoreOperatorAddOrEditVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesStoreOperatorAddOrEdit" params:params];
}

/// 商户服务 - 新增/编辑 门店
- (void)navigaveToPayNowMerchantServicesAddOrEditStoreVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesAddOrEditStore" params:params];
}

/// 商户服务 - 门店中间页
- (void)navigaveToPayNowMerchantServicesStoreMiddleVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesStoreMiddle" params:params];
}

/// 商户服务 - 门店详情
- (void)navigaveToPayNowMerchantServicesStoreInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesStoreInfo" params:params];
}

/// 商户服务 - 提现 【提现方式的列表】
- (void)navigaveToPayNowMerchantServicesWithdrawListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesWithdrawList" params:params];
}

/// 商户服务 - 提现金额输入页面
- (void)navigaveToPayNowMerchantServicesWithdrawInputAmountVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesWithdrawInputAmount" params:params];
}

/// 商户服务 - 提现到银行
- (void)navigaveToPayNowMerchantServicesWithdrawToBankVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesWithdrawToBank" params:params];
}

/// 商户服务 - 添加银行卡
- (void)navigaveToPayNowMerchantServicesAddWithdrawBankCardVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesAddWithdrawBankCard" params:params];
}

/// 商户服务 - 凭证列表
- (void)navigaveToPayNowMerchantServicesVoucherListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesVoucherList" params:params];
}

/// 商户服务 - 上传凭证
- (void)navigaveToPayNowMerchantServicesUploadVoucherVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesUploadVoucher" params:params];
}

/// 商户服务 - 凭证详情
- (void)navigaveToPayNowMerchantServicesVoucherDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesVoucherDetail" params:params];
}

/// 商户服务 - 操作员密码【中间页】
- (void)navigaveToPayNowMerchantServicesContactAdminVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesContactAdmin" params:params];
}

/// 国际转账 - 渠道
- (void)navigaveToInternationalTransferChannelVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"internationalTransferChannel" params:params];
}

/// 公寓缴费
- (void)navigaveToPayNowApartmentHomeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentHome" params:params];
}

/// 公寓缴费 确认页
- (void)navigaveToPayNowApartmentComfirmVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentComfirm" params:params];
}

/// 公寓缴费记录列表
- (void)navigaveToPayNowApartmentRecordListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentRecordList" params:params];
}

/// 公寓账单详情
- (void)navigaveToPayNowApartmentRecordDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentRecordDetail" params:params];
}

/// 公寓缴费 - 拒绝
- (void)navigaveToPayNowApartmentRejectVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentReject" params:params];
}

/// 公寓缴费 - 结果页【拒绝 和 上传凭证】
- (void)navigaveToPayNowApartmentResultVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentResult" params:params];
}

/// 公寓缴费 - 上传凭证
- (void)navigaveToPayNowApartmentUploadVoucherVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentUploadVoucher" params:params];
}

/// 公寓缴费 - 订单页面[中转页面]
- (void)navigaveToPayNowApartmentOrderListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"apartmentOrderList" params:params];
}

/// 国际转账 - 渠道
- (void)navigaveToGamePaymentVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"gamePayment" params:params];
}

/// 红包首页
- (void)navigaveToLuckPacketHomeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"luckPacketHome" params:params];
}

/// 红包消息记录
- (void)navigaveToLuckPacketRecordsVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"luckPacketRecords" params:params];
}

/// 发红包 页面
- (void)navigaveToHandOutPacketVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"handoutPacket" params:params];
}

/// 红包消息 页面
- (void)navigaveToLuckPacketMessageVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"luckPacketMessage" params:params];
}

/// 开红包
- (void)navigaveToOpenPacketVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"openPacket" params:params];
}

/// 红包领取详情
- (void)navigaveToPacketDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"packetDetail" params:params];
}

/// 担保交易首页
- (void)navigaveToPayNowGuaranteeHomeVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"guaranteeHome" params:params];
}

/// 发起担保交易 - 中间页
- (void)navigaveToPayNowGuaranteeInitSelectVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"guaranteeInitSelect" params:params];
}

/// 卖方发起交易
- (void)navigaveToPayNowGuaranteeSalerInitVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"guaranteeSalerInit" params:params];
}

/// 买方发起交易
- (void)navigaveToPayNowGuaranteeBuyerInitVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"guaranteeBuyerInit" params:params];
}

/// 担保交易详情
- (void)navigaveToPayNowGuaranteenRecordDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"guaranteenRecordDetail" params:params];
}

/// 账单支付交易列表
- (void)navigaveToBillPaymentListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"billPaymentList" params:params];
}

/// 钱包明细列表
- (void)navigaveToWalletOrderListVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"walletOrderList" params:params];
}

/// 钱包明细详情
- (void)navigaveToWalletOrderDetailVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"walletOrderDetail" params:params];
}

/// 确认支付 - 新的
- (void)navigaveToWalletPaymentComfirmVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"walletPaymentComfirm" params:params];
}

/// 商户服务 - 商户信息
- (void)navigaveToMerchantServicesMerchantInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"merchantServicesMerchantInfo" params:params];
}

/// 信贷
- (void)navigaveToPayNowCreditVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"loanMain" params:params];
}

/// 绑定推广专员
- (void)navigaveToPayNowBindMarketingInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"bindMarketing" params:params];
}

/// 推广专员统计页面
- (void)navigaveToPayNowMarketingHomeInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"marketingHome" params:params];
}

/// 推广绑定详情
- (void)navigaveToPayNowBindMarketingListInfoVC:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"marketingBindList" params:params];
}

- (void)navigaveToForgotPinCodeSendSMSViewController:(NSDictionary *)params {
    [self performTarget:@"PayNow" action:@"forgotPinCodeSendSMS" params:params];
}

@end
