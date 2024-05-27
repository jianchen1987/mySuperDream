//
//  WMOrderResultViewModel.h
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SACouponRedemptionRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderResultViewModel : SAViewModel

/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 领券结果
@property (nonatomic, strong, readonly) SACouponRedemptionRspModel *couponRspModel;

/// 支付成功自动领券
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)autoCouponRedemptionSuccess:(void (^_Nullable)(SACouponRedemptionRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
