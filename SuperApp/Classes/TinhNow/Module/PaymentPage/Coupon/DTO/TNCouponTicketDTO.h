//
//  TNCouponDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCouponParamsModel.h"
#import "TNModel.h"
#import "WMOrderSubmitCouponRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCouponTicketDTO : TNModel

/// 获取订单可用的优惠券
/// @param paramsModel 请求模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getCouponByParamsModel:(TNCouponParamsModel *)paramsModel
                      pageSize:(NSUInteger)pageSize
                       pageNum:(NSUInteger)pageNum
                       Success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
