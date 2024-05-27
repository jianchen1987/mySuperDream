//
//  PNGuarateenDetailDTO.h
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNGuarateenDetailModel;
@class PNGuarateenBuildOrderPaymentRspModel;
@class PNGuarateenComfirmPayRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenDetailDTO : PNModel
/// 订单详情接口
- (void)getGuarateenRecordDetail:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 订单状态流转接口
- (void)orderAction:(NSString *)orderNo
             action:(NSString *)action
      operationDesc:(NSString *)operationDesc
            success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
            failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 付款接口 - 获取汇率
- (void)buildOrderPayment:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenBuildOrderPaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 确认付款接口
- (void)comfirmOrderPayment:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenComfirmPayRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
