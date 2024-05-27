//
//  SAUserViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUserViewModel.h"


@implementation SAUserViewModel

- (void)logoutSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = NSMutableDictionary.new;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/operator/login/logout.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getUserInfoWithOperatorNo:(NSString *)operatorNo success:(void (^)(SAGetUserInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        !failureBlock ?: failureBlock(nil, CMResponseErrorTypeLoginExpired, nil);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = operatorNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/info/get.do";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SAGetUserInfoRspModel *userRspModel = [SAGetUserInfoRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(userRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getMemberLevelInfoWithOperatorNo:(NSString *)operatorNo success:(void (^)(SAMemberLevelInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/point/member/search/newMyPrivilege.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAMemberLevelInfoRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
