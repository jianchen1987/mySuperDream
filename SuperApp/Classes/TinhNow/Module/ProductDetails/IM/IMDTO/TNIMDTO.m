//
//  TNIMDTO.m
//  SuperApp
//
//  Created by xixi on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIMDTO.h"


@implementation TNIMDTO

/// 获取商户客服列表
- (void)queryCustomerList:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNIMRspModel *> *rspModelArray))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/tinhnow/merchant/app/store/customerList";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<TNIMRspModel *> *array = [NSArray yy_modelArrayWithClass:TNIMRspModel.class json:rspModel.data];
        !successBlock ?: successBlock(array);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
