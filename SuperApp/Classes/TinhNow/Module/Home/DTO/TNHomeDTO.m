//
//  SAHomeDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeDTO.h"
#import "TNActivityCardRspModel.h"
#import "TNHomeCategoryModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNScrollContentRspModel.h"


@implementation TNHomeDTO

- (void)queryChoicenessInfoWithPageSize:(NSUInteger)pageSize
                                pageNum:(NSUInteger)pageNum
                                success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"specialId"] = @(0);
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = [SAUser shared].loginName;
    }
    [self queryPickForYouInfoWithParams:params success:successBlock failure:failureBlock];
}

- (void)queryPickForYouInfoWithParams:(NSDictionary *)params success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/searchBySpecialV3"; //推荐接口改用专题接口  专题id写死为0
                                                                //    @"/api/merchant/index/recommend/list";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:params];
    request.requestParameter = para;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryHomeScrollTextSuccess:(void (^)(TNScrollContentRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/index/navigation/list";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNScrollContentRspModel yy_modelWithDictionary:@{@"list": rspModel.data}]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryHomeActivityCardSuccess:(void (^)(TNActivityCardRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/advertisement/v3/list.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = SAClientTypeTinhNow;
    params[@"pageType"] = @(SAPagePositionTinNowHomePage);
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNActivityCardRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryProductCategoryWithScene:(TNProductCategoryScene)scene Success:(void (^)(NSArray<TNHomeCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self queryProductCategoryWithScene:scene sourceId:@"" Success:successBlock failure:failureBlock];
}

- (void)queryProductCategoryWithScene:(TNProductCategoryScene)scene
                             sourceId:(NSString *)sourceId
                              Success:(void (^)(NSArray<TNHomeCategoryModel *> *_Nonnull))successBlock
                              failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/productCategory/queryByRoot";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"scene"] = scene;
    if (HDIsStringNotEmpty(sourceId)) {
        params[@"id"] = sourceId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNHomeCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryRecommendListWithPageSize:(NSUInteger)pageSize pageNum:(NSUInteger)pageNum success:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/es/product/searchV3";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"orderType"] = @"RAND";
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = [SAUser shared].loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
