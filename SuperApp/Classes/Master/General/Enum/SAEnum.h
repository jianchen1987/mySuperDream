//
//  SAEnum.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 第三方绑定渠道
typedef NSString *SAThirdPartyBindChannel NS_STRING_ENUM;

FOUNDATION_EXPORT SAThirdPartyBindChannel const SAThirdPartyBindChannelFacebook;
FOUNDATION_EXPORT SAThirdPartyBindChannel const SAThirdPartyBindChannelApple;
FOUNDATION_EXPORT SAThirdPartyBindChannel const SAThirdPartyBindChannelWechat;

/// 币种
typedef NSString *SACurrencyType NS_STRING_ENUM;

FOUNDATION_EXPORT SACurrencyType const SACurrencyTypeUSD;
FOUNDATION_EXPORT SACurrencyType const SACurrencyTypeKHR;
FOUNDATION_EXPORT SACurrencyType const SACurrencyTypeCNY;
FOUNDATION_EXPORT SACurrencyType const SACurrencyTypeUSDAndKHR;

/// 加这个是为了解决与后台的验签问题
typedef NSString *SABoolValue NS_STRING_ENUM;

FOUNDATION_EXPORT SABoolValue const SABoolValueTrue;
FOUNDATION_EXPORT SABoolValue const SABoolValueFalse;

/// 性别
typedef NSString *SAGender NS_STRING_ENUM;

FOUNDATION_EXPORT SAGender const SAGenderMale;
FOUNDATION_EXPORT SAGender const SAGenderFemale;

/// 站内信是否已度
typedef NS_ENUM(NSUInteger, SAStationLetterReadStatus) {
    SAStationLetterReadStatusUnknown = 0,
    SAStationLetterReadStatusUnread = 10, ///< 未读
    SAStationLetterReadStatusRead = 11    ///< 已读
};

/// 站内信类别
typedef NSString *SAStationLetterType NS_STRING_ENUM;

FOUNDATION_EXPORT SAStationLetterType const SAStationLetterTypeCoupon; ///< 优惠
FOUNDATION_EXPORT SAStationLetterType const SAStationLetterTypeOrder;  ///< 订单
FOUNDATION_EXPORT SAStationLetterType const SAStationLetterTypeSystem; ///< 系统

/// 支付类型
typedef NS_ENUM(NSUInteger, SAOrderPaymentType) {
    SAOrderPaymentTypeUnknown = 0,
    SAOrderPaymentTypeCashOnDelivery = 10, ///< 货到付款
    SAOrderPaymentTypeOnline = 11,         ///< 在线付款
    SAOrderPaymentTypeTransfer = 12,       ///< 线下转账
    SAOrderPaymentTypeQRCode = 15,         ///< 扫码支付

    SAOrderPaymentTypeCashOnDeliveryForbidden = 990,          ///< 禁止货到付款
    SAOrderPaymentTypeCashOnDeliveryForbiddenByToStore = 991, ///< 禁止到店自取货到付款
};

/// 订单列表页业务状态
typedef NS_ENUM(NSUInteger, SAOrderListBusinessStatus) {
    SAOrderListBusinessStatusUnknown,
    SAOrderListBusinessStatusWaitingInitialized = 99,    ///< 初始化
    SAOrderListBusinessStatusWaitingOrderReceiving = 10, ///< 等待商家接单
    SAOrderListBusinessStatusMerchantAcceptedOrder = 11, ///< 商家已接单
    SAOrderListBusinessStatusOrderDelivering = 12,       ///< 配送中
    SAOrderListBusinessStatusOrderDeliveryArrived = 13,  ///< 已送达
    SAOrderListBusinessStatusOrderCompleted = 14,        ///< 已完成
    SAOrderListBusinessStatusCancelling = 15,            ///< 取消申请中
    SAOrderListBusinessStatusCancelled = 16              ///< 已取消
};
/// 订单列表配送状态
typedef NS_ENUM(NSUInteger, SADeliveryStatus) {
    SADeliveryStatusUnknown = 0,
    SADeliveryStatusWaitingDeploy = 10,   ///< 未派单
    SADeliveryStatusWaitingAccept = 20,   ///< 待接单
    SADeliveryStatusAccepted = 30,        ///< 已接单
    SADeliveryStatusArrivedMerchant = 40, ///< 已到店
    SADeliveryStatusDelivering = 50,      ///< 配送中
    SADeliveryStatusDelivered = 60,       ///< 已送达
    SADeliveryStatusCancelled = 70        ///< 已取消
};

