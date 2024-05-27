//
//  PNEnum.m
//  ViPay
//
//  Created by seeu on 2019/7/22.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"

PNCurrencyType const PNCurrencyTypeUSD = @"USD";
PNCurrencyType const PNCurrencyTypeKHR = @"KHR";
PNCurrencyType const PNCurrencyTypeCNY = @"CNY";
PNCouponTicketUsableScene const PNCouponTicketUsableSceneStorePaying = @"10";
PNCouponTicketUsableScene const PNCouponTicketUsableScenePhoneRecharging = @"11";

/// 特殊的时间
PNSPECIALTIME const PNSPECIALTIMEFOREVER = @"31/12/9999"; /// 永久有效

/// 费用类型
PNChargeType const PNChargeTypeD = @"D"; ///< 客户全部承担
PNChargeType const PNChargeTypeC = @"C"; ///< 商家全部承担
PNChargeType const PNChargeTypeP = @"P"; ///< 客户和商家按比例共同承担

/// 转账业务 枚举
PNTransferType const PNTransferTypeToCoolcash = @"1001";             ///< 1001 转账到账户
PNTransferType const PNTransferTypePersonalToBaKong = @"1002";       ///< 1002 个人转账到bakong
PNTransferType const PNTransferTypePersonalToBank = @"1003";         ///< 1003 个人转账到银行
PNTransferType const PNTransferTypePersonalScanQRToBakong = @"1004"; ///< 1004 个人扫码支付到Bakong钱包
PNTransferType const PNTransferTypeToInternational = @"1005";        ///< 1005 国际转账
PNTransferType const PNTransferTypeToPhone = @"1010";                ///< 1010 转账汇款到手机号

PNTransferType const PNTransferTypeBakongRefund = @"1050"; ///< 1050 bakong退款
// 借用
PNTransferType const PNTransferTypeWitdraw = @"23"; ///< 23 提现到银行卡

PNWAlletAccountStatus const PNWAlletAccountStatusNormal = @"00";    ///< 正常
PNWAlletAccountStatus const PNWAlletAccountStatusClose = @"01";     ///< 销户
PNWAlletAccountStatus const PNWAlletAccountStatusFreeze = @"02";    ///< 冻结
PNWAlletAccountStatus const PNWAlletAccountStatusLoss = @"03";      ///< 挂失
PNWAlletAccountStatus const PNWAlletAccountStatusNotActive = @"04"; ///< 未激活
PNWAlletAccountStatus const PNWAlletAccountStatusNotSilent = @"06"; ///< 沉默

/// 担保交易状态流转
PNGuarateenActionStatus const PNGuarateenActionStatus_BUILD = @"BUILD";                 ///< BUILD 下单
PNGuarateenActionStatus const PNGuarateenActionStatus_CONFIRM = @"CONFIRM";             ///< CONFIRM 确认
PNGuarateenActionStatus const PNGuarateenActionStatus_REJECT = @"REJECT";               ///< REJECT 拒绝
PNGuarateenActionStatus const PNGuarateenActionStatus_COMPLETE = @"COMPLETE";           ///< COMPLETE 确认完成交易
PNGuarateenActionStatus const PNGuarateenActionStatus_CANCEL = @"CANCEL";               ///< CANCEL 取消交易
PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_APPLY = @"REFUND_APPLY";   ///< REFUND_APPLY 申请退款
PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_CANCEL = @"REFUND_CANCEL"; ///< REFUND_CANCEL 取消退款
PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_APPEAL = @"REFUND_APPEAL"; ///< REFUND_APPEAL 向平台申述
PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_CANCEL = @"APPEAL_CANCEL"; ///< APPEAL_CANCEL 取消申述
PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_PASS = @"REFUND_PASS";     ///< REFUND_PASS 退款通过
PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_REJECT = @"REFUND_REJECT"; ///< REFUND_REJECT 退款拒绝
PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_PASS = @"APPEAL_PASS";     ///< APPEAL_PASS 申诉通过
PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_REJECT = @"APPEAL_REJECT"; ///< APPEAL_REJECT 申诉驳回


PNWalletListFilterType const PNWalletListFilterType_All = @"00";              ///< 00 所有
PNWalletListFilterType const PNWalletListFilterType_Consumption = @"01";      ///< 01 消费
PNWalletListFilterType const PNWalletListFilterType_Recharge = @"02";         ///< 02 充值
PNWalletListFilterType const PNWalletListFilterType_Withdrawal = @"03";       ///< 03 提现
PNWalletListFilterType const PNWalletListFilterType_Transfer = @"04";         ///< 04 转账
PNWalletListFilterType const PNWalletListFilterType_Exchange = @"05";         ///< 05 汇兑
PNWalletListFilterType const PNWalletListFilterType_Settlement = @"06";       ///< 06 结算
PNWalletListFilterType const PNWalletListFilterType_Entry_Adjustment = @"07"; ///< 07 分录调帐
PNWalletListFilterType const PNWalletListFilterType_Self_Adjustment = @"08";  ///< 08:自主调帐
PNWalletListFilterType const PNWalletListFilterType_Refund = @"09";           ///< 09 退款
PNWalletListFilterType const PNWalletListFilterType_Marketing = @"10";        ///< 10 营销
PNWalletListFilterType const PNWalletListFilterType_Credit = @"11";           ///< 11 信贷
