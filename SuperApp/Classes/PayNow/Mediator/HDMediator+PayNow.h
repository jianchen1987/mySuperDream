#import "HDMediator+SuperApp.h"
#import <HDKitCore/HDKitCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDMediator (PayNow)
/// 开通钱包
- (void)navigaveToPayNowOpenWalletVC:(NSDictionary *)params;
- (void)navigaveToPayNowPayWebViewViewController:(NSDictionary *)params;
- (void)navigaveToPayNowPayWebViewVC:(NSDictionary *)params; //本地html
- (void)navigaveToPayNowDepositVC:(NSDictionary *)params;
- (void)navigaveToPayNowOrderResultVC:(NSDictionary *)params;
- (void)navigaveToPayNowWalletVC:(NSDictionary *)params;

/// 银行列表
- (void)navigaveToPayNowBankList:(NSDictionary *)params;

/// 限额说明
- (void)navigaveToPayNowWalletLimitVC:(NSDictionary *)params;

/// 交易记录列表
- (void)navigaveToPayNowBillListVC:(NSDictionary *)params;

/// 扫一扫
- (void)navigaveToPayNowScannerVC:(NSDictionary *)params;

/// 付款码
- (void)navigaveToPayNowPaymentCodeVC:(NSDictionary *)params;

/// 收款码
- (void)navigaveToPayNowReceiveCodeVC:(NSDictionary *)params;

/// 收款码 - 设置金额
- (void)navigaveToPayNowSetReceiveAmountVC:(NSDictionary *)params;

/// 开通钱包输入资料
- (void)navigaveToPayNowOpenWalletInputVC:(NSDictionary *)params;

/// 用户上传证件图片
- (void)navigaveToPayNowUploadImageVC:(NSDictionary *)params;

/// 转账列表
- (void)navigaveToPayNowTransListVC:(NSDictionary *)params;

/// 升级账户
- (void)navigaveToPayNowUpgradeAccountVC:(NSDictionary *)params;

/// 升级账户 - 结果页
- (void)navigaveToPayNowUpgradeAccountResultVC:(NSDictionary *)params;

/// 账户信息
- (void)navigaveToPayNowAccountInfoVC:(NSDictionary *)params;

/// 钱包 - 设置
- (void)navigaveToPayNowSettingVC:(NSDictionary *)params;

/// 账单支付 - Utilities
- (void)navigaveToPayNowUtilitiesVC:(NSDictionary *)params;

/// 水费账单 - 查询
- (void)navigaveToPayNowQueryWaterPaymentVC:(NSDictionary *)params;

/// 水费账单 - 提交
- (void)navigaveToPayNowSubmitWaterPaymentVC:(NSDictionary *)params;

/// 水费账单 - 交易结果
- (void)navigaveToPayNowPaymentResultVC:(NSDictionary *)params;

/// 水费账单 - 账单详情
- (void)navigaveToPayNowPaymentBillOrderDetailsVC:(NSDictionary *)params;

/// 修改账单金额
- (void)navigaveToPayNowPaymentBillModifyAccountVC:(NSDictionary *)params;

/// Coolcash网点
- (void)navigaveToPayNowCoolcashOutletVC:(NSDictionary *)params;

/// 供应商列表
- (void)navigaveToPayNowSupplierListVC:(NSDictionary *)params;

/// 转账到手机
- (void)navigaveToPayNowTransToPhoneVC:(NSDictionary *)params;

/// 商家服务介绍
- (void)navigaveToPayNowMerchantServicesIntroductionVC:(NSDictionary *)params;

/// 商家服务 - 申请开通
- (void)navigaveToPayNowMerchantServicesApplyOpenVC:(NSDictionary *)params;

/// 商家服务首页
- (void)navigaveToPayNowMerchantServicesHomeVC:(NSDictionary *)params;

/// 关联商户 - 输入商户ID
- (void)navigaveToPayNowMerchantServicesPreBindVC:(NSDictionary *)params;

/// 关联商户
- (void)navigaveToPayNowMerchantServicesBindVC:(NSDictionary *)params;

/// 关联商户结果页
- (void)navigaveToPayNowMerchantServicesBindResultVC:(NSDictionary *)params;

/// 开通商户结果页
- (void)navigaveToPayNowMerchantServicesOpenResultVC:(NSDictionary *)params;

/// 商户服务 - 入金【转账】
- (void)navigaveToPayNowMerchantServicesWithdrawToWalletVC:(NSDictionary *)params;

/// 商户收款
- (void)navigaveToPayNowMerchantServicesCollectionVC:(NSDictionary *)params;

/// 商户服务 - 交易列表
- (void)navigaveToPayNowMerchantServicesOrderListVC:(NSDictionary *)params;

/// 商户服务 - 交易详情
- (void)navigaveToPayNowMerchantServicesOrderDetailsVC:(NSDictionary *)params;