/// 订单列表页退款状态
typedef NS_ENUM(NSUInteger, SAOrderListAfterSaleState) {
    SAOrderListAfterSaleStateUnknown = 0,
    SAOrderListAfterSaleStateInitialized = 99,      ///< 初始化
    SAOrderListAfterSaleStateWaitingRefund = 10,    ///< 待退款
    SAOrderListAfterSaleStateRefunded = 11,         ///< 已退款
    SAOrderListAfterSaleStateMerchantRejected = 12, ///< 商家拒绝退款
    SAOrderListAfterSaleStateRefundCancelled = 13   ///< 退款已取消
};

/// 评价状态，订单列表用的
typedef NS_ENUM(NSUInteger, SAOrderEvaluationStatus) {
    SAOrderEvaluationStatusUnknown = 0,
    SAOrderEvaluationStatusIntialized = 99,        ///< 初始状态
    SAOrderEvaluationStatusWaitingEvaluation = 10, ///< 待评论
    SAOrderEvaluationStatusCommented = 11,         ///< 已评论
};

/// 配送类型
typedef NS_ENUM(NSUInteger, SADeliveryType) {
    SADeliveryTypeUnknown = 0,
    SADeliveryTypeMerchant = 10, ///< 商家配送
    SADeliveryTypePlatform = 11  ///< 平台配送
};

/// 用来查询订单状态的枚举
typedef NS_ENUM(NSUInteger, SAOrderState) {
    SAOrderStateUnknown = 0,
    SAOrderStateAll = 10,              ///< 所有
    SAOrderStateProcessing = 11,       ///< 查询处理中状态订单
    SAOrderStateWatingEvaluation = 12, ///< 查询未评价状态订单
    SAOrderStateWatingRefund = 13,     ///< 查询退款中订单
    SAOrderStateWatingPay = 14         ///< 查询待付款订单
};

typedef NS_ENUM(NSUInteger, SAWindowLocation) {
    SAWindowLocationAll = 0,                 ///< 全部位置
    SAWindowLocationWowNowKingKong = 1,      ///< 超 A 首页金刚区
    SAWindowLocationWowNowBanner = 2,        ///< 超 A 首页banner
    SAWindowLocationWowNowTool = 3,          ///< 超 A 首页tool
    SAWindowLocationWowNowWsNew = 4,         ///< 超 A 首页what's new？
    SAWindowLocationYumNowFocusBanner = 10,  ///< 外卖焦点轮播
    SAWindowLocationYumNowPromotion1 = 11,   ///< 外卖美味精选
    SAWindowLocationYumNowPromotion2 = 12,   ///< 外卖美味推荐
    SAWindowLocationYumNowMiddleBanner = 13, ///< 中屏广告
    SAWindowLocationYumNowStoreInsert = 14,  ///< 外卖门店推荐穿插
    SAWindowLocationWowNowFocusBanner = 15,  ///< 超 A 焦点轮播
    SAWindowLocationWowNowPromotion = 16,    ///< 超 A 活动区
    SAWindowLocationTinhNowFocusBanner = 17, ///< 电商焦点轮播
    SAWindowLocationTinhNowPromotion = 18,   ///< 电商促销活动
    SAWindowLocationWOWNOWAlertWindow = 31,
    SAWindowLocationYumNowAlertWindow = 32,
    SAWindowLocationTinhNowAlertWindow = 33, ///< 电商弹窗
    SAWindowLocationWowNowStartUpAd = 40     ///< App 启动广告
};

