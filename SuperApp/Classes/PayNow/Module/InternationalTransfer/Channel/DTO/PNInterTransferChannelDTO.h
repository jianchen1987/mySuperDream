//
//  PNInterTransferChannelDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNInterTransferChannelModel;
@class PNInterTransferQueryAllRateRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferChannelDTO : PNModel

/// 获取渠道
- (void)getChannelListSuccess:(void (^)(NSArray<PNInterTransferChannelModel *> *array))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 查询thunes渠道的所有汇率
/// 查询thunes渠道的所有汇率
- (void)getAllRateSuccess:(void (^)(PNInterTransferQueryAllRateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