/// 商户服务 - 设置交易密码
- (void)navigaveToPayNowMerchantServicesSetTradePwdVC:(NSDictionary *)params;

/// 商户服务 - 地图地址选择
- (void)navigaveToPayNowMerchantServicesMapAddressVC:(NSDictionary *)params;

/// 国际转账首页
- (void)navigaveToInternationalTransferIndexVC:(NSDictionary *)params;

/// 国际转账 - 交易记录列表
- (void)navigaveToInternationalTransferRecordsListVC:(NSDictionary *)params;

/// 国际转账 - 交易记录详情
- (void)navigaveToInternationalTransferRecordsDetailVC:(NSDictionary *)params;

/// 国际转账 - 转账管理
- (void)navigaveToInternationalTransferManagerVC:(NSDictionary *)params;

/// 国际转账 - 收款人信息列表[指定渠道]
- (void)navigaveToInternationalTransferReciverInfoListWithChannelVC:(NSDictionary *)params;

/// 国际转账 - 收款人信息列表
- (void)navigaveToInternationalTransferReciverInfoListVC:(NSDictionary *)params;

/// 国际转账 - 收款人信息(新增/编辑)
- (void)navigaveToInternationalTransferAddOrUpdateReciverInfoVC:(NSDictionary *)params;

/// 国际转账 - 手续费[带渠道 单个显示]
- (void)navigaveToInternationalTransferRateWithChannelVC:(NSDictionary *)params;

/// 国际转账 - 手续费
- (void)navigaveToInternationalTransferRateVC:(NSDictionary *)params;

/// 国际转账 - 限额[带渠道 单个显示]
- (void)navigaveToInternationalTransferLimitWithChannelVC:(NSDictionary *)params;

/// 国际转账 - 限额
- (void)navigaveToInternationalTransferLimitVC:(NSDictionary *)params;

/// 联系我们
- (void)navigaveToPayNowContacUSVC:(NSDictionary *)params;

/// 商户服务 - 设置
- (void)navigaveToPayNowMerchantServicesSettingVC:(NSDictionary *)params;

/// 商户服务 - 收款码
- (void)navigaveToPayNowMerchantServicesReceiveCodeVC:(NSDictionary *)params;

/// 商户服务 - 修改交易密码
- (void)navigaveToPayNowMerchantServicesAskTradePasswordVC:(NSDictionary *)params;

/// 商户服务 - 发送短信【忘记密码 重置密码】
- (void)navigaveToPayNowMerchantServicesPwdSendSMSVC:(NSDictionary *)params;

/// 商户服务 - 商户服务协议 中间页
- (void)navigaveToPayNowMerchantServicesArgeementWarpVC:(NSDictionary *)params;

/// 协议和条款
- (void)navigaveToPayNowTermsVC:(NSDictionary *)params;

/// 忘记密码 - 联系客服
- (void)navigaveToPayNowPasswordContactUSVC:(NSDictionary *)params;

/// 忘记密码 - 校验验证码
- (void)navigaveToPayNowForgotPasswordVerifySMSCodeVC:(NSDictionary *)params;

/// 商户服务 忘记密码 - 联系客服
- (void)navigaveToPayNowMerchantServicesPasswordContactUSVC:(NSDictionary *)params;

/// 商户服务 忘记密码 - 校验验证码
- (void)navigaveToPayNowMerchantServicesForgotPasswordVerifySMSCodeVC:(NSDictionary *)params;

/// 进入钱包 - 身份校验
- (void)navigaveToPayNowIdVerifyVC:(NSDictionary *)params;

/// 商户服务 - 操作员管理
- (void)navigaveToPayNowMerchantServicesOperatorManagerVC:(NSDictionary *)params;

/// 商户服务 - 添加或者编辑操作员管理
- (void)navigaveToPayNowMerchantServicesAddOrEditOperatorVC:(NSDictionary *)params;

/// 商户服务 - 门店管理
- (void)navigaveToPayNowMerchantServicesStoreManagerVC:(NSDictionary *)params;

/// 商户服务 - 门店操作员管理
- (void)navigaveToPayNowMerchantServicesStoreOperatorManagerVC:(NSDictionary *)params;

/// 商户服务 - 新增/编辑 门店操作员管理
- (void)navigaveToPayNowMerchantServicesStoreOperatorAddOrEditVC:(NSDictionary *)params;

/// 商户服务 - 新增/编辑 门店
- (void)navigaveToPayNowMerchantServicesAddOrEditStoreVC:(NSDictionary *)params;

/// 商户服务 - 门店中间页
- (void)navigaveToPayNowMerchantServicesStoreMiddleVC:(NSDictionary *)params;

/// 商户服务 - 门店详情
- (void)navigaveToPayNowMerchantServicesStoreInfoVC:(NSDictionary *)params;

