//
//  SASearchDTO.m
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchDTO.h"


@implementation SASearchDTO

- (void)queryHotwordWithSuccess:(void (^)(SARspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/hotword/list";
    request.shouldAlertErrorMsgExceptSpecCode = false;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @"1";
    params[@"pageSize"] = @"100";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryThematicWithSuccess:(void (^)(SARspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/thematic/list";
    request.shouldAlertErrorMsgExceptSpecCode = false;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @"1";
    params[@"pageSize"] = @"8";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
