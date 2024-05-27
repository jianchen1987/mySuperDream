//
//  PNGuarateenDetailDTO.m
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailDTO.h"
#import "PNGuarateenBuildOrderPaymentRspModel.h"
#import "PNGuarateenComfirmPayRspModel.h"
#import "PNGuarateenDetailModel.h"
#import "PNRspModel.h"


@implementation PNGuarateenDetailDTO
/// 订单详情接口
- (void)getGuarateenRecordDetail:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/secured-txn/app/order/detail";

    request.requestParameter = @{@"orderNo": orderNo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGuarateenDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 订单状态流转接口
- (void)orderAction:(NSString *)orderNo
             action:(NSString *)action
      operationDesc:(NSString *)operationDesc
            success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
            failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/secured-txn/app/order/action";

    request.requestParameter = @{
        @"orderNo": orderNo,
        @"action": action,
        @"operationDesc": operationDesc,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 付款接口 - 获取汇率
- (void)buildOrderPayment:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenBuildOrderPaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/secured-txn/pay/buildPayment";

    request.requestParameter = @{
        @"orderNo": orderNo,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGuarateenBuildOrderPaymentRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 确认付款接口
- (void)comfirmOrderPayment:(NSString *)orderNo success:(void (^_Nullable)(PNGuarateenComfirmPayRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/secured-txn/pay/confirmPayment";

    request.requestParameter = @{
        @"orderNo": orderNo,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGuarateenComfirmPayRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
