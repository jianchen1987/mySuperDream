//
//  SACouponRedemptionDTO.h
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACouponRedemptionRspModel;


@interface SACouponRedemptionDTO : SAModel

/// 自动领券
/// @param orderNo 订单号
/// @param businessLine 业务线类型
/// @param channel 默认写死 @”111“
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)autoCouponRedemptionWithOrderNo:(NSString *)orderNo
                           businessLine:(SAClientType)businessLine
                                channel:(NSString *)channel
                              riskToken:(NSString *_Nullable)riskToken
                                success:(void (^_Nullable)(SACouponRedemptionRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
