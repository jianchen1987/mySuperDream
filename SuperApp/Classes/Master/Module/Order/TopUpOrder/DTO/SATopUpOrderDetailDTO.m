//
//  SATopOrderDetailDTO.m
//  SuperApp
//
//  Created by Chaos on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailDTO.h"
#import "SATopUpOrderDetailRspModel.h"


@interface SATopUpOrderDetailDTO ()

/// 账单详情请求
@property (nonatomic, strong) CMNetworkRequest *topUpOrderDetailRequest;
/// 取消订单
@property (nonatomic, strong) CMNetworkRequest *cancelOrderRequest;
@end


@implementation SATopUpOrderDetailDTO

- (void)getTopUpOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^)(SATopUpOrderDetailRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/livelihood/app/bill/detail";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SATopUpOrderDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)userCancelTopUpOrder:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
