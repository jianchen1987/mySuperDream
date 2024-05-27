//
//  SARefundDetailDTO.h
//  SuperApp
//
//  Created by Tia on 2022/5/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

@class SACommonRefundInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface SACommonRefundDetailDTO : SAViewModel

/// 获取退款订单详情
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)getRefundOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^)(NSArray<SACommonRefundInfoModel *> *))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
