//
//  TNMyCustomerDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerDTO.h"
#import "TNNetworkRequest.h"


@implementation TNMyCustomerDTO

// 我的客户 列表
- (void)queryMyCustomerListWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize success:(void (^)(TNMyCustomerRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/supplier_user";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMyCustomerRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
