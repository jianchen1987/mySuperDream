//
//  PNMSOrderDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSBillListRspModel;
@class HDUserBillDetailRspModel;
@class PNMSFilterStoreOperatorDataModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSOrderDTO : PNModel

/// 获取商户账单列表
- (void)getMSTransOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNMSBillListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取交易详情/订单详情
- (void)getMSTransOrderDetailWithtTadeNo:(NSString *)tradeNo
                              merchantNo:(NSString *)merchantNo
                               tradeType:(PNTransType)tradeType
                             needBalance:(BOOL)needBalance
                                 success:(void (^_Nullable)(HDUserBillDetailRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询所有门店和操作员 - 筛选用
- (void)getFilterData:(void (^_Nullable)(PNMSFilterStoreOperatorDataModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