typedef NS_ENUM(NSUInteger, SAPagePosition) {
    SAPagePositionWowNowHomePage = 10,    ///< 超A首页
    SAPagePositionYumNowHomePage = 11,    ///< 外卖首页
    SAPagePositionTinNowHomePage = 12,    ///< 电商首页
    SAPagePositionNewWowNowHomePage = 13, ///< 新超A首页
    SAPagePositionGroupBuyHomePage = 15,  ///< 团购首页
};
/** 中台支付单状态 */
typedef NS_ENUM(NSUInteger, SAPaymentState) {
    SAPaymentStateUnknown = 0,    ///< 未知
    SAPaymentStateInit = 10,      ///< 初始化
    SAPaymentStatePaying = 11,    ///< 支付中
    SAPaymentStatePayed = 12,     ///< 支付完成
    SAPaymentStatePayFail = 13,   ///< 支付失败
    SAPaymentStateRefunding = 14, ///< 退款中
    SAPaymentStateRefunded = 15,  ///< 退款完成
    SAPaymentStateClosed = 16     ///< 关闭
};

/** 中台退款单状态 */
typedef NS_ENUM(NSUInteger, SARefundState) {
    SARefundStateWait = 9,            ///< 待退款
    SARefundStateRefunding = 10,      ///< 退款中
    SARefundStateRefunded = 11,       ///< 已退款
    SARefundStateMerchantReject = 12, ///< 商家拒绝退款
    SARefundStateCancel = 13,         ///< 已取消
    SARefundStateInit = 99,           ///< 初始化
    SARefundStateRevoke = 15,         ///< 异常已撤销
    SARefundStateClose = 17,          ///< 退款已关闭
    SARefundStateExpired = 18         ///< 超过有效期
};

/** 共通退款单状态 */
typedef NS_ENUM(NSUInteger, SARefundOperationType) {
    SARefundOperationTypeClose = 10,                 ///< 退款关闭
    SARefundOperationTypeFinish = 11,                ///<退款完成
    SARefundOperationTypeChangeToOfflineRefund = 12, ///<改为线下退款
    SARefundOperationTypeFail = 13,                  ///< 退款失败
    SARefundOperationTypeAgain = 14,                 ///<重新发起
    SARefundOperationTypeCreate = 15,                ///< 创建退款 即 申请退款
    SARefundOperationTypeInitiate = 16               ///< 发起退款 即 受理退款
};

/** 中台退款来源 */
typedef NS_ENUM(NSUInteger, SARefundSource) {
    SARefundSourceNormal = 10,  ///< 业务正常退款
    SARefundSourceRepeat = 11,  ///< 重复支付退款
    SARefundSourceTimeout = 12, ///< 超时支付退款
    SARefundSourceChannel = 13  ///< 渠道单方退款
};

/** 登陆密码状态 */
typedef NS_ENUM(NSUInteger, SAUserLoginPwdState) {
    SAUserLoginPwdStateNotSet = 10, ///< 未设置
    SAUserLoginPwdStateSetted = 11  ///< 已设置
};

/// 业务线类型
typedef NSString *SAClientType NS_STRING_ENUM;
FOUNDATION_EXPORT SAClientType const SAClientTypeAll;          ///< 所有业务线
FOUNDATION_EXPORT SAClientType const SAClientTypeMaster;       ///< 超 A
FOUNDATION_EXPORT SAClientType const SAClientTypeYumNow;       ///< 外卖
FOUNDATION_EXPORT SAClientType const SAClientTypeTinhNow;      ///< 电商
FOUNDATION_EXPORT SAClientType const SAClientTypePhoneTopUp;   ///< 话费充值
FOUNDATION_EXPORT SAClientType const SAClientTypeViPay;        ///< 钱包充值
FOUNDATION_EXPORT SAClientType const SAClientTypeGame;         ///< 游戏
FOUNDATION_EXPORT SAClientType const SAClientTypeHotel;        ///< 酒店
FOUNDATION_EXPORT SAClientType const SAClientTypeGroupBuy;     ///< 团购
FOUNDATION_EXPORT SAClientType const SAClientTypeOTA;          ///< OTA
FOUNDATION_EXPORT SAClientType const SAClientTypeBillPayment;  ///< 账单缴费
FOUNDATION_EXPORT SAClientType const SAClientTypeMemberCentre; ///< 会员
FOUNDATION_EXPORT SAClientType const SAClientTypeTravel;       ///< 旅游

