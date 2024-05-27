//
//  PNPaymentBuildModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

// 来自
typedef NS_ENUM(NSInteger, PNPaymentBuildFromType) {
    PNPaymentBuildFromType_Default = 0,          ///< 默认 【钱包支付模块的转账业务】
    PNPaymentBuildFromType_MerchantWithdraw = 1, ///< 商户提现模块 【商户的交易模块】
    PNPaymentBuildFromType_Middle = 2,           ///< 中台 【中台收银台】
};

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentBuildWithdrawExtendModel : PNModel
/// 银行账号
@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, copy) NSString *accountName;
/// 银行名称
@property (nonatomic, copy) NSString *bankName;
/// 银行code
@property (nonatomic, copy) NSString *participantCode;
/// 提现金额
@property (nonatomic, strong) SAMoneyModel *caseInAmount;

@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *operatorNo;

@end


@interface PNPaymentBuildModel : PNModel
/// 交易单号
@property (nonatomic, copy) NSString *tradeNo;

@property (nonatomic, assign) PNTradeSubTradeType subTradeType;

/// 来源哪里
@property (nonatomic, assign) PNPaymentBuildFromType fromType;

/// 是否需要展示统一的 支付结果页 【默认展示】
@property (nonatomic, assign) BOOL isShowUnifyPayResult;

/// 中台收银台过来 需要传这个值
@property (nonatomic, copy) NSString *payWay;

/// 下面的属性是 扫码需要携带信息 扫码需要携带信息 扫码需要携带信息
/// 二维码内容
@property (nonatomic, copy) NSString *qrData;

/// 下面的属性是 提现到银行 提现到银行 提现到银行 提现到银行
@property (nonatomic, strong) PNPaymentBuildWithdrawExtendModel *extendWithdrawModel;
@end

NS_ASSUME_NONNULL_END
