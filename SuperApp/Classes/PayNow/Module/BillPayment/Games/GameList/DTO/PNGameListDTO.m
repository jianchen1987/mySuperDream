//
//  PNGameListDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameListDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNGameRspModel.h"
#import "PNRspModel.h"


@implementation PNGameListDTO
- (void)queryGameListSuccess:(void (^)(PNGameRspModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/categoryInquiry";
    request.requestParameter = @{@"billerCode": @"2212"};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGameRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
