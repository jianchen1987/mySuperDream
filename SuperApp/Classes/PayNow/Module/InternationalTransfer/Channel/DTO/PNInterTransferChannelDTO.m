//
//  PNInterTransferChannelDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferChannelDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNInterTransferChannelModel.h"
#import "PNInterTransferQueryAllRateRspModel.h"
#import "PNNetworkRequest.h"
#import "PNRspModel.h"


@implementation PNInterTransferChannelDTO

/// 获取渠道
- (void)getChannelListSuccess:(void (^)(NSArray<PNInterTransferChannelModel *> *array))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/user/international/transfer/config.do";
    request.isNeedLogin = YES;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[PNInterTransferChannelModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询thunes渠道的所有汇率
- (void)getAllRateSuccess:(void (^)(PNInterTransferQueryAllRateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/thunes/rate-fee/queryAllRate";
    request.isNeedLogin = YES;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        !successBlock ?: successBlock([PNInterTransferQueryAllRateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
