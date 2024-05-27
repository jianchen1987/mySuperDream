//
//  PNCreditDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNCreditDTO.h"
#import "PNRspModel.h"
#import "PNCreditRspModel.h"
#import "SAUser.h"


@implementation PNCreditDTO

/// 钱包开通校验 & 是否授信额度
- (void)checkCreditAuthorization:(void (^)(PNCreditRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/usercenter/loan/check/status.do";

    request.requestParameter = @{@"loginName": SAUser.shared.loginName ?: @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNCreditRspModel *model = [PNCreditRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 授信额度
- (void)creditAuthorization:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/usercenter/loan/authorization.do";
    request.isNeedLogin = YES;

    request.requestParameter = @{@"loginName": SAUser.shared.loginName ?: @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
