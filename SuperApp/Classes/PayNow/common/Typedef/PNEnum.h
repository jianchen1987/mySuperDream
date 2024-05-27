//
//  PNEnum.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/28.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PNEnum_h
#define PNEnum_h

/// 钱包明细详情订单的状态
typedef NS_ENUM(NSInteger, PNWalletBalanceOrderStatus) {
    PNWalletBalanceOrderStatus_Init = 10,       ///< 10 初始
    PNWalletBalanceOrderStatus_Processing = 11, ///< 11 处理中
    PNWalletBalanceOrderStatus_Success = 12,    ///< 12 成功
    PNWalletBalanceOrderStatus_Fail = 13,       ///< 13 失败
    PNWalletBalanceOrderStatus_Refunded = 14,   ///< 14 己退款
    PNWalletBalanceOrderStatus_Close = 15,      ///< 15 交易关闭
};

/// 钱包账户余额枚举
typedef NS_ENUM(NSInteger, PNWalletBalanceType) {
    PNWalletBalanceType_Non = -1,             ///< -1 空
    PNWalletBalanceType_USD_BALANCE = 11,     ///< 11 美元账户余额
    PNWalletBalanceType_KHR_BALANCE = 12,     ///< 12 瑞尔账户余额
    PNWalletBalanceType_USD_KHR_BALANCE = 13, ///< 13 美元和瑞尔账户余额
};

/// 钱包明细 交易类型
typedef NS_ENUM(NSInteger, PNWalletOrderTradeType) {
    PNWalletOrderTradeType_PAYMENT = 10,                ///< 10 消费
    PNWalletOrderTradeType_TRANSFER = 11,               ///< 11 转账
    PNWalletOrderTradeType_COLLECT = 12,                ///< 12 收款
    PNWalletOrderTradeType_EXCHANGE = 13,               ///< 13 兑换
    PNWalletOrderTradeType_TOP_UP = 14,                 ///< 14 入金
    PNWalletOrderTradeType_REFUND = 15,                 ///< 15 退款
    PNWalletOrderTradeType_WITHDRAW_CASH = 16,          ///< 16 出金
    PNWalletOrderTradeType_ANGPAO = 17,                 ///< 17 红包
    PNWalletOrderTradeType_REWARD = 18,                 ///< 18 酬劳
    PNWalletOrderTradeType_RECHARGE = 19,               ///< 19 话费直充
    PNWalletOrderTradeType_TRANSFER_ACC = 20,           ///< 20 转账到CoolCash-非扫码
    PNWalletOrderTradeType_PER_TRANSFER_BAKONG = 21,    ///< 21 转账到Bakong
    PNWalletOrderTradeType_PER_TRANSFER_BANK = 22,      ///< 22 转账到银行
    PNWalletOrderTradeType_COOLCASH_CASH_IN = 23,       ///< 23 CoolCash入金
    PNWalletOrderTradeType_BAKONG_CASH_IN = 24,         ///< 24 bakong入金-非扫码
    PNWalletOrderTradeType_BILL_PAYMENT = 25,           ///< 25 账单支付
    PNWalletOrderTradeType_ADJUST = 26,                 ///< 26 调账
    PNWalletOrderTradeType_FROZEN = 27,                 ///< 27 冻结扣款
    PNWalletOrderTradeType_TRANSFER_V2P = 28,           ///< 28 转账到手机号
    PNWalletOrderTradeType_BAKONG_CASH_IN_QR = 29,      ///< 29 Bakong入金-扫码
    PNWalletOrderTradeType_TRANSFER_ACC_QR = 30,        ///< 30 转账到CoolCash-扫码
    PNWalletOrderTradeType_PER_TRANSFER_THUNES = 31,    ///< 31 国际转账
    PNWalletOrderTradeType_PER_TRANSFER_BAKONG_QR = 32, ///< 32 转账到bakong/银行-扫码
};

/// 担保状态
typedef NS_ENUM(NSInteger, PNGuarateenStatus) {
    PNGuarateenStatus_ALL = 0,            ///< 0 所有
    PNGuarateenStatus_UNCONFIRMED = 10,   ///< 10 待确认
    PNGuarateenStatus_UNPAID = 11,        ///< 11 待付款
    PNGuarateenStatus_PENDING = 12,       ///< 12 待完成
    PNGuarateenStatus_COMPLETED = 13,     ///< 13 已完成
    PNGuarateenStatus_CANCELED = 14,      ///< 14 已取消
    PNGuarateenStatus_REFUND_APPLY = 15,  ///< 15 买方申请退款
    PNGuarateenStatus_REFUND_REJECT = 16, ///< 16 卖方拒绝退款
    PNGuarateenStatus_REFUND_APPEAL = 17, ///< 17 买方申述
    PNGuarateenStatus_APPEAL_REJECT = 18, ///< 18 申述驳回
    PNGuarateenStatus_REFUNDED = 19,      ///< 19 已退款
    PNGuarateenStatus_REJECT = 20,        ///< 20 已拒绝
};

