//
//  PNDepositDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNDepositDTO.h"
#import "PNRspModel.h"
#import "PNDepositRspModel.h"


@implementation PNDepositDTO

/// 用户入金向导
- (void)queryDepositGuide:(void (^)(PNDepositRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/usercenter/guide";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNDepositRspModel *depositRspModel = [PNDepositRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(depositRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
