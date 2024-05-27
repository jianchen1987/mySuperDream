//
//  TNWithdrawDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawDTO.h"
#import "TNWithdrawModel.h"


@implementation TNWithdrawDTO
- (void)queryWithDrawDetailWithObjId:(NSString *)objId success:(void (^)(TNWithdrawModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/commission_settlement_detail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"objId"] = objId;
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNWithdrawModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