/// 公寓缴费 缴费状态
typedef NS_ENUM(NSInteger, PNApartmentPaymentStatus) {
    PNApartmentPaymentStatus_ALL = 0,                        ///< 所有
    PNApartmentPaymentStatus_TO_PAID = 10,                   ///< 10-->待缴费
    PNApartmentPaymentStatus_PAID = 11,                      ///< 11-->已缴费
    PNApartmentPaymentStatus_USER_HAS_UPLOADED_VOUCHER = 12, ///< 12-->用户已上传凭证
    PNApartmentPaymentStatus_USER_REJECT = 15,               ///< 15-->用户拒绝
    PNApartmentPaymentStatus_CLOSED = 16,                    ///< 16-->已关闭
};

/// 红包领取状态
typedef NS_ENUM(NSInteger, PNPacketReceiveStatus) {
    PNPacketReceiveStatus_UNCLAIMED = 11,       ///< 11 未领取
    PNPacketReceiveStatus_PARTIAL_RECEIVE = 12, ///< 12 部分领取
    PNPacketReceiveStatus_RECEIVED = 13,        ///< 13 已领完
    PNPacketReceiveStatus_PARTIAL_REFUND = 14,  ///< 14 部分退款
    PNPacketReceiveStatus_REFUNDED = 15,        ///< 15 已退款
};

/// 红包状态 类型
typedef NS_ENUM(NSInteger, PNPacketMessageStatus) {
    PNPacketMessageStatus_UNCLAIMED = 10,       ///< 10 未领取
    PNPacketMessageStatus_PARTIAL_RECEIVE = 11, ///< 11 已领取
    PNPacketMessageStatus_EXPIRED = 12,         ///< 12 已过期
    PNPacketMessageStatus_NO_WAITING = 13,      ///< 13 已抢光
};

/// 口令类型
typedef NS_ENUM(NSInteger, PNPacketKeyType) {
    PNPacketKeyType_System = 10, ///< 10 系统推荐口令
    PNPacketKeyType_Custom = 11, ///< 11 自定义口令
};

/// 红包接收对象
typedef NS_ENUM(NSInteger, PNPacketGrantObject) {
    PNPacketGrantObject_Non = -1, ///< 空
    PNPacketGrantObject_In = 10,  ///< 10 内部用户
    PNPacketGrantObject_Out = 11, ///< 11 外部用户
};

/// 红包类型
typedef NS_ENUM(NSInteger, PNPacketType) {
    PNPacketType_Nor = 10,      ///< 10 普通红包
    PNPacketType_Password = 11, ///< 11 口令红包
};

/// 红包类型
typedef NS_ENUM(NSInteger, PNPacketSplitType) {
    PNPacketSplitType_Lucky = 10,   ///< 10 拼手气
    PNPacketSplitType_Average = 11, ///< 11 平均金额
};

/// 首页菜单权限
typedef NS_ENUM(NSInteger, PNMSMenusRoleType) {
    PNMSMenusRoleType_WALLET_BALANCE = 10,       ///< 10 余额
    PNMSMenusRoleType_COLLECTION_TODAY = 11,     ///< 11 今日收款
    PNMSMenusRoleType_WALLET_WITHDRAWAL = 12,    ///< 12 提现
    PNMSMenusRoleType_COLLECTION_DATA_QUER = 13, ///< 13 交易记录
    PNMSMenusRoleType_STORE_MANAGEMENTC = 14,    ///< 14 门店管理
    PNMSMenusRoleType_MERCHANT_CODE_QUERY = 15,  ///< 14 收款码
    PNMSMenusRoleType_OPERATOR_MANAGEMENTC = 16, ///< 16 操作员管理
    PNMSMenusRoleType_UPLOAD_VOUCHER = 17,       ///< 17 上传凭证
    PNMSMenusRoleType_Setting = 18,              ///< 18 设置
};

