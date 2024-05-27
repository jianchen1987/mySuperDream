//
//  SAAppAuthorizeDTO.m
//  SuperApp
//
//  Created by Tia on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAppAuthorizeDTO.h"


@implementation SAAppAuthorizeDTO

- (void)submitWithAuthorize:(NSInteger)authorize success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/channel/task/wownow/lottery/authorize";
    request.isNeedLogin = true;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"authorizeType"] = @(authorize);

    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
//        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
