//
//  TNOrderDetailsMidPartModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNOrderOperatorModel;
@class SAMoneyModel;

typedef NSString *TNOrderOperationType NS_STRING_ENUM;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypePayNow;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeRefundDetail;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeReceipt;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeAddReview;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeCancelOrder;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeExchange;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeShowReview;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeRebuy;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeApplyRefund;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeCancelApplyRefund;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeTransferPayments;
FOUNDATION_EXPORT TNOrderOperationType const TNOrderOperationTypeNearbyBuy;


@interface TNOrderDetailsMidPartModel : TNModel

/// 支付订单号？
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval expireTime;
/// 支付渠道
@property (nonatomic, copy) NSString *payChannel;
/// 操作列表
@property (nonatomic, strong) NSArray<TNOrderOperatorModel *> *operationList;
/// 支付方式
@property (nonatomic, assign) NSUInteger paymentMethod;
/// 操作员号
@property (nonatomic, copy) NSString *opeartorNo;
/// 订单时间
@property (nonatomic, assign) NSTimeInterval orderTimeStamp;
/// 业务线
@property (nonatomic, copy) NSString *businessLine;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
/// 创建时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// 业务 订单号
@property (nonatomic, copy) NSString *businessOrderId;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 聚合订单状态
@property (nonatomic, assign) NSUInteger aggregateOrderState;
/// 金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 支付营销减免金额
@property (nonatomic, strong) SAMoneyModel *payDiscountAmount;
///< 支付实付金额
@property (nonatomic, strong) SAMoneyModel *payActualPayAmount;
/// 更新时间
@property (nonatomic, assign) NSTimeInterval updateTime;

@end

NS_ASSUME_NONNULL_END