/// 商户门店角色权限
typedef NS_ENUM(NSInteger, PNMSRoleType) {
    PNMSRoleType_MANAGEMENT = 10,    ///< 10 商户超管
    PNMSRoleType_OPERATOR = 11,      ///< 11 商户操作员
    PNMSRoleType_STORE_MANAGER = 12, ///< 12 门店店长
    PNMSRoleType_STORE_STAFF = 13,   ///< 13 门店店员
};

/// 商户权限
typedef NS_ENUM(NSInteger, PNMSPermissionType) {
    PNMSPermissionType_WALLET_BALANCE_QUERY = 10,  ///< (10, "钱包余额查询权限")
    PNMSPermissionType_WALLET_WITHDRAWAL = 11,     ///< (11, "钱包提现权限")
    PNMSPermissionType_COLLECTION_DATA_QUERY = 12, ///< (12,"收款数据查询权限")
    PNMSPermissionType_STORE_MANAGEMENT = 13,      ///< (13,"门店管理权限")
    PNMSPermissionType_MERCHANT_CODE_QUERY = 14,   ///< (14,"商家收款码查询权限")
    PNMSPermissionType_STORE_DATA_QUERY = 15,      ///< (15,"门店数据查询权限")
};

/// Thunes 渠道
typedef NS_ENUM(NSInteger, PNInterTransferThunesChannel) {
    PNInterTransferThunesChannel_Alipay = 10, ///< 支付宝
    PNInterTransferThunesChannel_Wechat = 11, ///< 微信
};

/// 规则适用风控方
typedef NS_ENUM(NSInteger, PNInterTransferDirection) {
    PNInterTransferDirectionPayer = 10,    ///< 付款方
    PNInterTransferDirectionReceiver = 11, ///< 收款方
};

/// 国际转账业务订单状态
typedef NS_ENUM(NSInteger, PNInterTransferOrderStatus) {
    PNInterTransferOrderStatusInit = 10,        ///< 10 初始
    PNInterTransferOrderStatusPayed = 11,       ///< 11 支付完成
    PNInterTransferOrderStatusApplyed = 12,     ///< 12 创建,  已提交申请，待确认
    PNInterTransferOrderStatusConfirmIng = 13,  ///< 13确认, 转账确认中
    PNInterTransferOrderStatusTransferIng = 14, ///< 14 提交, 转账处理中
    PNInterTransferOrderStatusCanWithdraw = 15, ///< 15 待收款人提款, 转账成功，可提款
    PNInterTransferOrderStatusFinish = 20,      ///< 20 已完成, 转账成功，资金已入账
    PNInterTransferOrderStatusRejuect = 21,     ///< 21 拒绝, 转账失败
    PNInterTransferOrderStatusCancel = 22,      ///< 22 取消, 转账失败
    PNInterTransferOrderStatusFaild = 23,       ///< 23 失败, 入账失败
    PNInterTransferOrderStatusRevoke = 24,      ///< 24 撤销 转账已撤销
    PNInterTransferOrderStatusABNORMAL = 25,    ///< 25 异常
};

/// 商户状态
typedef NS_ENUM(NSInteger, PNMerchantStatus) {
    PNMerchantStatusEnable = 10,        ///< 启用
    PNMerchantStatusDisenable = 11,     ///< 禁用
    PNMerchantStatusToBeActivated = 12, ///< 待激活 [暂时不用]
    PNMerchantStatusOff = 13,           ///< 退网  [暂时不用]
    PNMerchantStatusUnderKYCLevel = 20, ///< kyc等级不够
    PNMerchantStatusReviewing = 21,     ///< 审核中
    PNMerchantStatusFailed = 22,        ///< 审核失败
    PNMerchantStatusUnBind = 23,        ///< 未绑定商户
};

/// 商户类型
typedef NS_ENUM(NSInteger, PNMerchantType) {
    PNMerchantTypeNon = 0,         ///< 无  理论上应该是没有
    PNMerchantTypeIndividual = 10, ///< 个人商户
    PNMerchantTypeBusiness = 12,   ///< 企业商户
};

/// 提现码状态
typedef NS_ENUM(NSInteger, PNWithdrawCodeStatus) {
    PNWithdrawCodeStatusNoWithdraw = 0,   ///< 未提现
    PNWithdrawCodeStatusWithdrawIng = 1,  ///< 提现中
    PNWithdrawCodeStatusWithdrawed = 2,   ///< 已提现
    PNWithdrawCodeStatusInvaild = 3,      ///< 已失效
    PNWithdrawCodeStatusReSet = 4,        ///< 已重置     - 理论上没用到
    PNWithdrawCodeStatusApply = 5,        ///< 申请审核   - 理论上没用到
    PNWithdrawCodeStatusApplySuccess = 6, ///< 审核通过   - 理论上没用到
    PNWithdrawCodeStatusApplyReject = 7,  ///< 审核拒绝   - 理论上没用到
    PNWithdrawCodeStatusToZero = 8,       ///< 扣分到零   - 理论上没用到
    PNWithdrawCodeStatusRefunded = 9,     ///< 已退款
};

