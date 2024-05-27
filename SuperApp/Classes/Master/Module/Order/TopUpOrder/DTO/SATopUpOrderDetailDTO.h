//
//  SATopOrderDetailDTO.h
//  SuperApp
//
//  Created by Chaos on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

@class SATopUpOrderDetailRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SATopUpOrderDetailDTO : SAViewModel

/// 获取充值订单详情
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getTopUpOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^)(SATopUpOrderDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消充值订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)userCancelTopUpOrder:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