/// 商户服务 - 提现 【提现方式的列表】
- (void)navigaveToPayNowMerchantServicesWithdrawListVC:(NSDictionary *)params;

/// 商户服务 - 提现金额输入页面
- (void)navigaveToPayNowMerchantServicesWithdrawInputAmountVC:(NSDictionary *)params;

/// 商户服务 - 提现到银行
- (void)navigaveToPayNowMerchantServicesWithdrawToBankVC:(NSDictionary *)params;

/// 商户服务 - 添加银行卡
- (void)navigaveToPayNowMerchantServicesAddWithdrawBankCardVC:(NSDictionary *)params;

/// 商户服务 - 凭证列表
- (void)navigaveToPayNowMerchantServicesVoucherListVC:(NSDictionary *)params;

/// 商户服务 - 上传凭证
- (void)navigaveToPayNowMerchantServicesUploadVoucherVC:(NSDictionary *)params;

/// 商户服务 - 凭证详情
- (void)navigaveToPayNowMerchantServicesVoucherDetailVC:(NSDictionary *)params;

/// 商户服务 - 操作员密码【中间页】
- (void)navigaveToPayNowMerchantServicesContactAdminVC:(NSDictionary *)params;

/// 国际转账 - 渠道
- (void)navigaveToInternationalTransferChannelVC:(NSDictionary *)params;

/// 公寓缴费
- (void)navigaveToPayNowApartmentHomeVC:(NSDictionary *)params;

/// 公寓缴费 确认页
- (void)navigaveToPayNowApartmentComfirmVC:(NSDictionary *)params;

/// 公寓缴费记录列表
- (void)navigaveToPayNowApartmentRecordListVC:(NSDictionary *)params;

/// 公寓账单详情
- (void)navigaveToPayNowApartmentRecordDetailVC:(NSDictionary *)params;

/// 公寓缴费 - 拒绝
- (void)navigaveToPayNowApartmentRejectVC:(NSDictionary *)params;

/// 公寓缴费 - 结果页【拒绝 和 上传凭证】
- (void)navigaveToPayNowApartmentResultVC:(NSDictionary *)params;

/// 公寓缴费 - 上传凭证
- (void)navigaveToPayNowApartmentUploadVoucherVC:(NSDictionary *)params;

/// 公寓缴费 - 订单页面[中转页面]
- (void)navigaveToPayNowApartmentOrderListVC:(NSDictionary *)params;

/// 游戏缴费
- (void)navigaveToGamePaymentVC:(NSDictionary *)params;

/// 红包首页
- (void)navigaveToLuckPacketHomeVC:(NSDictionary *)params;

/// 红包消息记录
- (void)navigaveToLuckPacketRecordsVC:(NSDictionary *)params;

/// 发红包 页面
- (void)navigaveToHandOutPacketVC:(NSDictionary *)params;

/// 红包消息 页面
- (void)navigaveToLuckPacketMessageVC:(NSDictionary *)params;

/// 开红包
- (void)navigaveToOpenPacketVC:(NSDictionary *)params;

/// 红包领取详情
- (void)navigaveToPacketDetailVC:(NSDictionary *)params;

/// 担保交易首页
- (void)navigaveToPayNowGuaranteeHomeVC:(NSDictionary *)params;

/// 发起担保交易 - 中间页
- (void)navigaveToPayNowGuaranteeInitSelectVC:(NSDictionary *)params;

/// 卖方发起交易
- (void)navigaveToPayNowGuaranteeSalerInitVC:(NSDictionary *)params;

/// 买方发起交易
- (void)navigaveToPayNowGuaranteeBuyerInitVC:(NSDictionary *)params;

/// 担保交易详情
- (void)navigaveToPayNowGuaranteenRecordDetailVC:(NSDictionary *)params;

/// 账单支付交易列表
- (void)navigaveToBillPaymentListVC:(NSDictionary *)params;

/// 钱包明细列表
- (void)navigaveToWalletOrderListVC:(NSDictionary *)params;

/// 钱包明细详情
- (void)navigaveToWalletOrderDetailVC:(NSDictionary *)params;

/// 确认支付 - 新的
- (void)navigaveToWalletPaymentComfirmVC:(NSDictionary *)params;

/// 商户服务 - 商户信息
- (void)navigaveToMerchantServicesMerchantInfoVC:(NSDictionary *)params;

/// 信贷
- (void)navigaveToPayNowCreditVC:(NSDictionary *)params;

/// 绑定推广专员
- (void)navigaveToPayNowBindMarketingInfoVC:(NSDictionary *)params;

/// 推广专员统计页面
- (void)navigaveToPayNowMarketingHomeInfoVC:(NSDictionary *)params;

/// 推广绑定详情
- (void)navigaveToPayNowBindMarketingListInfoVC:(NSDictionary *)params;

- (void)navigaveToForgotPinCodeSendSMSViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