/**
 缴费状态：待缴费、缴费处理中，缴费成功；
 待缴费：待支付、支付处理中、支付失败，都属于待缴费
 缴费处理中：支付成功后，Bill 24账单状态未更新为已缴费时的状态
 缴费成功：查询到Bill 24的账单状态为已缴费时的缴费状态
 */

typedef NS_ENUM(NSInteger, PNBillPaytStatus) {
    PNBillPaymentStatusInit = 10,             ///< 10 INIT 初始化
    PNBillPaymentStatusProcessing = 11,       ///< 11 PROCESSING 处理中
    PNBillPaymentStatusSuccess = 12,          ///< 12 SUCCESS 成功 （最终状态此时表示这笔账单完成）
    PNBillPaymentStatusConfirmIng = 13,       ///< 13 SUCCESS 确认中
    PNBillPaymentStatusConfirmSuccess = 14,   ///< 14 确认成功 [确认成功但还没有验证]
    PNBillPaymentStatusFAIL = 15,             ///< 15 FAIL 失败
    PNBillPaymentStatusClose = 16,            ///< 16 CLOSE 关闭
    PNBillPaymentStatusVerificationFail = 17, ///< 17 验证失败 【定时任务验证失多次后】
};

/// 缴费类别
typedef NS_ENUM(NSInteger, PNPaymentCategory) {
    PNPaymentCategoryAll = 0,          ///< 所有
    PNPaymentCategoryWater = 10,       ///< 水费
    PNPaymentCategoryElectricity = 11, ///< 电费
    PNPaymentCategorySolidWaste = 12,  ///< 垃圾费
    PNPaymentCategoryGovernment = 13,  ///< 政府账单
    PNPaymentCategoryInsurance = 14,   ///< 保险账单
    PNPaymentCategorySchool = 15,      ///< 学校账单、教育账单
    PNPaymentCategoryAnimalFeed = 16,  ///< 动物饲料
    PNPaymentCategoryRaalEastate = 17, ///< 房地产
    PNPaymentCategoryTrading = 18,     ///< 贸易
    PNPaymentCategoryGame = 19,        ///< 游戏
};

/** 交易类型(10/消费, 11/转账, 12/收款, 13/兑汇, 14/充值, 15/退款, 16/提现) */
typedef NS_ENUM(NSInteger, PNTransType) {
    PNTransTypeDefault = 0,       ///< 0 所有
    PNTransTypeConsume = 10,      ///< 10 消费 名称
    PNTransTypeTransfer = 11,     ///< 11 转账 手机号
    PNTransTypeCollect = 12,      ///< 12 收款 手机号
    PNTransTypeExchange = 13,     ///< 13 兑换
    PNTransTypeRecharge = 14,     ///< 14 充值 网店
    PNTransTypeRefund = 15,       ///< 15 退款
    PNTransTypeWithdraw = 16,     ///< 16 提现 网点
    PNTransTypePinkPacket = 17,   ///< 17 红包
    PNTransTypeRemuneration = 18, ///< 18 酬劳
    PNTransTypeApartment = 25,    ///< 25 缴费
    PNTransTypeAdjust = 26,       ///< 26 调账
    PNTransTypeBlocked = 27,      ///< 27 冻结扣款
    PNTransTypeToPhone = 28,      ///< 28 转账到手机号
};