/// 业务线类型（购物车用）
typedef NSString *SABusinessType NS_STRING_ENUM;
FOUNDATION_EXPORT SABusinessType const SABusinessTypeYumNow;  ///< 外卖
FOUNDATION_EXPORT SABusinessType const SABusinessTypeTonhNow; ///< 电商

/// 业务线类型（营销用）
typedef NSString *SAMarketingBusinessType NS_STRING_ENUM;
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeYumNow;      ///< 外卖
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeTinhNow;     ///< 电商
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeTopUp;       ///< 话费充值
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeGame;        ///< 游戏
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeHotel;       ///< 酒店
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeGroupBuy;    ///< 团购
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeBillPayment; ///< 账单支付
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeAirTicket;   ///< 机票
FOUNDATION_EXPORT SAMarketingBusinessType const SAMarketingBusinessTypeTravel;      ///< 旅游

/// 订单列表可操作事件
typedef NSString *SAOrderListOperationEventName NS_STRING_ENUM;

FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNamePay;              ///< 支付
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameEvaluation;       ///< 评价
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameConfirmReceiving; ///< 确认收货
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameRefundDetail;     ///< 退款详清
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameReBuy;            ///< 再次购买
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameTransfer;         ///< 转账付款
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameNearbyBuy;        ///< 附近购买
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNameCancel;           ///< 取消订单
FOUNDATION_EXPORT SAOrderListOperationEventName const SAOrderListOperationEventNamePickUp;           ///< 确认取餐

typedef NSString *SASendSMSType NS_TYPED_ENUM;

FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeRegister;
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeLogin;
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeResetPassword;            ///< 重置登录密码
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeActiveOperator;           ///< 废弃
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeThirdPartyActiveOperator; ///< 三方登陆注册绑定
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeThirdRegister;
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeThirdResetPassword;
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeValidateConsigneeMobile; ///< 验证收货人手机号
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeVoice;                   ///< 语音验证码
FOUNDATION_EXPORT SASendSMSType const SASendSMSTypeUpdateUserMobile;        ///< 绑定手机号

typedef NSString *SAStartupAdType NS_TYPED_ENUM;

FOUNDATION_EXPORT SAStartupAdType const SAStartupAdTypeImage; ///< 图片
FOUNDATION_EXPORT SAStartupAdType const SAStartupAdTypeVideo; ///< 视频

typedef NSString *SAPushChannel NS_TYPED_ENUM;

FOUNDATION_EXPORT SAPushChannel const SAPushChannelAPNS;  ///< apns
FOUNDATION_EXPORT SAPushChannel const SAPushChannelVOIP;  ///< voip
FOUNDATION_EXPORT SAPushChannel const SAPushChannelHello; ///< 传声筒
/// 版本更新类型
typedef NSString *SAVersionUpdateModel NS_TYPED_ENUM;

FOUNDATION_EXPORT SAVersionUpdateModel const SAVersionUpdateModelCommon; ///< 普通更新
FOUNDATION_EXPORT SAVersionUpdateModel const SAVersionUpdateModelCoerce; ///< 强制更新
FOUNDATION_EXPORT SAVersionUpdateModel const SAVersionUpdateModelBeta;   ///< 内测更新

/// 优惠券类型
typedef NS_ENUM(NSUInteger, SACouponTicketType) {
    SACouponTicketTypeDefault = 0,    ///< 默认
    SACouponTicketTypeDiscount = 13,  ///< 折扣券
    SACouponTicketTypeMinus = 14,     ///< 满减券
    SACouponTicketTypeReduction = 15, ///< 现金券
    SACouponTicketTypeFreight = 34,   ///< 运费券
    SACouponTicketTypePayment = 37    ///< 支付券
};
/// 优惠券核销场景
typedef NS_ENUM(NSUInteger, SACouponTicketBusinessLine) {
    SACouponTicketBusinessLineYumNow = 13, ///< 外卖
    SACouponTicketBusinessLineTinhNow = 14 ///< 电商
};

