//
//  SAAppVersionViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppVersionViewModel.h"


@implementation SAAppVersionViewModel

- (void)getAppVersionInfoSuccess:(void (^)(SAAppVersionInfoRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/v1/get.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAAppVersionInfoRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