/** 二级交易类型 */
typedef NS_ENUM(NSInteger, PNTradeSubTradeType) {
    PNTradeSubTradeTypeDefault = 0,                  ///< 默认
    PNTradeSubTradeTypePhoneTopUp = 10,              ///< 手机充值
    PNTradeSubTradeTypeCashBack = 11,                ///< 立返
    PNTradeSubTradeTypeBroadandTV = 12,              ///< 网络和电视充值
    PNTradeSubTradeTypeNewUserRights = 13,           ///< 新用户专享红包
    PNTradeSubTradeTypeInviteReward = 14,            ///< 邀请好友奖励
    PNTradeSubTradeTypeMerchantAgent = 25,           ///< 商户代理入金
    PNTradeSubTradeTypeBankCashIn = 26,              ///< 银行卡入金
    PNTradeSubTradeTypeToCoolCash = 27,              ///< 转账到coolcash
    PNTradeSubTradeTypeToBank = 28,                  ///< 转账到银行
    PNTradeSubTradeTypeToBakong = 29,                ///< 转账到bakong
    PNTradeSubTradeTypeToBakongCode = 30,            ///< 扫码转账到bakong
    PNTradeSubTradeTypeToAgent = 31,                 ///< 扫码转账到代理商
    PNTradeSubTradeTypeCoolCashCashOut = 32,         ///< 扫码出金
    PNTradeSubTradeTypeToPhone = 33,                 ///< 转账到手机号
    PNTradeSubTradeTypeToBakongMerchant = 34,        ///< 向商户付款
    PNTradeSubTradeTypeToInternational = 35,         ///< 国际转账
    PNTradeSubTradeTypeMerchantToSelfWallet = 10000, ///< 商户提现到自己的钱包 [APP自定义]
    PNTradeSubTradeTypeMerchantToSelfBank = 10001,   ///< 商户提现到自己的银行卡 [APP自定义]
    PNTradeSubTradeTypeEntertainment = 10002,        ///< 娱乐缴费 [APP自定义]
};

/// token类型
typedef NS_ENUM(NSInteger, PNTokenType) { PNTokenTypeModifyLoginPwd = 15, PNTokenTypeModifyPayPwd = 16, PNTokenTypeUploadImage = 17 };

/// 订单状态
typedef NS_ENUM(NSInteger, PNOrderStatus) {
    PNOrderStatusAll = -1,        ///< 全部
    PNOrderStatusUnknown = 0,     ///< 未知
    PNOrderStatusProcessing = 11, ///< 处理中
    PNOrderStatusSuccess = 12,    ///< 成功
    PNOrderStatusFailure = 13,    ///< 失败
    PNOrderStatusRefund = 14,     ///< 已退款
    PNOrderStatusDeducted = 16    ///< 已扣款
};

// 认证状态
typedef NS_ENUM(NSInteger, PNAuthenStatus) {
    PNAuthenStatusUbknown = 0, ///< 未知
    PNAuthenStatusNO = 12,     ///< 未实名
    PNAuthenStatusYES = 13     ///< 已实名
};

/** 用户账户等级 */
typedef NS_ENUM(NSUInteger, PNUserLevel) {
    PNUserLevelUnknown = 0,    ///< 未知
    PNUserLevelNormal = 100,   ///< 经典
    PNUserLevelAdvanced = 200, ///< 高级
    PNUserLevelHonour = 300,   ///< 尊享
};

/** 用户升级状态 */
typedef NS_ENUM(NSUInteger, PNAccountLevelUpgradeStatus) {
    PNAccountLevelUpgradeStatus_GoToUpgrade = 10,             ///< 可升级/去升级
    PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING = 11, ///< 高级账户审核中
    PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS = 12,    ///< 高级账户审核成功
    PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED = 13,     ///< 高级账户审核失败
    PNAccountLevelUpgradeStatus_SENIOR_UPGRADING = 14,        ///< 尊享账户审核中
    PNAccountLevelUpgradeStatus_SENIOR_SUCCESS = 15,          ///< 尊享账户审核成功
    PNAccountLevelUpgradeStatus_SENIOR_FAILED = 16,           ///< 尊享账户审核失败
    PNAccountLevelUpgradeStatus_APPROVALFAILED = 17,          ///< 降级审核通过 【降级时使用】 用户看到 就是 审核不通过
    PNAccountLevelUpgradeStatus_APPROVALING = 18,             ///< 降级审核中 【降级时使用】
};

/// 证件类型
typedef NS_ENUM(NSInteger, PNPapersType) {
    PNPapersTypeIDCard = 12,       ///< 身份证
    PNPapersTypePassport = 13,     ///< 护照
    PNPapersTypeDrivingLince = 22, ///< 柬埔寨驾照
    PNPapersTypepolice = 23        ///< 警察证/公务员证
};

/// 性别
typedef NS_ENUM(NSInteger, PNSexType) {
    PNSexTypeUnknow = 10, ///< 未知
    PNSexTypeMen = 14,    ///< 男
    PNSexTypeWomen = 15,  ///< 女
};

