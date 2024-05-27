//
//  WMRefundDetailDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMRefundDetailDTO : WMModel

/// 查询订单详情
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryOrderDetailInfoWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(WMOrderDetailModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
