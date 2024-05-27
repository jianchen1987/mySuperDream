//
//  HDMediator+SuperApp.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDKitCore/HDKitCore.h>


@interface HDMediator (SuperApp)

/// 用 webView 打开页面，如果传了完整url 则会使用 url，如果传了 path，会拼接当前环境的 h5 地址
/// @param params @{@"url": @"https://xxx"} 或者 @{@"path": @"user/agreement/detail?id=01"}
- (void)navigaveToWebViewViewController:(NSDictionary *)params;


/// 导航到设置页面
/// @param params 参数
- (void)navigaveToSettingsViewController:(NSDictionary *)params;

/// 导航到我的帐号信息页面
/// @param params 参数
- (void)navigaveToMyInfomationController:(NSDictionary *)params;
/// 导航到设置昵称页面
/// @param params 参数
- (void)navigaveToSetNickNameController:(NSDictionary *)params;

/// 导航到设置邮箱页面
/// @param params 参数
- (void)navigaveToEmailController:(NSDictionary *)params;
/// 导航到绑定邮箱页面
/// @param params 参数
- (void)navigaveToBindEmailController:(NSDictionary *)params;
/// 导航到设置手机页面
/// @param params 参数
- (void)navigaveToSetPhoneController:(NSDictionary *)params;

/// 导航到意见反馈页面
/// @param params 参数
- (void)navigaveToSuggestionViewController:(NSDictionary *)params;

/// 导航到子频道外卖
/// @param params 参数
- (void)navigaveToYumNowController:(NSDictionary *)params;

/// 导航到子频道电商
/// @param params 参数
- (void)navigaveToTinhNowController:(NSDictionary *)params;

/// 导航到充值详情
/// @param params 参数
- (void)navigaveToTopUpDetailViewController:(NSDictionary *)params;

/// 跳转到话费退款详情页面
/// @param params 参数
- (void)navigaveToTopUpRefundDetailViewController:(NSDictionary *)params;

/// 跳转到公共退款详情页面
/// @param params 参数
- (void)navigaveToCommonRefundDetailViewController:(NSDictionary *)params;

/// 跳转到退款去向页面
/// @param params 参数
- (void)navigaveToRefundDestinationViewController:(NSDictionary *)params;

/// 导航到我的优惠券页面
/// @param params 参数
- (void)navigaveToMyCouponsViewController:(NSDictionary *)params;

/// 导航到登录页
/// @param params 参数
- (void)navigaveToLoginViewController:(NSDictionary *)params;

/// 导航到钱包页
/// @param params 参数
- (void)navigaveToWalletViewController:(NSDictionary *)params;

/// 弹起设置支付密码界面
/// @param params 参数
- (void)navigaveToSettingPayPwdViewController:(NSDictionary *)params;

/// 钱包充值
/// @param params 参数
- (void)navigaveToWalletChargeViewController:(NSDictionary *)params;

/// 钱包账单列表
/// @param params 参数
- (void)navigaveToWalletBillListViewController:(NSDictionary *)params;

/// 钱包账单详情
/// @param params 参数
- (void)navigaveToWalletBillDetailViewController:(NSDictionary *)params;

/// 选择我的地址
/// @param params 参数
- (void)navigaveToChooseMyAddressViewController:(NSDictionary *)params;

/// 密码设置选项页面
/// @param params 参数
- (void)navigaveToSettingPwdOptionViewController:(NSDictionary *)params;

/// 钱包充值结果页
/// @param params 参数
- (void)navigaveToWalletChargeResultViewController:(NSDictionary *)params;

/// 钱包修改密码询问页
/// @param params 参数
- (void)navigaveToWalletChangePayPwdAskingViewController:(NSDictionary *)params;

/// 钱包修改密码输入验证码页
/// @param params 参数
- (void)navigaveToWalletChangePayPwdInputSMSCodeViewController:(NSDictionary *)params;


/// 收银台webView
/// @param params 参数
- (void)navigaveToCheckstandWebViewController:(NSDictionary *)params;

/// 导航到支付结果页
/// @param params {orderNo:聚合订单号,businessLine:业务线枚举}
- (void)navigaveToCheckStandPayResultViewController:(NSDictionary *)params;

/// 导航到门店收藏页
/// @param params 参数
- (void)navigaveToStoreFavoriteViewController:(NSDictionary *)params;

- (void)navigaveToSystemMessageViewController:(NSDictionary *)params;

