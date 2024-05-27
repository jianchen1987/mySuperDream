//
//  SAOrderDTO.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOrderDTO.h"
#import "SAQueryOrderInfoRspModel.h"


@implementation SAOrderDTO

- (void)queryOrderDetailsWithOrderNo:(NSString *_Nonnull)orderNo success:(void (^)(SAQueryOrderDetailsRspModel *_Nonnull rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/queryDetail";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAQueryOrderDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryOrderInfoWithOrderNo:(NSString *_Nullable)orderNo
                    outPayOrderNo:(NSString *_Nullable)outPayOrderNo
                          success:(void (^)(SAQueryOrderInfoRspModel *_Nonnull rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/queryOrderDetail";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(orderNo)) {
        params[@"aggregateOrderNo"] = orderNo;
    }

    if (HDIsStringNotEmpty(outPayOrderNo)) {
        params[@"outPayOrderNo"] = outPayOrderNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAQueryOrderInfoRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
