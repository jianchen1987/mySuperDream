//
//  SACouponRedemptionDTO.m
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionDTO.h"
#import "SACouponRedemptionRspModel.h"


@implementation SACouponRedemptionDTO

- (void)autoCouponRedemptionWithOrderNo:(NSString *)orderNo
                           businessLine:(SAClientType)businessLine
                                channel:(NSString *)channel
                              riskToken:(NSString *_Nullable)riskToken
                                success:(void (^)(SACouponRedemptionRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/channel/unified/receive.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    params[@"businessLineEnum"] = businessLine;
    params[@"channel"] = channel;
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SACouponRedemptionRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
