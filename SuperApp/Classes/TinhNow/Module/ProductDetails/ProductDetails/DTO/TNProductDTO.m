//
//  TNSectionTableViewSceneDTO.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDTO.h"
#import "TNDeliverInfoModel.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductPurchaseTypeModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNDeliveryComponyModel.h"

@implementation TNProductDTO

- (void)queryProductDetailsWithProductId:(NSString *)productId
                                      sp:(NSString *)sp
                              detailType:(NSInteger)detailType
                                      sn:(NSString *)sn
                                 channel:(NSString *)channel
                              supplierId:(NSString *)supplierId
                                 success:(void (^_Nullable)(TNProductDetailsRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/product/app/detail";

    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(productId)) {
        params[@"id"] = productId;
    }
    if (HDIsStringNotEmpty(sn)) {
        params[@"sn"] = sn;
    }
    if (HDIsStringNotEmpty(channel)) {
        params[@"channel"] = channel;
    }
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    if (HDIsStringNotEmpty(sp)) {
        params[@"sp"] = sp;
    }
    if (detailType > 0) {
        params[@"detailType"] = @(detailType);
    }
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"supplierId"] = supplierId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNProductDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addProductIntoFavoriteWithProductId:(NSString *)productId sp:(NSString *)sp success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/product/collect/add";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = productId;
    if (HDIsStringNotEmpty(sp)) {
        params[@"sp"] = sp;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)removeProdutFromFavoriteWithProductId:(NSString *)productId sp:(NSString *)sp success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/product/collect/remove";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = productId;
    if (HDIsStringNotEmpty(sp)) {
        params[@"sp"] = sp;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

///砍价商品详情
- (void)queryBargainProductDetailsWithActivityId:(NSString *)activityId Success:(void (^_Nullable)(TNProductDetailsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/startnow/bargain-goods-stock/queryActivitySpecDetailV2";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activityId"] = activityId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNProductDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryFreightDataWithStoreId:(NSString *)storeId Success:(void (^)(TNDeliverInfoModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/shop/freight/list";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeId"] = storeId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNDeliverInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryFreightStandardCostsByStoreNo:(NSString *)storeNo success:(void (^_Nullable)(NSArray<TNDeliveryComponyModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/delivery/listByStore";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNDeliveryComponyModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryBuyPurchaseTypeSuccess:(void (^_Nullable)(TNProductPurchaseTypeModel *model))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/salesHelp/purchaseType";
    request.isNeedLogin = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNProductPurchaseTypeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryProductRecommondWithProductId:(NSString *)productId
                                      type:(NSInteger)type
                                        sp:(NSString *)sp
                                    pageNo:(NSUInteger)pageNo
                                  pageSize:(NSUInteger)pageSize
                                   success:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    if (HDIsStringNotEmpty(sp)) {
        //微店推荐数据
        request.requestURI = @"/tapi/es/product/salerRecommend";
    } else {
        //普通供应商店铺
        request.requestURI = @"/tapi/es/product/recommend";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"productId"] = productId;
    params[@"type"] = @(type);
    if (HDIsStringNotEmpty(sp)) {
        params[@"sp"] = sp;
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