typedef NS_ENUM(NSUInteger, SACouponTicketDiscountType) {
    SACouponTicketDiscountTypeFixedAmount = 10,        ///< 固定金额
    SACouponTicketDiscountTypeDiscountPercentage = 11, ///<  折扣比例
};

typedef NS_ENUM(NSUInteger, SAMessageType) {
    SAMessageTypeSystem = 10, ///< 系统消息
    SAMessageTypeNotice = 20, ///< 服务通知
    SAMessageTypeCoupon = 30, ///< 营销消息
    SAMessageTypeGroup = 40   ///< 团购消息

};

typedef NS_ENUM(NSUInteger, SAAddressZoneLevel) {
    SAAddressZoneLevelCountry = 10,  ///< 国
    SAAddressZoneLevelProvince = 11, ///< 省/市
    SAAddressZoneLevelDistrict = 12, ///< 区
    SAAddressZoneLevelCommune = 13,  ///< 公社
};

/// 地图选择地址页面Geocode解析频次
typedef NS_ENUM(NSUInteger, SAChooseAddressMapGeocodeType) {
    SAChooseAddressMapGeocodeTypeDefault = 0, ///< 默认，每次拖动都进行解析
    SAChooseAddressMapGeocodeTypeOnce,        ///< 只在点击确定后进行解析
};

///站内信类型，废弃
typedef NSString *SAAppInnerNotificationType NS_STRING_ENUM;
FOUNDATION_EXPORT SAAppInnerNotificationType const SAAppInnerNotificationTypeSystem;    ///<  系统消息
FOUNDATION_EXPORT SAAppInnerNotificationType const SAAppInnerNotificationTypeService;   ///< 服务通知
FOUNDATION_EXPORT SAAppInnerNotificationType const SAAppInnerNotificationTypeMarketing; ///< 营销通知

/// 站内信类型2
typedef NSString *SAAppInnerMessageType NS_STRING_ENUM;
FOUNDATION_EXPORT SAAppInnerMessageType const SAAppInnerMessageTypeAll;       ///<  所有
FOUNDATION_EXPORT SAAppInnerMessageType const SAAppInnerMessageTypeChat;      ///< 聊天
FOUNDATION_EXPORT SAAppInnerMessageType const SAAppInnerMessageTypeMarketing; ///< 营销消息
FOUNDATION_EXPORT SAAppInnerMessageType const SAAppInnerMessageTypePersonal;  ///< 个人消息

typedef NS_ENUM(NSUInteger, SAAppInnerMessageContentType) { SAAppInnerMessageContentTypeNormal = 10, SAAppInnerMessageContentTypeRichText = 11 };

/// 11-未使用 12-已锁定 13-已使用 14-已过期
typedef NS_ENUM(NSUInteger, SACouponState) { SACouponStateUnused = 11, SACouponStateUsed = 13, SACouponStateExpired = 14 };

/// 优惠券列表排序状态
typedef NS_ENUM(NSUInteger, SACouponListSortType) { SACouponListSortTypeDefault = 0, SACouponListSortTypeNew = 1, SACouponListSortTypeNearlyExpired = 2 };

///优惠券列表新版顶部排序枚举
typedef NS_ENUM(NSUInteger, SACouponListNewSortType) {
    SACouponListNewSortTypeDefault = 10,       //默认
    SACouponListNewSortTypeNew = 11,           //新到
    SACouponListNewSortTypeNearlyExpired = 12, //快到期
    SACouponListNewSortTypeYumNow = 13,        //外卖
    SACouponListNewSortTypeTinhNow = 14,       //电商
    SACouponListNewSortTypePhoneTopUp = 15,    //话费充值
    SACouponListNewSortTypeGameChannel = 16,   //游戏
    SACouponListNewSortTypeHotelChannel = 17,  //酒店
    SACouponListNewSortTypeGroupBuy = 18,      //团购
    SACouponListNewSortTypeAirTicket = 22,     //机票
    SACouponListNewSortTypeTravel = 24,        //旅游
};

