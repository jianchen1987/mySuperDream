//
//  TNStoreDTO.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreDTO.h"
#import "TNCategoryModel.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNStoreInfoRspModel.h"
#import "TNStoreSceneRspModel.h"


@implementation TNStoreDTO

- (void)queryStoreInfoWithStoreNo:(NSString *)storeNo
                       operatorNo:(NSString *)operatorNo
                          success:(void (^_Nullable)(TNStoreInfoRspModel *rspModel))successBlock
                          failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/store/detail";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"operatorNo"] = operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNStoreInfoRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addStoreFavoritesWithStoreNo:(NSString *)storeNo
                           storeType:(NSInteger)storeType
                          supplierId:(nonnull NSString *)supplierId
                             success:(void (^_Nullable)(void))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/store/add";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeType"] = @(storeType);
    if (HDIsStringNotEmpty(storeNo)) {
        params[@"storeNo"] = storeNo;
    }
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"supplierId"] = supplierId;
    }
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)cancelStoreFavoriteWithStoreNo:(NSString *)storeNo
                             storeType:(NSInteger)storeType
                            supplierId:(nonnull NSString *)supplierId
                               success:(void (^_Nullable)(void))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/store/delete";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeType"] = @(storeType);
    if (HDIsStringNotEmpty(storeNo)) {
        params[@"storeNo"] = storeNo;
    }
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"supplierId"] = supplierId;
    }
    params[@"storeNo"] = storeNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryStoreRecommendCategoryWithStoreNo:(NSString *)storeNo success:(void (^)(NSArray<TNCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/es/product/searchCategoryBySpecial";
    //    @"/api/merchant/storeProductCategory/list-recommend";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"recommend"] = @(true);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryStoreRealSceneWithStoreNo:(NSString *)storeNo pageNum:(NSInteger)pageNum success:(void (^)(TNStoreSceneRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/store/live/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"pageNum"] = @(pageNum);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNStoreSceneRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryStoreAllCategoryWithStoreNo:(NSString *)storeNo success:(void (^)(NSArray<TNFirstLevelCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/es/product/searchCategoryBySpecial";
    //    @"/api/merchant/storeProductCategory/list-business";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNFirstLevelCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
