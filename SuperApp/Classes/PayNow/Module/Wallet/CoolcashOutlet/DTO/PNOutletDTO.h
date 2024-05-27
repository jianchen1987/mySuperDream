//
//  PNOutletDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOutletDTO : PNModel

/// 附近CoolCash网点
/// @param longitude 经度
/// @param latitude 纬度
/// @param distance 查询范围（km）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)searchNearCoolCashMerchantWithLongitude:(double)longitude
                                       latitude:(double)latitude
                                       distance:(NSInteger)distance
                                   successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                                        failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
