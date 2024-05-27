//
//  WMOrderDetailOrderInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderDetailOperationEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;


@interface WMOrderDetailOrderInfoModel : WMModel
/// 付款类型
@property (nonatomic, assign) SAOrderPaymentType paymentMethod;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 支付订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 订单时间时间戳
@property (nonatomic, copy) NSString *orderTimeStamp;
/// 待支付过期时间（单位：分）
@property (nonatomic, assign) double expireTime;
/// 可进行操作列表
@property (nonatomic, copy) NSArray<WMOrderDetailOperationEventModel *> *operationList;

///< 业务应付
@property (nonatomic, strong) SAMoneyModel *payableAmount;
///< 业务实付（应付 - 业务侧营销）
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
///< 支付实付（业务实付 - 支付营销）
@property (nonatomic, strong) SAMoneyModel *payActualPayAmount;
///< 支付营销减免
@property (nonatomic, strong) SAMoneyModel *payDiscountAmount;

@end

NS_ASSUME_NONNULL_END
