//
//  SAQueryOrderInfoRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/5/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;


@interface SAQueryOrderInfoRspModel : SARspInfoModel

///< 二级商户号
@property (nonatomic, copy, nullable) NSString *merchantNo;
///< 门店号
@property (nonatomic, copy, nullable) NSString *storeId;
///< 业务线
@property (nonatomic, copy, nullable) NSString *businessLine;
///< 聚合单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
///< 应付金额
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;

@end

NS_ASSUME_NONNULL_END
