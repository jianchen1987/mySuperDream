//
//  SAEnum.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnum.h"

SAThirdPartyBindChannel const SAThirdPartyBindChannelFacebook = @"FACEBOOK";
SAThirdPartyBindChannel const SAThirdPartyBindChannelApple = @"APPLE_ID";
SAThirdPartyBindChannel const SAThirdPartyBindChannelWechat = @"APP_WECHAT";

SACurrencyType const SACurrencyTypeUSD = @"USD";
SACurrencyType const SACurrencyTypeKHR = @"KHR";
SACurrencyType const SACurrencyTypeCNY = @"CNY";
SACurrencyType const SACurrencyTypeUSDAndKHR = @"USD+KHR";

SABoolValue const SABoolValueTrue = @"true";
SABoolValue const SABoolValueFalse = @"false";

SAGender const SAGenderMale = @"M";
SAGender const SAGenderFemale = @"F";

SAStationLetterType const SAStationLetterTypeCoupon = @"Coupon";         ///< 优惠
SAStationLetterType const SAStationLetterTypeOrder = @"Order";           ///< 订单
SAStationLetterType const SAStationLetterTypeSystem = @"System Message"; ///< 系统

SAClientType const SAClientTypeAll = @"ALL";               ///< 所有业务线
SAClientType const SAClientTypeMaster = @"SuperApp";       ///< 超 A
SAClientType const SAClientTypeYumNow = @"YumNow";         ///< 订外卖
SAClientType const SAClientTypeTinhNow = @"TinhNow";       ///< 电商
SAClientType const SAClientTypePhoneTopUp = @"PhoneTopUp"; ///< 话费充值
SAClientType const SAClientTypeViPay = @"ViPay";           ///< 钱包充值
SAClientType const SAClientTypeGame = @"GameChannel";
SAClientType const SAClientTypeHotel = @"HotelChannel";
SAClientType const SAClientTypeGroupBuy = @"GroupBuy"; ///< 团购
SAClientType const SAClientTypeOTA = @"OTA";
SAClientType const SAClientTypeBillPayment = @"BillPayment";   ///< 账单缴费
SAClientType const SAClientTypeMemberCentre = @"MemberCentre"; ///< 会员
SAClientType const SAClientTypeTravel = @"Travel";             ///< 旅游

SABusinessType const SABusinessTypeYumNow = @"10";  ///< 订外卖
SABusinessType const SABusinessTypeTonhNow = @"11"; ///< 电商

SAMarketingBusinessType const SAMarketingBusinessTypeYumNow = @"13";      ///< 外卖
SAMarketingBusinessType const SAMarketingBusinessTypeTinhNow = @"14";     ///< 电商
SAMarketingBusinessType const SAMarketingBusinessTypeTopUp = @"15";       ///< 话费充值
SAMarketingBusinessType const SAMarketingBusinessTypeGame = @"16";        ///< 游戏
SAMarketingBusinessType const SAMarketingBusinessTypeHotel = @"17";       ///< 酒店
SAMarketingBusinessType const SAMarketingBusinessTypeGroupBuy = @"18";    ///< 团购
SAMarketingBusinessType const SAMarketingBusinessTypeBillPayment = @"20"; ///< 账单支付
SAMarketingBusinessType const SAMarketingBusinessTypeAirTicket = @"22";   ///< 机票
SAMarketingBusinessType const SAMarketingBusinessTypeTravel = @"24";      ///< 旅游

SAOrderListOperationEventName const SAOrderListOperationEventNamePay = @"PAY_NOW";                      ///< 支付
SAOrderListOperationEventName const SAOrderListOperationEventNameEvaluation = @"ADD_COMMENT";           ///< 评价
SAOrderListOperationEventName const SAOrderListOperationEventNameConfirmReceiving = @"CONFIRM_RECEIPT"; ///< 确认收货
SAOrderListOperationEventName const SAOrderListOperationEventNameRefundDetail = @"REFUND_DETAIL";       ///< 退款详清
SAOrderListOperationEventName const SAOrderListOperationEventNameReBuy = @"RE_BUY";                     ///< 再次购买
SAOrderListOperationEventName const SAOrderListOperationEventNameTransfer = @"TRANSFER_PAYMENTS";       ///< 转账付款
SAOrderListOperationEventName const SAOrderListOperationEventNameNearbyBuy = @"NEARBY_BUY";             ///< 附近购买
SAOrderListOperationEventName const SAOrderListOperationEventNameCancel = @"CANCEL_ORDER";              ///< 取消订单
SAOrderListOperationEventName const SAOrderListOperationEventNamePickUp = @"CONFIRM_PICKUP";            ///< 确定取餐