/** 用户业务 */
typedef NS_ENUM(NSInteger, PNUserBussinessType) {
    PNUserBussinessTypeDefault = 0,      ///< 默认
    PNUserBussinessTypePaymentCode = 12, ///< 付款码
};

/** 用户业务状态 */
typedef NS_ENUM(NSInteger, PNUserBussinessStatus) {
    PNUserBussinessStatusDefault = 0,       ///< 默认
    PNUserBussinessStatusOpened = 10,       ///< 已开通
    PNUserBussinessStatusUnAssociated = 11, ///< 未关联设备
    PNUserBussinessStatusClosed = 12,       ///< 未开通
};

/** 支付认证类型 */
typedef NS_ENUM(NSInteger, PNUserCertifiedTypes) {
    PNUserCertifiedTypesOpen = 10, ///< 10:免密支付认证
    PNUserCertifiedTypesNon = 11,  ///< 11:非免密支付认证
};

/// 限额说明列表
typedef NS_ENUM(NSInteger, PNLimitType) {
    PNLimitTypeDeposit = 1000,       //存款 1000
    PNLimitTypeConsumption = 1010,   //消费 1010
    PNLimitTypeTransfer = 1011,      //转账 1011
    PNLimitTypeTypeSingleDay = 1001, //单日 1001
    PNLimitTypePaymentCode = 1020,   //付款码 1020
};

/** 优惠券类型 */
typedef NS_ENUM(NSInteger, PNTradePreferentialType) {
    PNTradePreferentialTypeDefault = 0,         ///< 默认
    PNTradePreferentialTypeCashBack = 10,       ///< 返现
    PNTradePreferentialTypeMinus = 11,          ///< 立减
    PNTradePreferentialTypeDiscount = 12,       ///< 折扣
    PNTradePreferentialTypeDiscountTicket = 13, ///< 折扣券
    PNTradePreferentialTypeFullReduction = 14,  ///< 满减券
    PNTradePreferentialTypeCash = 15,           ///< 代金券
};

/** 优惠券状态 */
typedef NS_ENUM(NSInteger, PNCouponTicketStatus) {
    PNCouponTicketStatusDefault = 0,      ///< 默认
    PNCouponTicketStatusIneffective = 10, ///< 未生效
    PNCouponTicketStatusUnUsed = 11,      ///< 未使用
    PNCouponTicketStatusLocked = 12,      ///< 已锁定
    PNCouponTicketStatusUsed = 13,        ///< 已使用
    PNCouponTicketStatusOutDated = 14,    ///< 已过期
};

/** 优惠券归属类型 */
typedef NS_ENUM(NSInteger, HDCouponTicketSceneType) {
    HDCouponTicketSceneTypeDefault = 0,              ///< 默认
    HDCouponTicketSceneTypePlatform = 10,            ///< 平台优惠券
    HDCouponTicketSceneTypeMerchant = 11,            ///< 商户优惠券
    HDCouponTicketSceneTypePlatformAndMerchant = 12, ///< 平台+商户券
};

/** 优惠券可用币种 */
typedef NS_ENUM(NSInteger, HDCouponTicketSupportCurrencyType) {
    HDCouponTicketSupportCurrencyTypeDefault = 0,   ///< 默认
    HDCouponTicketSupportCurrencyTypeUSD = 11,      ///< 美金
    HDCouponTicketSupportCurrencyTypeKHR = 10,      ///< 卡瑞尔
    HDCouponTicketSupportCurrencyTypeUSDAndKHR = 12 ///< 美金和卡瑞尔
};

/** 领券渠道 */
typedef NS_ENUM(NSUInteger, HDGetCouponTicketChannel) {
    HDGetCouponTicketChannelDefault = 0,
    HDGetCouponTicketChannelRegistered = 100, ///< 注册
    HDGetCouponTicketChannelPayShare,         ///< 支付分享
    HDGetCouponTicketChannelScanCode,         ///< 扫码
    HDGetCouponTicketChannelMemberCard,       ///< 会员卡
    HDGetCouponTicketChannelPaySuccess        ///< 支付成功
};

/** 扫码付款支付方式 */
typedef NS_ENUM(NSInteger, PNQrCodePaymentType) {
    PNQrCodePaymentTypeDefault = 0, ///< 默认
    PNQrCodePaymentTypeViPay,       ///< ViPay
    PNQrCodePaymentTypeAliPay,      ///< 支付宝
    PNQrCodePaymentTypeWXPay,       ///< 微信
};

