//
//  SAOrderRelatedEnum.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
#import <Foundation/Foundation.h>

#ifndef SAOrderRelatedEnum
#define SAOrderRelatedEnum

/// 接收的订单状态
typedef NS_ENUM(NSUInteger, WMOrderStatus) {
    WMOrderStatusUnknown = 0,
    WMOrderStatusAll,             ///< 所有
    WMOrderStatusProcessing = 10, ///< 进行中
    WMOrderStatusCompleted = 11,  ///< 已完成
    WMOrderStatusCancelled = 12,  ///< 已取消
    WMOrderStatusInitialized = 99 ///< 初始化
};

/// 业务状态
typedef NS_ENUM(NSUInteger, WMBusinessStatus) {
    WMBusinessStatusUnknown,
    WMBusinessStatusWaitingInitialized = 99,    ///< 初始化
    WMBusinessStatusWaitingOrderReceiving = 10, ///< 等待商家接单
    WMBusinessStatusMerchantAcceptedOrder = 11, ///< 商家已接单
    WMBusinessStatusOrderCancelling = 12,       ///< 取消申请中
    WMBusinessStatusOrderCancelled = 13,        ///< 已取消
    WMBusinessStatusDelivering = 15,            ///< 配送中
    WMBusinessStatusDeliveryArrived = 16,       ///< 已送达
    WMBusinessStatusUserRefundApplying = 19,    ///< 退款申请中
    WMBusinessStatusCompleted = 20,             ///< 已完成
};

/// 订单列表页业务状态
typedef NS_ENUM(NSUInteger, WMOrderListBusinessStatus) {
    WMOrderListBusinessStatusUnknown,
    WMOrderListBusinessStatusWaitingInitialized = 99,    ///< 初始化
    WMOrderListBusinessStatusWaitingOrderReceiving = 10, ///< 等待商家接单
    WMOrderListBusinessStatusMerchantAcceptedOrder = 11, ///< 商家已接单
    WMOrderListBusinessStatusOrderDelivering = 12,       ///< 配送中
    WMOrderListBusinessStatusOrderDeliveryArrived = 13,  ///< 已送达
    WMOrderListBusinessStatusOrderCompleted = 14,        ///< 已完成
    WMOrderListBusinessStatusCancelling = 15,            ///< 取消申请中
    WMOrderListBusinessStatusCancelled = 16              ///< 已取消
};

/// 退款状态
typedef NS_ENUM(NSUInteger, WMOrderAfterSaleState) {
    WMOrderAfterSaleStateUnknown = 0,
    WMOrderAfterSaleStateInitialized = 99,     ///< 初始化
    WMOrderAfterSaleStateRefundApplying = 10,  ///< 退款申请中
    WMOrderAfterSaleStateRefunding = 11,       ///< 退款中
    WMOrderAfterSaleStateMerchantRefund = 12,  ///< 商户退款
    WMOrderAfterSaleStateRejected = 13,        ///< 已拒绝
    WMOrderAfterSaleStateRefundCancelled = 14, ///< 退款已取消
    WMOrderAfterSaleStateRefunded = 15         ///< 已退款
};

/// 订单列表页退款状态
typedef NS_ENUM(NSUInteger, WMOrderListAfterSaleState) {
    WMOrderListAfterSaleStateUnknown = 0,
    WMOrderListAfterSaleStateInitialized = 99,      ///< 初始化
    WMOrderListAfterSaleStateWaitingRefund = 10,    ///< 待退款
    WMOrderListAfterSaleStateRefunded = 11,         ///< 已退款
    WMOrderListAfterSaleStateMerchantRejected = 12, ///< 商家拒绝退款
    WMOrderListAfterSaleStateRefundCancelled = 13   ///< 退款已取消
};

/// 配送类型
typedef NS_ENUM(NSUInteger, WMDeliveryType) {
    WMDeliveryTypeUnknown = 0,
    WMDeliveryTypeMerchant = 10, ///< 商家配送
    WMDeliveryTypePlatform = 11  ///< 平台配送
};

