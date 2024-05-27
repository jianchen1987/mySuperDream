//
//  SAQueryOrderDetailsRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAQueryOrderDetailsRspModel : SARspInfoModel
///< 聚合单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
///< 实付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
///< 下单时间
@property (nonatomic, strong) NSNumber *createTime;
///< 支付时间
@property (nonatomic, strong) NSNumber *payTime;
///< 二级商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 一级商户号
@property (nonatomic, copy) NSString *firstMerchantNo;
///< storeNo
@property (nonatomic, copy) NSString *storeNo;
///< 门店名
@property (nonatomic, strong) SAInternationalizationModel *storeName;
///< 门店logo
@property (nonatomic, copy) NSString *storeLogo;
///< product image
@property (nonatomic, copy) NSString *showUrl;
///< product info
@property (nonatomic, strong) SAInternationalizationModel *remark;
///< 聚合订单状态
@property (nonatomic, assign) SAAggregateOrderState aggregateOrderState;
///< 聚合订单终态
@property (nonatomic, assign) SAAggregateOrderFinalState aggregateOrderFinalState;
///< 支付超时时间（分钟）
@property (nonatomic, assign) NSUInteger expireTime;
///< 操作列表
@property (nonatomic, strong) NSArray<NSString *> *operationList;
///< 中台支付订单号
@property (nonatomic, copy) NSString *payOrderNo;
///< 业务线
@property (nonatomic, copy) NSString *businessLine;

///< 支付营销减免
@property (nonatomic, strong) SAMoneyModel *payDiscountAmount;
///< 实付金额
@property (nonatomic, strong) SAMoneyModel *payActualPayAmount;
/// 支付类型
@property (nonatomic, assign) SAOrderPaymentType payType;

@end

NS_ASSUME_NONNULL_END
