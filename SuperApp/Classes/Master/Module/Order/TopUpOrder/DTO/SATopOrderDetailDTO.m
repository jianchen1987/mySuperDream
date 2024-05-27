//
//  SATopOrderDetailDTO.m
//  SuperApp
//
//  Created by Chaos on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailDTO.h"
#import "SATopUpOrderDetailRspModel.h"


@interface SATopUpOrderDetailDTO ()

/// 账单详情请求
@property (nonatomic, strong) CMNetworkRequest *topUpOrderDetailRequest;

@end


@implementation SATopUpOrderDetailDTO

- (CMNetworkRequest *)getTopUpOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^)(SATopUpOrderDetailRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    self.topUpOrderDetailRequest.requestParameter = params;
    [self.topUpOrderDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SATopUpOrderDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.topUpOrderDetailRequest;
}

- (CMNetworkRequest *)topUpOrderDetailRequest {
    if (!_topUpOrderDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/groupPurchase/order/info";

        _topUpOrderDetailRequest = request;
    }
    return _topUpOrderDetailRequest;
}

@end
