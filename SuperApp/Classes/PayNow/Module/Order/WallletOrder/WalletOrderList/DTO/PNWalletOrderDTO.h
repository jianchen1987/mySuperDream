//
//  PNWalletOrderDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNWalletListRspModel;
@class PNWalletOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletOrderDTO : PNModel
/// 获取钱包明细列表
- (void)getWalletOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNWalletListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取钱包明细 - 详情
- (void)getWalletOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(PNWalletOrderDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
