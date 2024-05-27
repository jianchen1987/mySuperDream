//
//  WMTopUpOrderDetailModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAModel.h"

typedef NS_ENUM(NSUInteger, HDTopUpOrderStatus) {
    HDTopUpOrderStatusUnknown = 0,     ///< 未知
    HDTopUpOrderStatusCreated = 10,    ///< 已创建
    HDTopUpOrderStatusProcessing = 11, ///< 处理中
    HDTopUpOrderStatusSuccess = 12,    ///< 成功
    HDTopUpOrderStatusFailed = 13,     ///< 失败
    HDTopUpOrderStatusClosed = 14,     ///< 交易关闭
};

@class SAMoneyModel, SAOrderRefundInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface SATopUpOrderDetailRspModel : SAModel

/// 交易状态
@property (nonatomic, assign) HDTopUpOrderStatus orderStatus;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *payeeAmt;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *orderAmt;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 过期时间（分钟）
@property (nonatomic, assign) double expirationTime;
/// 订单编号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 充值时间
@property (nonatomic, copy) NSString *transactionTime;
/// 门店照片
@property (nonatomic, copy) NSString *logoUrl;
/// 充值号码
@property (nonatomic, copy) NSString *topUpNumber;
/// 退款信息
@property (nonatomic, strong) SAOrderRefundInfoModel *refundInfo;
@property (nonatomic, copy) NSString *outPayOrderNo; ///< 支付订单号

@end

NS_ASSUME_NONNULL_END
