//
//  TNGoodsDTO.m
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGoodsDTO.h"
#import "TNCategoryModel.h"
#import "TNGlobalData.h"
#import "TNGoodInfoModel.h"
#import "TNGoodsModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterModel.h"


@interface TNGoodsDTO ()

/// 商品列表查询
@property (nonatomic, strong) TNNetworkRequest *queryGoodsListRequest;
/// 商品专题列表查询
@property (nonatomic, strong) TNNetworkRequest *querySpecialNomalRequest;
/// 商品专题热销列表查询
@property (nonatomic, strong) TNNetworkRequest *querySpecialHotRequest;
/// 商品列表 热销
@property (strong, nonatomic) TNNetworkRequest *queryHotGoodsRequest;
@end


@implementation TNGoodsDTO

- (void)dealloc {
    HDLog(@"TNGoodsDTO  释放掉了");
    [_queryGoodsListRequest cancel];
    [_querySpecialHotRequest cancel];
    [_querySpecialNomalRequest cancel];
    [_queryHotGoodsRequest cancel];
}

- (void)queryGoodsListWithPageNo:(NSUInteger)pageNo
                        pageSize:(NSUInteger)pageSize
                     filterModel:(TNSearchSortFilterModel *)filterModel
                         success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
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
    if (HDIsStringNotEmpty(filterModel.storeNo)) {
        params[@"storeNo"] = filterModel.storeNo;
    }
    if (HDIsStringNotEmpty(filterModel.categoryId)) {
        params[@"categoryId"] = filterModel.categoryId;
    }
    if (HDIsStringNotEmpty(filterModel.brandId)) {
        params[@"brandId"] = filterModel.brandId;
    }
    if (!HDIsArrayEmpty(filterModel.categoryIds)) {
        params[@"categoryIds"] = filterModel.categoryIds;
        //        filterModel.categoryIds;
    }
    if (filterModel.productType != TNProductTypeAll) {
        params[@"productType"] = @(filterModel.productType);
    }
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = [SAUser shared].loginName;
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
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryRecommendGoodsListWithPageNo:(NSUInteger)pageNo
                                 pageSize:(NSUInteger)pageSize
                                  success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/index/recommend/list";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryHotGoodsListWithCategoryId:(NSString *)categoryId success:(void (^_Nullable)(NSArray<TNGoodsModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if (_queryHotGoodsRequest) {
        [_queryHotGoodsRequest cancel];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productCategoryId"] = categoryId;
    self.queryHotGoodsRequest.requestParameter = params;
    [self.queryHotGoodsRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNGoodsModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)querySpecailActivityListWithPageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   hotType:(NSInteger)hotType
                               filterModel:(TNSearchSortFilterModel *)filterModel
                                   success:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    if (_querySpecialNomalRequest) {
        [_querySpecialNomalRequest cancel];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNo);
    if (HDIsStringNotEmpty(filterModel.categoryId) && ![filterModel.categoryId isEqualToString:kCategotyRecommondItemName]) {
        params[@"categoryId"] = [filterModel.categoryId componentsSeparatedByString:@","];
    }
    params[@"specialId"] = filterModel.specialId;
    params[@"hot"] = @(hotType);
    if (HDIsStringNotEmpty(filterModel.sortType) && hotType != 1) { //专题热销商品列表 不需要筛选
        params[@"orderType"] = filterModel.sortType;
    }
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = [SAUser shared].loginName;
    }
    if (HDIsStringNotEmpty(filterModel.keyWord)) {
        params[@"key"] = filterModel.keyWord;
    }
    if (filterModel.rtnLabel) {
        params[@"rtnLabel"] = [NSNumber numberWithInt:filterModel.rtnLabel];
    }
    if (HDIsStringNotEmpty(filterModel.labelId)) {
        params[@"labelId"] = filterModel.labelId;
    }
    NSArray *allKeys = filterModel.filter.allKeys;
    for (NSString *key in allKeys) {
        NSString *value = (NSString *)[filterModel.filter objectForKey:key];
        if (HDIsStringNotEmpty(value)) {
            [params setObject:value forKey:key];
        }
    }
    self.querySpecialNomalRequest.requestParameter = params;
    [self.querySpecialNomalRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)querySpecailHotActivityListWithFilterModel:(TNSearchSortFilterModel *)filterModel success:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if (_querySpecialHotRequest) {
        [_querySpecialHotRequest cancel];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(18);
    params[@"pageNum"] = @(1);
    if (HDIsStringNotEmpty(filterModel.categoryId) && ![filterModel.categoryId isEqualToString:kCategotyRecommondItemName]) {
        params[@"categoryId"] = [filterModel.categoryId componentsSeparatedByString:@","];
    }
    params[@"specialId"] = filterModel.specialId;
    params[@"hot"] = @(1);
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = [SAUser shared].loginName;
    }
    if (filterModel.rtnLabel) {
        params[@"rtnLabel"] = [NSNumber numberWithInt:filterModel.rtnLabel];
    }
    if (HDIsStringNotEmpty(filterModel.hotLableId)) {
        params[@"labelId"] = filterModel.hotLableId;
    }
    self.querySpecialHotRequest.requestParameter = params;
    [self.querySpecialHotRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryGoodSkuDataWithProductId:(NSString *)productId success:(void (^)(TNGoodInfoModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/product/getAddPurchaseDetail";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = productId;
    if ([TNGlobalData shared].seller.isSeller) {
        params[@"sp"] = [TNGlobalData shared].seller.supplierId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGoodInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 搜索排行
- (void)searchRank:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/sosowdV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// type搜索词类型(1:搜索发现，2:搜索排行)，默认返回搜索发现
    params[@"type"] = @(2);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 搜索发现
- (void)searchFind:(void (^)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/sosowdV2";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// type搜索词类型(1:搜索发现，2:搜索排行)，默认返回搜索发现
    params[@"type"] = @(1);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
#pragma mark - lazy load
- (TNNetworkRequest *)queryGoodsListRequest {
    if (!_queryGoodsListRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/tapi/es/product/searchV3";
        //        @"/api/merchant/product/search";
        request.isNeedLogin = NO;
        request.requestTimeoutInterval = 15;
        _queryGoodsListRequest = request;
    }
    return _queryGoodsListRequest;
}

- (TNNetworkRequest *)queryHotGoodsRequest {
    if (!_queryHotGoodsRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/api/merchant/hotProduct/list";
        request.isNeedLogin = NO;
        _queryHotGoodsRequest = request;
    }
    return _queryHotGoodsRequest;
}
- (TNNetworkRequest *)querySpecialNomalRequest {
    if (!_querySpecialNomalRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/tapi/es/product/searchBySpecialV3";
        request.isNeedLogin = NO;
        _querySpecialNomalRequest = request;
    }
    return _querySpecialNomalRequest;
}
- (TNNetworkRequest *)querySpecialHotRequest {
    if (!_querySpecialHotRequest) {
        TNNetworkRequest *request = TNNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/tapi/es/product/searchBySpecialV3";
        request.isNeedLogin = NO;
        _querySpecialHotRequest = request;
    }
    return _querySpecialHotRequest;
}
@end
