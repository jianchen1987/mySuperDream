//
//  PNPaymentOrderDetailsViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNWaterBillModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentOrderDetailsViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

/// 聚合单号
@property (nonatomic, copy) NSString *orderNo;
/// 钱包订单号
@property (nonatomic, copy) NSString *tradeNo;

@property (nonatomic, strong) PNWaterBillModel *billModel;

/// 查询账单详情
- (void)queryBillDetail;

/// 关闭业务账单订单
- (void)closePaymentOrder;
@end

NS_ASSUME_NONNULL_END
