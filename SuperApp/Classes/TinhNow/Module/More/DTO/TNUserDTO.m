//
//  TNUserDTO.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNUserDTO.h"
#import "TNGetTinhNowUserDiffRspModel.h"


@implementation TNUserDTO

- (void)getTinhNowUserDifferenceWithUserNo:(NSString *)userNo success:(void (^_Nullable)(TNGetTinhNowUserDiffRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/more/distributor";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userNo"] = userNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGetTinhNowUserDiffRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)getTinhNowUserIsSellerSuccess:(void (^_Nullable)(TNGetTinhNowUserDiffRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/user/supplier/isSupplier";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = [SAUser shared].loginName;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGetTinhNowUserDiffRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
