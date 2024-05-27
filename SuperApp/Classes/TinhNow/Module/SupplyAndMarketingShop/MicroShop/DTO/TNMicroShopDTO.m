//
//  TNMicroShopDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopDTO.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNGlobalData.h"
#import "TNMicroShopDetailInfoModel.h"
#import "TNMicroShopPricePolicyModel.h"
#import "TNProductSkuModel.h"
#import "TNSellerProductModel.h"


@implementation TNMicroShopDTO
- (void)queryMicroShopCategoryWithSupplierId:(NSString *)supplierId success:(void (^)(NSArray<TNFirstLevelCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/product/productCategory/supplier/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"supplierId"] = supplierId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNFirstLevelCategoryModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryMyMicroShopInfoDataSuccess:(void (^)(TNSeller *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/user/supplier/detailsByUserName";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = [SAUser shared].loginName;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNSeller *seller = [TNSeller yy_modelWithJSON:rspModel.data];
        seller.loginName = [SAUser shared].loginName;
        if (!HDIsObjectNil([TNGlobalData shared].seller.pricePolicyModel)) {
            seller.pricePolicyModel = [TNGlobalData shared].seller.pricePolicyModel;
        }
        [TNGlobalData shared].seller = seller;
        !successBlock ?: successBlock(seller);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)querySellPricePolicyWithSupplierId:(NSString *)supplierId success:(void (^)(TNMicroShopPricePolicyModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/product/sam/findPricePolicyOfSupplyAndMarketingStore";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"supplierId"] = supplierId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMicroShopPricePolicyModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)setSellPricePolicyWithSupplierId:(NSString *)supplierId
                             policyModel:(TNMicroShopPricePolicyModel *)policyModel
                                 success:(void (^)(TNMicroShopPricePolicyModel *_Nonnull))successBlock
                                 failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/product/sam/pricePolicyOfSupplyAndMarketingStore";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"supplierId"] = supplierId;
    if (!HDIsObjectNil(policyModel)) {
        [params addEntriesFromDictionary:[policyModel yy_modelToJSONObject]];
    }
    //    政策类型,0:分销加价;1:砍价活动加价
    params[@"type"] = @"0";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMicroShopPricePolicyModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addProductToSaleWithSupplierId:(NSString *)supplierId
                             productId:(NSString *)productId
                            categoryId:(NSString *)categoryId
                           policyModel:(TNMicroShopPricePolicyModel *)policyModel
                               success:(void (^_Nullable)(NSArray *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/product/sam/joinSupplyAndMarketingStore";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"supplierId"] = supplierId;
    dataDict[@"productId"] = productId;
    dataDict[@"productCategoryId"] = categoryId;
    if (!HDIsObjectNil(policyModel)) {
        [dataDict addEntriesFromDictionary:[policyModel yy_modelToJSONObject]];
    }
    params[@"data"] = @[dataDict];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSMutableArray *arr = [NSMutableArray array];
        id tmp = rspModel.data;
        if (tmp && [tmp isKindOfClass:[NSArray class]]) {
            NSArray *tmpArr = tmp;
            if (!HDIsArrayEmpty(tmpArr)) {
                for (id item in tmpArr) {
                    if ([item isKindOfClass:[NSDictionary class]]) {
                        TNSellerProductModel *model = [TNSellerProductModel yy_modelWithJSON:item];
                        [arr addObject:model];
                    }
                }
            }
        }
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)cancelProductSaleWithSupplierId:(NSString *)supplierId productId:(NSString *)productId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"supplierId"] = HDIsStringNotEmpty(supplierId) ? supplierId : @"";
    dict[@"productId"] = HDIsStringNotEmpty(productId) ? productId : @"";
    [self cancelProductSaleWithParamsArr:@[dict] success:successBlock failure:failureBlock];
}
- (void)cancelProductSaleWithParamsArr:(NSArray<NSDictionary *> *)paramsArr success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/app/product/sam/quitSupplyAndMarketingStore";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = paramsArr;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryMicroShopInfoDataBySupplierId:(NSString *)supplierId success:(void (^)(TNMicroShopDetailInfoModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/user/supplier/detail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = supplierId;
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = [SAUser shared].operatorNo;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNMicroShopDetailInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryProductSkuDataBySupplierId:(NSString *)supplierId
                              productId:(NSString *)productId
                                success:(void (^)(NSArray<TNProductSkuModel *> *))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/es/product/getSalerSkus";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(supplierId)) {
        params[@"sp"] = supplierId;
    }
    params[@"productId"] = productId;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[TNProductSkuModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)changeProductPriceByDictArray:(NSArray<NSDictionary *> *)dictArray type:(NSInteger)type success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/product/sam/batchUpdatePrice";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"pricePolicyReqDTOS"] = dictArray;
    params[@"type"] = @(type);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)setProductHotSalesBySupplierId:(NSString *)supplierId
                             productId:(NSString *)productId
                        enabledHotSale:(BOOL)enabledHotSale
                               success:(void (^)(void))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/app/product/sam/enableProductHotSale";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"supplierId"] = supplierId;
    params[@"productId"] = productId;
    params[@"enabledHotSale"] = enabledHotSale ? @(1) : @(0);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