/// 配送状态
typedef NS_ENUM(NSUInteger, WMDeliveryStatus) {
    WMDeliveryStatusUnknown = 0,
    WMDeliveryStatusWaitingDeploy = 10,   ///< 未派单
    WMDeliveryStatusWaitingAccept = 20,   ///< 待接单
    WMDeliveryStatusAccepted = 30,        ///< 已接单
    WMDeliveryStatusArrivedMerchant = 40, ///< 已到店
    WMDeliveryStatusDelivering = 50,      ///< 配送中
    WMDeliveryStatusDelivered = 60,       ///< 已送达
    WMDeliveryStatusCancelled = 70        ///< 已取消
};

/// 订单事件类型
typedef NS_ENUM(NSUInteger, WMOrderEventType) {
    WMOrderEventTypeUnknown = 0,
    WMOrderEventTypeSuccessOrder = 10,            ///< 成功下单
    WMOrderEventTypeMerchantAcceptedOrder = 11,   ///< 商家接单
    WMOrderEventTypeMerchantReject = 12,          ///< 拒单
    WMOrderEventTypeUserCancelApplying = 13,      ///< 申请取消订单
    WMOrderEventTypeAcceptCancel = 14,            ///< 同意取消订单
    WMOrderEventTypeRejectCancel = 15,            ///< 拒绝取消订单
    WMOrderEventTypeOrderCancelled = 16,          ///< 订单被取消
    WMOrderEventTypeMerchantPreparedMeal = 17,    ///< 确认出餐
    WMOrderEventTypeChangeDeliveringArrived = 19, ///< 已送达
    WMOrderEventTypeOrderConfirmReceived = 20,    ///< 确认收货
    WMOrderEventTypeWriteEvaluation = 21,         ///< 填写评价
    WMOrderEventTypeArrangeDeliver = 22,          ///< 分配骑手
    WMOrderEventTypeDeliverReceive = 23,          ///< 骑手接配送单
    WMOrderEventTypeDeliverReject = 24,           ///< 拒绝配送单
    WMOrderEventTypeDeliverArriveStore = 25,      ///< 确认到店
    WMOrderEventTypeRefundApplying = 26,          ///< 申请退款
    WMOrderEventTypeMerchantAcceptRefund = 27,    ///< 同意退款
    WMOrderEventTypeMerchantRejectRefund = 28,    ///< 拒绝退款
    WMOrderEventTypeMerchantPreparingFood = 29,   ///< 开始备餐
    WMOrderEventTypeUploadingRefundTicket = 30,   ///< 上传退款凭证
    WMOrderEventTypePaySuccess = 31,              ///< 支付成功
    WMOrderEventTypeChangeDeliverOrder = 32,      ///< 转配送单
    WMOrderEventTypeConfirmReceiveFood = 33,      ///< 确认取餐
    WMOrderEventTypeRefundSuccess = 34,           ///< 退款成功
    WMOrderEventTypeRefundSponsor = 35,           ///< 发起退款
    WMOrderEventTypeReminder = 36,                ///< 催单
    WMOrderEventTypeComplete = 37,                ///< 完成订单
};

/// 操作平台
typedef NS_ENUM(NSUInteger, WMOrderEventOperatorPlatform) {
    WMOrderEventOperatorPlatformUnknown = 0,
    WMOrderEventOperatorPlatformUser = 10,             ///< 用户
    WMOrderEventOperatorPlatformMerchant = 20,         ///< 商家
    WMOrderEventOperatorPlatformOperationalStaff = 30, ///< 运营人员
    WMOrderEventOperatorPlatformDeliver = 40,          ///< 骑手
    WMOrderEventOperatorPlatformSystem = 50,           ///< 系统
    WMOrderEventOperatorPlatformChannel = 60,          ///< 渠道
};

