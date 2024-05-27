//
//  SAOrderDTO.h
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAQueryOrderDetailsRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAQueryOrderInfoRspModel;


@interface SAOrderDTO : SAModel

/// 查询订单详情，中台订单详情，无业务信息
/// @param orderNo 聚合订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderDetailsWithOrderNo:(NSString *_Nonnull)orderNo success:(void (^)(SAQueryOrderDetailsRspModel *_Nonnull rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 查询订单相关信息
/// @param orderNo 聚合订单号
/// @param outPayOrderNo vipay订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderInfoWithOrderNo:(NSString *_Nullable)orderNo
                    outPayOrderNo:(NSString *_Nullable)outPayOrderNo
                          success:(void (^)(SAQueryOrderInfoRspModel *_Nonnull rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
