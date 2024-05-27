//
//  SAAggregateSearchViewModel.m
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchViewModel.h"
#import "GNStorePagingRspModel.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "TNQueryGoodsRspModel.h"
#import "WMSearchStoreRspModel.h"


@implementation SAAggregateSearchViewModel

- (void)searchWithKeyWord:(NSString *_Nonnull)keyWord
             businessLine:(SAClientType)business
                  address:(SAAddressModel *)address
                  pageNum:(NSUInteger)pageNum
                 pageSize:(NSUInteger)pageSize
                  success:(void (^)(SAAggregateSearchResultRspModel *rspModel))successBlock
                  failure:(CMNetworkFailureBlock)failureBlock {
    
    [LKDataRecord.shared traceEvent:@"AggregateSearchKeyWordStat" name:business parameters:@{@"keyWord": keyWord}];

    if ([business isEqualToString:SAClientTypeYumNow]) {
        [self getYumNowStoreListWithPageSize:pageSize pageNum:pageNum address:address keyWord:keyWord success:^(WMSearchStoreRspModel *rspModel) {
            SAAggregateSearchResultRspModel *trueRspModel = SAAggregateSearchResultRspModel.new;
            trueRspModel.total = rspModel.total;
            trueRspModel.pages = rspModel.pages;
            trueRspModel.hasNextPage = rspModel.hasNextPage;
            trueRspModel.pageNum = rspModel.pageNum;
            trueRspModel.list = [NSArray arrayWithArray:rspModel.list];
            successBlock(trueRspModel);
        } failure:failureBlock];
    } else if ([business isEqualToString:SAClientTypeGroupBuy]) {
        [self getGroupNowStoreListWithPageSize:pageSize pageNum:pageNum keyWord:keyWord address:address success:^(GNStorePagingRspModel *rspModel) {
            [rspModel.list enumerateObjectsUsingBlock:^(GNStoreCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.keyWord = keyWord;
            }];
            SAAggregateSearchResultRspModel *trueRspModel = SAAggregateSearchResultRspModel.new;
            trueRspModel.total = rspModel.total;
            trueRspModel.pages = rspModel.pages;
            trueRspModel.hasNextPage = rspModel.hasNextPage;
            trueRspModel.pageNum = rspModel.pageNum;
            trueRspModel.list = [NSArray arrayWithArray:rspModel.list];
            successBlock(trueRspModel);
        } failure:failureBlock];
    } else if ([business isEqualToString:SAClientTypeTinhNow]) {
        [self getTinhNowSearchResultWithPageSize:pageSize pageNum:pageNum keyWord:keyWord success:^(TNQueryGoodsRspModel *rspModel) {
            SAAggregateSearchResultRspModel *trueRspModel = SAAggregateSearchResultRspModel.new;
            trueRspModel.total = rspModel.total;
            trueRspModel.pages = rspModel.pages;
            trueRspModel.hasNextPage = rspModel.hasNextPage;
            trueRspModel.pageNum = rspModel.pageNum;
            trueRspModel.list = [NSArray arrayWithArray:rspModel.list];
            successBlock(trueRspModel);
        } failure:failureBlock];
    }
}

- (void)getGroupNowStoreListWithPageSize:(NSUInteger)pageSize
                                 pageNum:(NSUInteger)pageNum
                                 keyWord:(NSString *)keyWord
                                 address:(SAAddressModel *)address
                                 success:(void (^)(GNStorePagingRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;

    if (keyWord) {
        [mdic setObject:keyWord forKey:@"keyword"];
    }

    if (address) {
        [mdic setObject:@{@"lat": address.lat.stringValue, @"lon": address.lon.stringValue} forKey:@"location"];
    }
    [mdic setObject:@(pageNum) forKey:@"pageNum"];
    [mdic setObject:@(pageSize) forKey:@"pageSize"];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/groupon-service/user/merchant/search";
    request.isNeedLogin = NO;

    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNStorePagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getYumNowStoreListWithPageSize:(NSUInteger)pageSize
                               pageNum:(NSUInteger)pageNum
                               address:(SAAddressModel *)address
                               keyWord:(NSString *)keyWord
                               success:(void (^_Nullable)(WMSearchStoreRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (address) {
        params[@"location"] = @{@"lat": address.lat.stringValue, @"lon": address.lon.stringValue};
        params[@"province"] = address.city;
        params[@"district"] = address.subLocality;
    }

    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"keyword"] = keyWord;
    params[@"type"] = @"all";
    params[@"inRange"] = @(1);

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/takeaway-merchant/app/super-app/search/v2";
    request.isNeedLogin = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSearchStoreRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getTinhNowSearchResultWithPageSize:(NSUInteger)pageSize
                                   pageNum:(NSUInteger)pageNum
                                   keyWord:(NSString *)keyWord
                                   success:(void (^)(TNQueryGoodsRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @(pageNum);
    params[@"pageSize"] = @(pageSize);

    if (HDIsStringNotEmpty(keyWord)) {
        params[@"key"] = keyWord;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/es/product/searchV3";
    request.isNeedLogin = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end


@implementation SAAggregateSearchResultRspModel

@end