/// 活动类型
typedef NS_ENUM(NSInteger, WMStorePromotionMarketingType) {
    WMStorePromotionMarketingTypeBestSale = -1,          ///< 爆款
    WMStorePromotionMarketingTypeDiscount = 11,          ///< 平台折扣
    WMStorePromotionMarketingTypeStoreLabber = 21,       ///< 门店满减
    WMStorePromotionMarketingTypeLabber = 18,            ///< 平台满减
    WMStorePromotionMarketingTypeDelievry = 19,          ///< 平台减配送费
    WMStorePromotionMarketingTypeFirst = 20,             ///< 门店首单
    WMStorePromotionMarketingTypeCoupon = 15,            ///< 优惠券
    WMStorePromotionMarketingTypeProductPromotions = 23, ///< 商品优惠
    WMStorePromotionMarketingTypePromoCode = 32,         ///< 促销码
    WMStorePromotionMarketingTypeFillGift = 14,          ///< 满赠
    WMStorePromotionMarketingTypePlatform = 41,          ///< 平台活动
};

/// 活动主体类型
typedef NS_ENUM(NSUInteger, WMPromotionSubjectType) {
    WMPromotionSubjectTypePlatform = 10,            ///< 平台
    WMPromotionSubjectTypeMerchant = 11,            ///< 商户
    WMPromotionSubjectTypePlatformAndMerchant = 12, ///< 平台+商户
};

/// 自动接单配置
typedef NSString *WMOrderAutoAcceptConfigType NS_STRING_ENUM;

FOUNDATION_EXPORT WMOrderAutoAcceptConfigType const WMOrderAutoAcceptConfigTypeNone;
FOUNDATION_EXPORT WMOrderAutoAcceptConfigType const WMOrderAutoAcceptConfigTypeAuto;

/// 配送模式
typedef NSString *WMOrderDeliveryMode NS_STRING_ENUM;

FOUNDATION_EXPORT WMOrderDeliveryMode const WMOrderDeliveryModeMerchant;
FOUNDATION_EXPORT WMOrderDeliveryMode const WMOrderDeliveryModePlatform;

/// 评价状态，订单列表用的
typedef NS_ENUM(NSUInteger, WMOrderEvaluationStatus) {
    WMOrderEvaluationStatusUnknown = 0,
    WMOrderEvaluationStatusIntialized = 99,        ///< 初始状态
    WMOrderEvaluationStatusWaitingEvaluation = 10, ///< 待评论
    WMOrderEvaluationStatusCommented = 11,         ///< 已评论
};

/// 售后退款方式
typedef NS_ENUM(NSUInteger, WMOrderRefundMethod) {
    WMOrderRefundMethodUnknown = 0,
    WMOrderRefundMethodOriginalMethod = 10, ///< 原路返回
    WMOrderRefundMethodOffline = 20,        ///< 线下退款
};

/// 订单详情页退款状态
typedef NS_ENUM(NSUInteger, WMOrderDetailRefundState) {
    WMOrderDetailRefundStateUnknown = 0,
    WMOrderDetailRefundStateApplying = 10, ///< 退款中,
    WMOrderDetailRefundStateSuccess = 11,  ///< 退款成功
};

/// 下单异常场景
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonStoreClosed;         ///< 门店休息
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonStoreStopped;        ///< 门店停业/停用
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonBeyondDeliveryScope; ///< 超出配送范围
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonDeliveryFeeChanged;  ///< 配送费活动变更
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonPromotionEnded;      ///< 活动已结束或停用

FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonHaveRemovedProduct;   ///< 包含失效商品
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonProductInfoChanged;   ///< 商品信息变更
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonProductOutOfStock;    ///< 商品库存不足
FOUNDATION_EXPORT SAResponseType const WMOrderCheckFailureReasonProductAmountChanged; ///< 商品金额变更

/// 加购失败原因，暂未使用
// FOUNDATION_EXPORT SAResponseType const WMAddProductFailureReasonInfoChanged;                       ///< 商品属性、规格变更
// FOUNDATION_EXPORT SAResponseType const WMAddProductFailureReasonRemoved;                           ///< 商品失效

#endif
