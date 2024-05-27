//
//  TNTransferDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferDTO.h"
#import "TNContactCustomerServiceModel.h"
#import "TNGuideRspModel.h"
#import "TNTransferRspModel.h"
#import "TNTransferSubmitModel.h"


@implementation TNTransferDTO

- (void)queryGuideDataByAdvId:(NSString *)advId Success:(void (^)(TNGuideRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/common/adv";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advId"] = advId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGuideRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryTransferDataByOrderNo:(NSString *)orderNo Success:(void (^)(TNTransferRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/refund/queryTransferPayment";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNTransferRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)saveTransferCredentiaDataBySubmitModel:(TNTransferSubmitModel *)submitModel Success:(void (^)(BOOL))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/refund/saveCredentialImages";

    NSMutableDictionary *params = [submitModel yy_modelToJSONObject];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(YES);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryContactCustomerServiceWithSuccess:(void (^)(TNContactCustomerServiceModel *_Nonnull model))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/customer/contact/listData";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNContactCustomerServiceModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
