//
//  TNWithdrawBindDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawBindDTO.h"


@implementation TNWithdrawBindDTO
- (void)queryPaymentWaySuccess:(void (^)(NSArray<TNWithdrawBindModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/payment_way";
    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[TNWithdrawBindModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryBindPayAcountSuccess:(void (^)(TNWithdrawBindRequestModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/withdrawal_type";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNWithdrawBindRequestModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)postWithDrawApplyWithModel:(TNWithdrawBindRequestModel *)requestModel success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/supplierCommission/withdrawal";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!HDIsObjectNil(requestModel.amount)) {
        params[@"amount"] = requestModel.amount.amount; //更新amount
    }
    params[@"operatorNo"] = HDIsStringNotEmpty([SAUser shared].operatorNo) ? [SAUser shared].operatorNo : @"";
    if (HDIsStringNotEmpty(requestModel.settlementType)) {
        params[@"settlementType"] = requestModel.settlementType;
    }
    if (HDIsStringNotEmpty(requestModel.paymentType)) {
        params[@"paymentType"] = requestModel.paymentType;
    }
    if (HDIsStringNotEmpty(requestModel.account)) {
        params[@"account"] = requestModel.account;
    }
    if (HDIsStringNotEmpty(requestModel.accountHolder)) {
        params[@"accountHolder"] = requestModel.accountHolder;
    }
    if (HDIsStringNotEmpty(requestModel.companyName)) {
        params[@"companyName"] = requestModel.companyName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)postWithDrawApplyWithParamers:(NSDictionary *)paramers success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/supplierCommission/withdrawal";
    request.requestParameter = paramers;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
