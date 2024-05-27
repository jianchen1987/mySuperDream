//
//  TNProductCenterDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductCenterDTO.h"
#import "TNFirstLevelCategoryModel.h"


@implementation TNProductCenterDTO
- (void)querySellerAllCategorySuccess:(void (^)(NSArray<TNFirstLevelCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/product/productCategory/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"locale"] = @"zh_CN";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNFirstLevelCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
