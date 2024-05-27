//
//  SARefundDetailDTO.m
//  SuperApp
//
//  Created by Tia on 2022/5/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundDetailDTO.h"
#import "SACommonRefundInfoModel.h"


@implementation SACommonRefundDetailDTO

+ (void)getRefundOrderDetailWithOrderNo:(NSString *)orderNo success:(nonnull void (^)(NSArray<SACommonRefundInfoModel *> *))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/refund/detail/v2";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SACommonRefundInfoModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