SASendSMSType const SASendSMSTypeRegister = @"SMS_REGISTER";                      ///< 注册
SASendSMSType const SASendSMSTypeLogin = @"SMS_LOGIN";                            ///< 短信登陆
SASendSMSType const SASendSMSTypeActiveOperator = @"ACTIVE";                      ///< 激活 (废弃)
SASendSMSType const SASendSMSTypeThirdPartyActiveOperator = @"THIRD_ACTIVE";      ///< 三方登陆激活
SASendSMSType const SASendSMSTypeResetPassword = @"RESET_PASSWORD";               ///< 重置登录密码
SASendSMSType const SASendSMSTypeThirdRegister = @"THIRD_REGISTER";               ///< 三方登陆绑定
SASendSMSType const SASendSMSTypeThirdResetPassword = @"THIRD_RESET_PASSWORD";    ///< 三方登陆重置密码
SASendSMSType const SASendSMSTypeValidateConsigneeMobile = @"ADDRESS_MOBILE_SMS"; ///< 验证收货人手机号
SASendSMSType const SASendSMSTypeVoice = @"SMS_VOICE";                            ///< 语音验证码
SASendSMSType const SASendSMSTypeUpdateUserMobile = @"UPDATE_USER_MOBILE";        ///< 绑定手机号

SAStartupAdType const SAStartupAdTypeImage = @"IMAGE"; ///< 图片
SAStartupAdType const SAStartupAdTypeVideo = @"MP4";   ///< 视频

SAPushChannel const SAPushChannelAPNS = @"APNs";     ///< apns
SAPushChannel const SAPushChannelVOIP = @"APNsVoip"; ///< voip
SAPushChannel const SAPushChannelHello = @"hello";   ///< hello

SAVersionUpdateModel const SAVersionUpdateModelCommon = @"common"; ///< 普通更新
SAVersionUpdateModel const SAVersionUpdateModelCoerce = @"coerce"; ///< 强制更新
SAVersionUpdateModel const SAVersionUpdateModelBeta = @"beta";     ///< 内测更新

SAAppInnerNotificationType const SAAppInnerNotificationTypeSystem = @"WOW_10"; ///< 系统通知
SAAppInnerNotificationType const SAAppInnerNotificationTypeService = @"WOW_20";
SAAppInnerNotificationType const SAAppInnerNotificationTypeMarketing = @"30";

SAAppInnerMessageType const SAAppInnerMessageTypeAll = @"0";        ///<  所有
SAAppInnerMessageType const SAAppInnerMessageTypeChat = @"1";       ///< 聊天
SAAppInnerMessageType const SAAppInnerMessageTypeMarketing = @"10"; ///< 营销消息
SAAppInnerMessageType const SAAppInnerMessageTypePersonal = @"11";  ///< 个人消息

// TODO: 确定状态机是否有问题
SACouponTicketState const SACouponTicketStateNotWorked = @"10";
SACouponTicketState const SACouponTicketStateUnused = @"11";
SACouponTicketState const SACouponTicketStateLocked = @"12";
SACouponTicketState const SACouponTicketStateUsed = @"13";
SACouponTicketState const SACouponTicketStateExpired = @"14";
SACouponTicketState const SACouponTicketStateOrderRefunded = @"15";

//注销账号原因，枚举
SACancellationReasonType const SACancellationReasonTypeUnbindMobile = @"unbind_mobile";         ///<  需要解绑手机
SACancellationReasonType const SACancellationReasonTypeSecurityConcerns = @"security_concerns"; ///< 安全/隐私顾虑
SACancellationReasonType const SACancellationReasonTypeRedundantAccount = @"redundant_account"; ///< 这是多余的账户
SACancellationReasonType const SACancellationReasonTypeUseDifficulty = @"use_difficulty";       ///< WOWNOW使用遇到困难
SACancellationReasonType const SACancellationReasonTypeOtherReason = @"other_reason";           ///< 其他原因


SAChatSceneType const SAChatSceneTypeYumNowDelivery = @"SCENE_YUMNOW_DELIVERY"; ///< 外卖配送场景
SAChatSceneType const SAChatSceneTypeYumNowArbitral = @"SCENE_YUMNOW_ARBITRAL"; ///< 外卖群聊
SAChatSceneType const SAChatSceneTypeGamePlay = @"SCENE_GAME_PLAY";             ///< 游戏陪玩
SAChatSceneType const SAChatSceneTypeTinhNowConsult = @"SCENE_TINHNOW_CONSULT"; ///<  电商咨询
SAChatSceneType const SAChatSceneTypeYumNowConsult = @"SCENE_YUMNOW_CONSULT";   ///<  外卖咨询
SAChatSceneType const SAChatSceneTypeGameConsult = @"SCENE_GAME_CONSULT";       ///<  游戏咨询
SAChatSceneType const SAChatSceneTypeHotelConsult = @"SCENE_HOTEL_CONSULT";     ///<  酒店咨询
SAChatSceneType const SAChatSceneTypeCustomer = @"SCENE_CUSTOMER";              ///<  客服
