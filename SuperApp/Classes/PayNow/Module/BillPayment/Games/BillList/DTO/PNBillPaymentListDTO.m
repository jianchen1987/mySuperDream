//
//  PNBillPaymentListDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillPaymentListDTO.h"
#import "PNRspModel.h"


@implementation PNBillPaymentListDTO
- (void)queryBillPaymentListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize success:(void (^)(PNBillPaymentRspModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/billingInfoPage";
    request.requestParameter = @{@"pageNum": @(pageNum), @"pageSize": @(pageSize)};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNBillPaymentRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
