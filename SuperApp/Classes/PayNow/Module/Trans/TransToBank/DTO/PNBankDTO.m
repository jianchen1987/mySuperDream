//
//  PNBankDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBankDTO.h"
#import "PNRspModel.h"


@implementation PNBankDTO

/// 获取银行列表
- (void)getBankList:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;

    request.requestURI = @"/merchant-agentcash/app/mer/agent/bakong/bankListWithUrl.do";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel.data);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
