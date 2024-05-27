//
//  HDCheckStandEnum.h
//  SuperApp
//
//  Created by VanJay on 2020/6/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 交易类型(10/消费, 11/转账, 12/收款, 13/兑汇, 14/充值, 15/退款, 16/提现) */
typedef NS_ENUM(NSInteger, HDTransType) {
    HDTransTypeDefault = 0,      ///< 所有
    HDTransTypeRecharge = 14,    ///< 充值 网店
    HDTransTypeConsume = 10,     ///< 消费 名称
    HDTransTypeTransfer = 11,    ///< 转账 手机号
    HDTransTypeExchange = 13,    ///< 兑换
    HDTransTypeWithdraw = 16,    ///< 提现 网点（改为出金）
    HDTransTypeCollect = 12,     ///< 收款 手机号
    HDTransTypeRefund = 15,      ///< 退款
    HDTransTypePinkPacket = 17,  ///< 红包
    HDTransTypeRemuneration = 18 ///< 酬劳
};

/** 二级交易类型 */
typedef NS_ENUM(NSInteger, HDTradeSubTradeType) {
    HDTradeSubTradeTypeDefault = 0,        ///< 默认
    HDTradeSubTradeTypePhoneTopUp = 10,    ///< 手机充值
    HDTradeSubTradeTypeCashBack = 11,      ///< 立返
    HDTradeSubTradeTypeBroadandTV = 12,    ///< 网络和电视充值
    HDTradeSubTradeTypeNewUserRights = 13, ///< 新用户专享红包
    HDTradeSubTradeTypeInviteReward = 14,  ///< 邀请好友奖励
    HDTradeSubTradeTypeMerchantAgent = 25, ///< 商户代理入金
    HDTradeSubTradeTypeBankCashIn = 26     ///< 银行卡入金
};

/** 付款方式类型 */
typedef NS_ENUM(NSInteger, HDTradePaymentMethodType) {
    HDTradePaymentMethodTypeDefault = 0, ///< 默认
    HDTradePaymentMethodTypeKHR,         ///< 瑞尔
    HDTradePaymentMethodTypeUSD,         ///< 美元
};

/** 付款方式是否可用 */
typedef NS_ENUM(NSInteger, HDTradePaymentMethodStatus) {
    HDTradePaymentMethodStatusUnusable = 0, ///< 不可用
    HDTradePaymentMethodStatusUsable = 1,   ///< 可用
};

/** 支付状态，收银流水状态 */
typedef NS_ENUM(NSInteger, HDPayOrderStatus) {
    HDPayOrderStatusUnknown = 0,     ///< 未知
    HDPayOrderStatusCreated = 10,    ///< 已创建
    HDPayOrderStatusSuccess = 12,    ///< 成功
    HDPayOrderStatusFailed = 13,     ///< 失败
    HDPayOrderStatusProcessing = 11, ///< 处理中
    HDPayOrderStatusClosed = 15,     ///< 交易关闭
};

// 订单状态
typedef NS_ENUM(NSInteger, HDOrderStatus) {
    HDOrderStatusKnown = 0,       ///< 未知
    HDOrderStatusProcessing = 11, ///< 处理中
    HDOrderStatusSuccess = 12,    ///< 成功
    HDOrderStatusFailure = 13,    ///< 失败
    HDOrderStatusCancel = 14,     ///< 取消
    HDOrderStatusRefund = 15      ///< 已退款
};

/** 优惠是否可用 */
typedef NS_ENUM(NSInteger, HDTradePreferentialStatus) {
    HDTradePreferentialStatusUnusable = 0, ///< 不可用
    HDTradePreferentialStatusUsable = 1,   ///< 可用
};

/** 支付营销活动状态 */
typedef NS_ENUM(NSInteger, HDPaymentActivityState) {
    HDPaymentActivityStateAvailable = 10,  ///< 可用
    HDPaymentActivityStateUnavailable = 11 ///< 不可用
};
/** 支付营销活动类型 */
typedef NS_ENUM(NSInteger, HDPaymentActivityType) {
    HDPaymentActivityTypePaidLabber = 36 ///< 支付立减
};

/// 支付工具
typedef NSString *HDCheckStandPaymentTools NS_STRING_ENUM;
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsBalance;    ///< 余额支付
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsWechat;     ///< 微信支付
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsAlipay;     ///< 支付宝支付
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsCredit;     ///< 信用卡
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsABAPay;     ///< ABAPay
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsWing;       ///< wing卡支付
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsPrince;     ///< 太子银行
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsACLEDABank; ///< ACLEDA Bank支付
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsABAKHQR;    ///< ABAKHQR
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsHuiOneV2; ///< 汇旺新sdk
FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsSmartPay;  ///< smartPay
//FOUNDATION_EXPORT HDCheckStandPaymentTools const HDCheckStandPaymentToolsAlipayPlus; ///< alipay+

/// 支付方式
typedef NSString *HDSupportedPaymentMethod NS_STRING_ENUM;

FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodOnline;         ///< 在线付款
FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDelivery; ///< 货到付款
FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodTransfer;       ///< 线下转账
FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodQRCode;         ///< 扫码支付

/// 针对外卖业务定制的两种状态，仅外卖使用
FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDeliveryForbidden;          ///< 禁止货到付款
FOUNDATION_EXPORT HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore; ///< 禁止到店自取货到付款

NS_ASSUME_NONNULL_END
