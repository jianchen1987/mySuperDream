//
//  SAPaymentDTO.m
//  SuperApp
//
//  Created by seeu on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"


@implementation SAPaymentDTO

- (void)queryOrderPaymentStateWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/getPayStatus";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAQueryPaymentStateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
