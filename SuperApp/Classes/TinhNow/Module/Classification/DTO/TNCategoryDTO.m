//
//  TNCategoryDTO.m
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryDTO.h"
#import "TNFirstLevelCategoryModel.h"


@implementation TNCategoryDTO
- (void)queryCategorySuccess:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/showCategory/list";
    request.isNeedLogin = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNFirstLevelCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
