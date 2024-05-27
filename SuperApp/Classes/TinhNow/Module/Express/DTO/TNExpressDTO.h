//
//  TNExpressDTO.h
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

@class TNExpressDetailsRspModel;
@class TNExpressRiderModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressDTO : TNModel

/// 根据订单号查下物流
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getExpressDetailsWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(TNExpressDetailsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据运单号查询骑手信息
/// @param trackingNo 运单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getExpressRiderDataWithTrackingNo:(NSString *)trackingNo success:(void (^_Nullable)(TNExpressRiderModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