/** 收款方式类型 */
typedef NS_ENUM(NSInteger, PNCollectionWayType) {
    PNCollectionWayTypeDefault = 0,         ///< 默认
    PNCollectionWayTypeScan = 10,           ///< 扫码
    PNCollectionWayTypeCollectionCode = 11, ///< 收款码
    PNCollectionWayTypeWallet = 12,         ///< 钱包
    PNCollectionWayTypeApp = 13,            ///< App 支付
    PNCollectionWayTypeAliPayScan = 14,     ///< 支付宝扫码支付
    PNCollectionWayTypeWXPayScan = 15,      ///< 微信扫码支付
};

/// 交易结果 交易详情页
typedef NS_ENUM(NSInteger, PNOrderResultPageType) {
    detailPage = 0, ///< 交易详情页
    resultPage = 1, ///< 结果页
};

/** 优惠是否可用 */
typedef NS_ENUM(NSInteger, PNTradePreferentialStatus) {
    PNTradePreferentialStatusUnusable = 0, ///< 不可用
    PNTradePreferentialStatusUsable = 1,   ///< 可用
};

/** 付款方式类型 */
typedef NS_ENUM(NSInteger, PNTradePaymentMethodType) {
    PNTradePaymentMethodTypeDefault = 0, ///< 默认
    PNTradePaymentMethodTypeKHR,         ///< 瑞尔
    PNTradePaymentMethodTypeUSD,         ///< 美元
};

/** 付款方式是否可用 */
typedef NS_ENUM(NSInteger, PNTradePaymentMethodStatus) {
    PNTradePaymentMethodStatusUnusable = 0, ///< 不可用
    PNTradePaymentMethodStatusUsable = 1,   ///< 可用
};

/** 钱包首页功能区 */
typedef NS_ENUM(NSInteger, PNWalletFunctionType) {
    PNWalletFunctionType_ENTRANCE = 10, ///< 10 入口区
    PNWalletFunctionType_RIBBON = 11,   ///< 功能区
    PNWalletFunctionType_Setting = 12,  ///< 设置
};

/** 钱包首页列表Item配置 */
typedef NS_ENUM(NSInteger, PNWalletListItemType) {
    PNWalletListItemTypeDeposit = 1000,               ///< 入金
    PNWalletListItemTypeTransfer = 2000,              ///< 转账
    PNWalletListItemTypeInternationalTransfer = 3000, ///< 国际转账
    PNWalletListItemTypeBillPayment = 4000,           ///< 账单缴费
    PNWalletListItemTypeCoolcashWebsite = 5000,       ///< coolcash网点
    PNWalletListItemTypeMerchantServices = 6000,      ///< 商户服务
    PNWalletListItemTypeRedPacket = 7000,             ///< 红包
    PNWalletListItemTypeApartment = 8000,             ///< 公寓缴费
    PNWalletListItemTypeGuaratee = 9000,              ///< 担保交易

    PNWalletListItemTypeScan = 91001,           ///< 扫一扫
    PNWalletListItemTypePaymentCode = 91002,    ///< 付款码
    PNWalletListItemTypeCollectionCode = 91003, ///< 收款码

    PNWalletListItemTypeACCOUNTINFORMATION = 92001,             ///< 账号信息
    PNWalletListItemTypeMODIFY_PAYMENT_PASSWORD = 92002,        ///< 修改支付密码
    PNWalletListItemTypeWALLET_TRANSACTIONS = 92003,            ///< 钱包交易记录
    PNWalletListItemTypeINTERNATIONAL_TRANSFER_HISTORY = 92004, ///< 国际转账历史记录
    PNWalletListItemTypeTRADING_LIMIT = 92005,                  ///< 交易限额
    PNWalletListItemTypeAGREEMENT_TERMS = 92006,                ///< 协议及条款
    PNWalletListItemTypeCONTACT_US = 92007,                     ///< 联系我们
    PNWalletListItemTypeWALLET_DETAILS = 92008,                 ///< 钱包明细
    PNWalletListItemTypeMarketing = 92009,                      ///< 推广专员
    PNWalletListItemTypePinCodeModify = 92010,                  ///< 修改pinCode
    PNWalletListItemTypeCollectionCredit = 10000,               ///< 贷款
};

typedef NSString *PNCurrencyType NS_STRING_ENUM;
FOUNDATION_EXPORT PNCurrencyType const PNCurrencyTypeUSD; ///< 美元USD
FOUNDATION_EXPORT PNCurrencyType const PNCurrencyTypeKHR; ///< 瑞尔KHR
FOUNDATION_EXPORT PNCurrencyType const PNCurrencyTypeCNY; ///< 人民币CNY
///

