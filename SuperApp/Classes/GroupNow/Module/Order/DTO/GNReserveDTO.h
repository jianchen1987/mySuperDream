//
//  GNReserveDTO.h
//  SuperApp
//
//  Created by wmz on 2022/9/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "GNReserveBuinessModel.h"
#import "GNReserveRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveDTO : GNModel
/// 获取门店营业时间
/// @param storeNo 门店No
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreNoBuinessTime:(nonnull NSString *)storeNo success:(nullable void (^)(GNReserveBuinessModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 订单预定
/// @param storeNo 门店No
/// @param orderNo 订单号
/// @param reservationTime 预约时间
/// @param reservationNum 预约人数
/// @param reservationUser 预约人名称
/// @param reservationPhone 预约手机号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderReservationWithStoreNo:(nonnull NSString *)storeNo
                            orderNo:(nonnull NSString *)orderNo
                    reservationTime:(nonnull NSString *)reservationTime
                     reservationNum:(NSInteger)reservationNum
                    reservationUser:(nonnull NSString *)reservationUser
                   reservationPhone:(nonnull NSString *)reservationPhone
                            success:(nullable CMNetworkSuccessBlock)successBlock
                            failure:(nullable CMNetworkFailureBlock)failureBlock;

///获取订单预定信息
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderReservationInfoWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNReserveRspModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
