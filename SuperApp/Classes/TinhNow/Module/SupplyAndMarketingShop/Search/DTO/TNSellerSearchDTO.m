//
//  TNSellerSearchDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchDTO.h"
#import "TNGoodsModel.h"
#import "TNSellerProductRspModel.h"
#import "TNSellerStoreRspModel.h"


@interface TNSellerSearchDTO ()
///
@property (nonatomic, strong) TNNetworkRequest *queryGoodsListRequest;
@property (nonatomic, strong) TNNetworkRequest *queryMicroShopRequest;
@end


@implementation TNSellerSearchDTO
- (void)queryProductCenterProductsWithPageNo:(NSUInteger)pageNo
                                    pageSize:(NSUInteger)pageSize
                                 filterModel:(TNSearchSortFilterModel *)filterModel
                                     success:(void (^)(TNSellerProductRspModel *_Nonnull))successBlock
                                     failure:(CMNetworkFailureBlock)failureBlock {
    if (_queryGoodsListRequest) {
        [_queryGoodsListRequest cancel];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    if (HDIsStringNotEmpty(filterModel.sortType)) {
        params[@"orderType"] = filterModel.sortType;
    }
    if (HDIsStringNotEmpty(filterModel.keyWord)) {
        params[@"key"] = filterModel.keyWord;
    }
    if (HDIsStringNotEmpty(filterModel.sp)) {
        params[@"sp"] = filterModel.sp;
    }
    if (HDIsStringNotEmpty(filterModel.categoryId)) {
        params[@"categoryId"] = filterModel.categoryId;
    }
    if (HDIsStringNotEmpty(filterModel.storeNo)) {
        params[@"storeNo"] = filterModel.storeNo;
    }
    NSArray *allKeys = filterModel.filter.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = (NSString *)[filterModel.filter objectForKey:key];
        if (HDIsStringNotEmpty(value)) {
            [params setObject:value forKey:key];
        }
    }
    self.queryGoodsListRequest.requestParameter = params;
    [self.queryGoodsListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSellerProductRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryProductCenterStoresWithPageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   keyWord:(NSString *)keyword
                                   success:(void (^)(TNSellerStoreRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/searchStoreForSupplier";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"key"] = keyword;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSellerStoreRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryMicroShopProductsWithPageNo:(NSUInteger)pageNo
                                pageSize:(NSUInteger)pageSize
                             filterModel:(TNSearchSortFilterModel *)filterModel
                                 success:(void (^)(TNSellerProductRspModel *_Nonnull))successBlock
                                 failure:(CMNetworkFailureBlock)failureBlock {
    if (_queryMicroShopRequest) {
        [_queryMicroShopRequest cancel];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    if (HDIsStringNotEmpty(filterModel.sortType)) {
        params[@"orderType"] = filterModel.sortType;
    }
    if (HDIsStringNotEmpty(filterModel.keyWord)) {
        params[@"key"] = filterModel.keyWord;
    }
    if (HDIsStringNotEmpty(filterModel.sp)) {
        params[@"sp"] = filterModel.sp;
    }
    if (HDIsStringNotEmpty(filterModel.categoryId)) {
        params[@"categoryId"] = filterModel.categoryId;
    }
    NSArray *allKeys = filterModel.filter.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = (NSString *)[filterModel.filter objectForKey:key];
        if (HDIsStringNotEmpty(value)) {
            [params setObject:value forKey:key];
        }
    }
    if (filterModel.searchType != TNMicroShopProductSearchTypeNone) {
        params[@"type"] = [NSNumber numberWithUnsignedInteger:filterModel.searchType];
    }
    self.queryMicroShopRequest.requestParameter = params;
    [self.queryMicroShopRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNSellerProductRspModel *sellerRspModel = [TNSellerProductRspModel yy_modelWithJSON:rspModel.data];
        if (filterModel.searchType == TNMicroShopProductSearchTypeUser && !HDIsArrayEmpty(sellerRspModel.list)) {
            NSMutableArray *arr = [NSMutableArray array];
            for (TNSellerProductModel *model in sellerRspModel.list) {
                TNGoodsModel *goodModel = [TNGoodsModel modelWithSellerProductModel:model];
                [arr addObject:goodModel];
            }
            sellerRspModel.list = arr;
        }
        !successBlock ?: successBlock(sellerRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (TNNetworkRequest *)queryGoodsListRequest {
    if (!_queryGoodsListRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/tapi/es/product/searchProductForSupplier";
        request.requestTimeoutInterval = 15;
        _queryGoodsListRequest = request;
    }
    return _queryGoodsListRequest;
}
- (TNNetworkRequest *)queryMicroShopRequest {
    if (!_queryMicroShopRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/tapi/es/product/searchSalerProduct";
        request.requestTimeoutInterval = 15;
        _queryMicroShopRequest = request;
    }
    return _queryMicroShopRequest;
}
@end
