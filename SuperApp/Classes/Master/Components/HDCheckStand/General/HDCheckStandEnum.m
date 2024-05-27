//
//  HDCheckStandEnum.m
//  SuperApp
//
//  Created by VanJay on 2020/6/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"

HDCheckStandPaymentTools const HDCheckStandPaymentToolsBalance = @"10";    ///< 余额
HDCheckStandPaymentTools const HDCheckStandPaymentToolsWechat = @"12";     ///< 微信支付
HDCheckStandPaymentTools const HDCheckStandPaymentToolsAlipay = @"11";     ///< 支付宝支付
HDCheckStandPaymentTools const HDCheckStandPaymentToolsCredit = @"14";     ///< 信用卡
HDCheckStandPaymentTools const HDCheckStandPaymentToolsABAPay = @"15";     ///< ABAPays
HDCheckStandPaymentTools const HDCheckStandPaymentToolsWing = @"17";       ///< wing卡支付
HDCheckStandPaymentTools const HDCheckStandPaymentToolsPrince = @"37";     ///< 太子银行
HDCheckStandPaymentTools const HDCheckStandPaymentToolsACLEDABank = @"43"; ///< ACLEDA Bank支付
HDCheckStandPaymentTools const HDCheckStandPaymentToolsABAKHQR = @"44";    ///< ABAKHQR
HDCheckStandPaymentTools const HDCheckStandPaymentToolsHuiOneV2 = @"46"; ///< 新汇旺
HDCheckStandPaymentTools const HDCheckStandPaymentToolsSmartPay = @"102";
//HDCheckStandPaymentTools const HDCheckStandPaymentToolsAlipayPlus = @"45";


HDSupportedPaymentMethod const HDSupportedPaymentMethodOnline = @"ONLINE_PAYMENT";           ///< 在线付款
HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDelivery = @"CASH_ON_DELIVERY"; ///< 货到付款
HDSupportedPaymentMethod const HDSupportedPaymentMethodTransfer = @"OFFLINE_TRANSFER";       ///< 线下转账
HDSupportedPaymentMethod const HDSupportedPaymentMethodQRCode = @"SCAN_PAYMENT";             ///< 扫码支付

/// 针对外卖业务定制的两种状态，仅外卖使用
HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDeliveryForbidden = @"HDSupportedPaymentMethodCashOnDeliveryForbidden";                   ///< 禁止货到付款
HDSupportedPaymentMethod const HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore = @"HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore"; ///< 禁止到店自取货到付款
