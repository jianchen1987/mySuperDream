//
//  WMProductSearchDTO.m
//  SuperApp
//
//  Created by Chaos on 2020/11/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductSearchDTO.h"


@implementation WMProductSearchDTO

- (CMNetworkRequest *)searchProductInStore:(NSString *)storeNo
                                   keyword:(NSString *)keyword
                                   pageNum:(NSUInteger)pageNum
                                   success:(void (^)(WMProductSearchRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-product/app/user/product/v2/search.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"pageNum"] = @(pageNum);
    params[@"pageSize"] = @10;
    params[@"keyword"] = keyword;
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMProductSearchRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return request;
}

@end
