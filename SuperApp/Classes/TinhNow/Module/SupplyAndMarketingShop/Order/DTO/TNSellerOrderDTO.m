//
//  TNSellerOrderDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderDTO.h"


@implementation TNSellerOrderDTO
- (void)querySellerOrderListWithPageNo:(NSInteger)pageNo
                              pageSize:(NSInteger)pageSize
                                status:(TNSellerOrderStatus)status
                               success:(void (^)(TNSellerOrderRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/supplier/orderList";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageNumber"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    if (status >= 0) {
        params[@"status"] = [NSNumber numberWithUnsignedInteger:status];
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSellerOrderRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