/// 打开IM 聊天页
- (void)navigaveToIMViewController:(NSDictionary *)params;

/// 导航到自动领券列表页
/// @param params {list:优惠券列表数据,clientType:业务线类型}
- (void)navigaveToCouponRedemptionViewController:(NSDictionary *)params;

/// 导航到市区选择页面
- (void)navigaveToChooseZoneViewController:(NSDictionary *)params;

/// 导航到扫一扫
/// @param params 参数
- (void)navigaveToScanViewController:(NSDictionary *)params;

/// 导航到地图选择地址页面
/// @param params 参数
- (void)navigaveToChooseAddressInMapViewController:(NSDictionary *)params;

/// 打开单聊页面
/// @param params 参数
- (void)navigaveToChatViewController:(NSDictionary *)params;

/// 打开通话搜索用户页面
/// @param params 参数
- (void)navigaveToCallAccountViewController:(NSDictionary *)params;

/// 打开语音通话页面
/// @param params 参数
- (void)navigaveToAudioCallViewController:(NSDictionary *)params;

/// 打开视频通话页面
/// @param params 参数
- (void)navigaveToVideoCallViewController:(NSDictionary *)params;

/// 导航到收货地址页面
/// @param params 参数
- (void)navigaveToShoppingAddressViewController:(NSDictionary *)params;
/// 导航到消息页面
/// @param params 参数
- (void)navigaveToMessagesViewController:(NSDictionary *)params;

- (void)navigaveToCommonOrderDetails:(NSDictionary *)params;

- (void)navigaveToBillPaymentDetails:(NSDictionary *)params;
- (void)navigaveToBillRefundDetails:(NSDictionary *)params;

/// 导航到等待支付结果页面
/// @param params 参数
- (void)navigaveToWaitPayResultViewController:(NSDictionary *)params;

/// 导航到账号注销申请页面
/// @param params 参数
- (void)navigaveToCancellationApplication:(NSDictionary *)params;

/// 导航到订单列表页面
/// @param params 参数
- (void)navigaveToOrderList:(NSDictionary *)params;

#pragma mark -
/// 展示切换语言视图
- (void)showChangeLanguage;

/// 检查APP版本
- (void)checkAppVersion;
/// 导航到新版密码登录页面
/// - Parameter params 参数
- (void)navigaveToLoginBySMSViewController:(NSDictionary *)params;
/// 导航到最新版验证码登录页面
/// - Parameter params 参数
- (void)navigaveToLoginWithSMSViewController:(NSDictionary *)params;

/// 导航到新版获取验证码页面
/// - Parameter params 参数
- (void)navigaveToLoginByVerificationCodeViewController:(NSDictionary *)params;
/// 导航到最新版获取验证码页面
/// - Parameter params 参数
- (void)navigaveToVerificationCodeViewController:(NSDictionary *)params;


/// 导航到新版忘记密码页面
/// - Parameter params 参数
- (void)navigaveToForgotPasswordViewController:(NSDictionary *)params;
/// 导航到新版忘记密码或者绑定手机页面
/// - Parameter params 参数
- (void)navigaveToForgetPasswordOrBindPhoneViewController:(NSDictionary *)params;

/// 导航到新版设置密码页面
/// - Parameter params 参数
- (void)navigaveToSetPasswordViewController:(NSDictionary *)params;
/// 导航到新版修改登录密码页面
/// - Parameter params 参数
- (void)navigaveToChangeLoginPasswordViewController:(NSDictionary *)params;
/// 导航到意见详情页面
/// - Parameter params 参数
- (void)navigaveToSuggestionDetailViewController:(NSDictionary *)params;
/// 导航到订单搜索页面
/// - Parameter params 参数
- (void)navigaveToOrderSearch:(NSDictionary *)params;
/// 跳转到一个群聊
/* - Parameter params: {
   "groupID" : @"123"   /// 群ID
}
 */
- (void)navigaveToGroupChat:(NSDictionary *)params;
/// 导航到im反馈页面
/// - Parameter params 参数
- (void)navigaveToImFeedBackViewController:(NSDictionary *)params;
/// ocr扫码
/// - Parameter params: 参数
- (void)navigaveToOcrScanViewController:(NSDictionary *)params;

/// im聊天列表
/// - Parameter params: 参数
- (void)navigaveToChatListViewController:(NSDictionary *)params;


@end
