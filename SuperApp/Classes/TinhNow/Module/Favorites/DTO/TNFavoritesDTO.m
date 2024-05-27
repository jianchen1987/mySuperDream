//
//  TNFavoritesDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNFavoritesDTO.h"
#import "TNGoodFavoritesRspModel.h"
#import "TNStoreFavoritesRspModel.h"


@interface TNFavoritesDTO ()
@end


@implementation TNFavoritesDTO

- (void)queryGoodFavoritesListWithPageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^)(TNGoodFavoritesRspModel *_Nonnull))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/user/productFavorite/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [SAUser shared].loginName;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGoodFavoritesRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryStoreFavoritesListWithPageNum:(NSUInteger)pageNum
                                  pageSize:(NSUInteger)pageSize
                                   success:(void (^)(TNStoreFavoritesRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/user/storeFavorite/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [SAUser shared].loginName;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNStoreFavoritesRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)removeGoodFavoriteByID:(NSString *)favoriteId supplierId:(nonnull NSString *)supplierId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/user/productFavorite/remove";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productFavoriteId"] = favoriteId;
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"sp"] = supplierId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)removeStoreFavoriteByID:(NSString *)favoriteId
                      storeType:(NSInteger)storeType
                     supplierId:(nonnull NSString *)supplierId
                        success:(void (^_Nullable)(void))successBlock
                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/user/storeFavorite/remove";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [SAUser shared].loginName;
    params[@"storeType"] = @(storeType);
    if (HDIsStringNotEmpty(favoriteId)) {
        params[@"storeFavoriteId"] = favoriteId;
    }
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"supplierId"] = supplierId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