/** 优惠券核销场景 */
typedef NSString *PNCouponTicketUsableScene NS_STRING_ENUM;
FOUNDATION_EXPORT PNCouponTicketUsableScene const PNCouponTicketUsableSceneStorePaying;     ///< 到店支付
FOUNDATION_EXPORT PNCouponTicketUsableScene const PNCouponTicketUsableScenePhoneRecharging; ///< 手机充值

/// 特殊的时间
typedef NSString *PNSPECIALTIME NS_STRING_ENUM;
FOUNDATION_EXPORT PNSPECIALTIME const PNSPECIALTIMEFOREVER; /// 永久有效

/// 费用类型
typedef NSString *PNChargeType NS_STRING_ENUM;
FOUNDATION_EXPORT PNChargeType const PNChargeTypeD; ///< 客户全部承担
FOUNDATION_EXPORT PNChargeType const PNChargeTypeC; ///< 商家全部承担
FOUNDATION_EXPORT PNChargeType const PNChargeTypeP; ///< 客户和商家按比例共同承担

/// 转账业务 枚举
typedef NSString *PNTransferType NS_STRING_ENUM;
FOUNDATION_EXPORT PNTransferType const PNTransferTypeToCoolcash;             ///< 1001 转账到账户
FOUNDATION_EXPORT PNTransferType const PNTransferTypePersonalToBaKong;       ///< 1002 个人转账到bakong
FOUNDATION_EXPORT PNTransferType const PNTransferTypePersonalToBank;         ///< 1003 个人转账到银行
FOUNDATION_EXPORT PNTransferType const PNTransferTypePersonalScanQRToBakong; ///< 1004 个人扫码支付到Bakong钱包
FOUNDATION_EXPORT PNTransferType const PNTransferTypeToInternational;        ///< 1005 国际转账
FOUNDATION_EXPORT PNTransferType const PNTransferTypeToPhone;                ///< 1010 转账汇款到手机号

FOUNDATION_EXPORT PNTransferType const PNTransferTypeBakongRefund; ///< 1050 bakong退款

// 借用
FOUNDATION_EXPORT PNTransferType const PNTransferTypeWitdraw; ///< 23 提现到银行卡

typedef NSString *PNWAlletAccountStatus NS_STRING_ENUM;
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusNormal;    ///< 正常
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusClose;     ///< 销户
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusFreeze;    ///< 冻结
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusLoss;      ///< 挂失
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusNotActive; ///< 未激活
FOUNDATION_EXPORT PNWAlletAccountStatus const PNWAlletAccountStatusNotSilent; ///< 沉默

/// 担保交易状态流转
typedef NSString *PNGuarateenActionStatus NS_STRING_ENUM;
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_BUILD;         ///< BUILD 下单
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_CONFIRM;       ///< CONFIRM 确认
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REJECT;        ///< REJECT 拒绝
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_COMPLETE;      ///< COMPLETE 确认完成交易
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_CANCEL;        ///< CANCEL 取消交易
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_APPLY;  ///< REFUND_APPLY 申请退款
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_CANCEL; ///< REFUND_CANCEL 取消退款
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_APPEAL; ///< REFUND_APPEAL 向平台申述
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_CANCEL; ///< APPEAL_CANCEL 取消申述
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_PASS;   ///< REFUND_PASS 退款通过
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_REFUND_REJECT; ///< REFUND_REJECT 退款拒绝
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_PASS;   ///< APPEAL_PASS 申诉通过
FOUNDATION_EXPORT PNGuarateenActionStatus const PNGuarateenActionStatus_APPEAL_REJECT; ///< APPEAL_REJECT 申诉驳回

/// 钱包明细 筛选类型
typedef NSString *PNWalletListFilterType NS_STRING_ENUM;
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_All;              ///< 00 所有
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Consumption;      ///< 01 消费
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Recharge;         ///< 02 充值
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Withdrawal;       ///< 03 提现
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Transfer;         ///< 04 转账
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Exchange;         ///< 05 汇兑
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Settlement;       ///< 06 结算
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Entry_Adjustment; ///< 07 分录调帐
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Self_Adjustment;  ///< 08:自主调帐
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Refund;           ///< 09 退款
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Marketing;        ///< 10 营销
FOUNDATION_EXPORT PNWalletListFilterType const PNWalletListFilterType_Credit;           ///< 11 贷款
#endif                                                                                  /* PNEnum_h */
