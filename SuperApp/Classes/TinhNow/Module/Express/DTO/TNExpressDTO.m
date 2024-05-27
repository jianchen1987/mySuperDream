//
//  TNExpressDTO.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressDTO.h"
#import "TNExpressDetailsModel.h"
#import "TNExpressRiderModel.h"


@implementation TNExpressDTO

- (void)getExpressDetailsWithOrderNo:(NSString *)orderNo success:(void (^)(TNExpressDetailsRspModel *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/express/query/trace";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizOrderId"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNExpressDetailsRspModel *expressRspModel = [TNExpressDetailsRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(expressRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)getExpressRiderDataWithTrackingNo:(NSString *)trackingNo success:(void (^)(TNExpressRiderModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/getDeliveryDetail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"param"] = trackingNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNExpressRiderModel *expressRspModel = [TNExpressRiderModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(expressRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
