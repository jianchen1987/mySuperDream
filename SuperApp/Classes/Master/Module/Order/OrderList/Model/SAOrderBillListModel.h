//
//  SAOrderBillListModel.h
//  SuperApp
//
//  Created by Tia on 2023/2/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderBillListItemModel : SAModel
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
/// 支付创建时间
@property (nonatomic, assign) NSTimeInterval createTime;
#pragma mark - 绑定属性
///< dd/MM/yyyy HH:mm
@property (nonatomic, copy, readonly) NSString *createTimeStr;

/// 退款金额
@property (nonatomic, strong) SAMoneyModel *refundAmount;
///< 支付流水号
@property (nonatomic, copy) NSString *payTransactionNo;
///< 退款流水号
@property (nonatomic, copy) NSString *refundTransactionNo;
/// 退款完成时间
@property (nonatomic, assign) NSTimeInterval finishTime;
#pragma mark - 绑定属性
///< dd/MM/yyyy HH:mm
@property (nonatomic, copy, readonly) NSString *finishTimeStr;

@end


@interface SAOrderBillListModel : SAModel
/// 支付数据
@property (nonatomic, strong) NSArray *payList;
/// 退款数据
@property (nonatomic, strong) NSArray *refundList;
/// 聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;

@end

NS_ASSUME_NONNULL_END