///优惠券类型
typedef NS_ENUM(NSUInteger, SACouponListCouponType) {
    SACouponListCouponTypeAll = 9,            //全部
    SACouponListCouponTypeCashCoupon = 15,    //现金券
    SACouponListCouponTypeExpressCoupon = 34, //运费券
    SACouponListCouponTypePaymentCoupon = 37, //支付券
};

///优惠券类别
typedef NS_ENUM(NSUInteger, SACouponListSceneType) {
    SACouponListSceneTypeTypeAll = 9,      //全部
    SACouponListSceneTypeAPPCoupon = 15,   //平台券
    SACouponListSceneTypeStoreCoupon = 34, //门店券
};

///优惠券排序
typedef NS_ENUM(NSUInteger, SACouponListOrderByType) {
    SACouponListOrderByTypeDefault = 10,            //默认
    SACouponListOrderByTypeNewArrival = 11,         //新到
    SACouponListOrderByTypeExpireSoon = 12,         //快过期
    SACouponListOrderByTypeAmountLargeToSmall = 13, //面额由大到小
    SACouponListOrderByTypeAmountSmallToLarge = 14, //面额由小到大
};

/// 优惠券状态
typedef NSString *SACouponTicketState NS_STRING_ENUM;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateNotWorked;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateUnused;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateLocked;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateUsed;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateExpired;
FOUNDATION_EXPORT SACouponTicketState const SACouponTicketStateOrderRefunded;

/** 聚合订单状态 */
typedef NS_ENUM(NSUInteger, SAAggregateOrderState) {
    SAAggregateOrderStateInit = 99,     ///< 初始化
    SAAggregateOrderStateComplete = 11, ///< 已完成
    SAAggregateOrderStatePaying = 13,   ///< 待支付
    SAAggregateOrderStatePayed = 14     ///< 已支付
};
/** 聚合订单终态 */
typedef NS_ENUM(NSUInteger, SAAggregateOrderFinalState) {
    SAAggregateOrderFinalStateComplete = 11, ///< 已完成
    SAAggregateOrderFinalStateCancel = 12,   ///< 已取消
    SAAggregateOrderFinalStateClosed = 13    ///< 已关闭
};

/**注销账号原因，枚举 */
typedef NSString *SACancellationReasonType NS_STRING_ENUM;
FOUNDATION_EXPORT SACancellationReasonType const SACancellationReasonTypeUnbindMobile;     ///<  需要解绑手机
FOUNDATION_EXPORT SACancellationReasonType const SACancellationReasonTypeSecurityConcerns; ///< 安全/隐私顾虑
FOUNDATION_EXPORT SACancellationReasonType const SACancellationReasonTypeRedundantAccount; ///< 这是多余的账户
FOUNDATION_EXPORT SACancellationReasonType const SACancellationReasonTypeUseDifficulty;    ///< WOWNOW使用遇到困难
FOUNDATION_EXPORT SACancellationReasonType const SACancellationReasonTypeOtherReason;      ///< 其他原因

/** 聊天场景 */
typedef NSString *SAChatSceneType NS_STRING_ENUM;
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeYumNowDelivery; ///< 外卖配送场景
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeYumNowArbitral; ///< 外卖群聊
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeGamePlay;       ///< 游戏陪玩
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeTinhNowConsult; ///<  电商咨询
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeYumNowConsult;  ///<  外卖咨询
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeGameConsult;    ///<  游戏咨询
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeHotelConsult;   ///<  酒店咨询
FOUNDATION_EXPORT SAChatSceneType const SAChatSceneTypeCustomer;       ///<  客服


NS_ASSUME_NONNULL_END
