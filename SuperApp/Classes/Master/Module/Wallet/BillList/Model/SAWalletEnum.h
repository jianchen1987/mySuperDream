//
//  SAWalletEnum.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#ifndef SAWalletEnum_h
#define SAWalletEnum_h

#import <Foundation/Foundation.h>

/** 交易类型(10/消费, 11/转账, 12/收款, 13/兑汇, 14/充值, 15/退款, 16/提现) */
typedef NS_ENUM(NSInteger, HDWalletTransType) {
    HDWalletTransTypeDefault = 0,      ///< 未知
    HDWalletTransTypeRecharge = 14,    ///< 充值 网店
    HDWalletTransTypeConsume = 10,     ///< 消费 名称
    HDWalletTransTypeTransfer = 11,    ///< 转账 手机号
    HDWalletTransTypeExchange = 13,    ///< 兑换
    HDWalletTransTypeWithdraw = 16,    ///< 提现 网点
    HDWalletTransTypeCollect = 12,     ///< 收款 手机号
    HDWalletTransTypeRefund = 15,      ///< 退款
    HDWalletTransTypePinkPacket = 17,  ///< 红包
    HDWalletTransTypeRemuneration = 18 ///< 酬劳
};

/** 支付方式 (10-余额支付,11-支付宝支付,12-微信支付,14-信用卡支付,20-现金) */
typedef NS_ENUM(NSInteger, HDWalletPaymethod) {
    HDWalletPaymethodDefault = 0,     ///< 未知
    HDWalletPaymethodBalance = 10,    ///< 余额支付
    HDWalletPaymethodAlipay = 11,     ///< 支付宝支付
    HDWalletPaymethodWechat = 12,     ///< 微信支付
    HDWalletPaymethodBankCard = 13,   ///< 银行卡支付
    HDWalletPaymethodCreditCard = 14, ///< 信用卡支付
    HDWalletPaymethodABAPay = 15,     ///< abaPay
    HDWalletPaymethodAcledaPay = 16,
    HDWalletPaymethodWingPay = 17,
    HDWalletPaymethodMonney = 20, ///< 现金
    HDWalletPaymethodPrince = 37,
    HDWalletPaymethodHuiOne = 42, ///< 汇旺

};

#endif /* SAWalletEnum_h */
