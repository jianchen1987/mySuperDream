//
//  GNHomeDTO.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNHomeDTO.h"
#import "SACacheManager.h"
#import "SACommonConst.h"


@interface GNHomeDTO ()
/// 查询商家详情
@property (nonatomic, strong) CMNetworkRequest *merchantDetailRequest;
/// 查询商品详情
@property (nonatomic, strong) CMNetworkRequest *productGetDetailRequest;
/// 查询城市是否有门店
@property (nonatomic, strong) CMNetworkRequest *merchantCheckCityRequest;
/// 模糊查询省/市/区
@property (nonatomic, strong) CMNetworkRequest *fuzzyQueryZoneListRequest;
/// 查询门店状态
@property (nonatomic, strong) CMNetworkRequest *checkMerchantStatusRequest;
/// 评论列表
@property (nonatomic, strong) CMNetworkRequest *productReviewListRequest;

@end


@implementation GNHomeDTO

/// 查询商家详情
- (void)merchantDetailStoreNo:(nonnull NSString *)storeNo
                  productCode:(nullable NSString *)productCode
                      success:(nullable void (^)(GNStoreDetailModel *detailModel))successBlock
                      failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    if (storeNo) {
        [mdic setObject:storeNo forKey:@"storeNo"];
    }
    if (productCode) {
        [mdic setObject:productCode forKey:@"code"];
    }
    self.merchantDetailRequest.requestParameter = mdic;
    [self.merchantDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNStoreDetailModel *model = [GNStoreDetailModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取产品详情
- (void)productGetDetailRequestCode:(nonnull NSString *)code success:(nullable void (^)(GNProductModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"location"] = self.locationInfo;
    if (code) {
        [mdic setObject:code forKey:@"code"];
    }
    self.productGetDetailRequest.requestParameter = [NSDictionary dictionaryWithDictionary:mdic];
    [self.productGetDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNProductModel *model = [GNProductModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:GNProductModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询城市是否有门店
- (void)merchantCheckCityWithCityCode:(nonnull NSString *)cityCode success:(void (^_Nullable)(BOOL result))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    self.merchantCheckCityRequest.requestParameter = @{@"cityCode": cityCode ?: @""};
    [self.merchantCheckCityRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        id data = rspModel.data;
        BOOL result = [data boolValue];
        !successBlock ?: successBlock(result);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 模糊查询省/市/区
- (CMNetworkRequest *)fuzzyQueryZoneListWithProvince:(nullable NSString *)province
                                            district:(nullable NSString *)district
                                             commune:(nullable NSString *)commune
                                          defaultNum:(NSInteger)defaultNum
                                            latitude:(nullable NSString *)lat
                                           longitude:(nullable NSString *)lon
                                             success:(void (^_Nullable)(NSArray<SAAddressZoneModel *> *list))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"defaultNum"] = @(defaultNum);
    params[@"province"] = province;
    params[@"commune"] = commune;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat;
    }
    if (lon) {
        params[@"longitude"] = lon;
    }
    self.fuzzyQueryZoneListRequest.requestParameter = params;
    [self.fuzzyQueryZoneListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        NSArray *list = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:response.responseObject[@"data"]];
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.fuzzyQueryZoneListRequest;
}

/// 查询门店的状态
- (void)checkMerchantStatusWithStoreNo:(nonnull NSString *)storeNo success:(void (^_Nullable)(BOOL result, GNMessageCode *model))successBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    if (storeNo) {
        [mdic setObject:storeNo forKey:@"storeNo"];
    }
    self.checkMerchantStatusRequest.requestParameter = mdic;
    [self.checkMerchantStatusRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNMessageCode *model = [GNMessageCode yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model ? YES : NO, model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(NO, nil);
    }];
}

/// 评论列表
- (void)productReviewListWithStoreNo:(nonnull NSString *)storeNo
                         productCode:(nullable NSString *)productCode
                             pageNum:(NSInteger)pageNum
                             success:(void (^_Nullable)(BOOL result, GNCommentPagingRspModel *rspModel))successBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    [mdic setObject:pageNum ? @(pageNum) : @(1) forKey:@"pageNum"];
    [mdic setObject:@(10) forKey:@"pageSize"];
    if (storeNo)
        [mdic setObject:storeNo forKey:@"storeNo"];
    if (productCode)
        [mdic setObject:productCode forKey:@"productCode"];
    self.productReviewListRequest.requestParameter = [NSDictionary dictionaryWithDictionary:mdic];
    [self.productReviewListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNCommentPagingRspModel *model = [GNCommentPagingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(NO, model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(YES, nil);
    }];
}

- (void)getStoreTopicWithPageNum:(nullable NSNumber *)pageNum
                     topicPageNo:(nullable NSString *)topicPageNo
                         success:(void (^_Nullable)(GNTopicModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/topic/get";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    [mdic setObject:pageNum ?: @(1) forKey:@"pageNum"];
    [mdic setObject:@(20) forKey:@"pageSize"];
    [mdic setObject:self.locationInfo forKey:@"geo"];
    if (topicPageNo)
        [mdic setObject:topicPageNo forKey:@"topicPageNo"];

    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNTopicModel *model = [GNTopicModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getAplioConfigSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/config/homePageSort";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (id)rspModel.data;
        !successBlock ?: successBlock([info isKindOfClass:NSDictionary.class] ? info[@"value"] : nil);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getHomeColumnListSuccess:(void (^)(NSArray<GNColumnModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/column/list";
    request.requestParameter = @{@"location": self.locationInfo};
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *info = [NSArray yy_modelArrayWithClass:GNColumnModel.class json:rspModel.data];
        !successBlock ?: successBlock(info);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getHomeColumnStoreListWithpageNum:(NSInteger)pageNum
                               columnCode:(nonnull NSString *)columnCode
                               columnType:(nonnull GNHomeColumnType)columnType
                                   filter:(nullable GNFilterModel *)filter
                                  success:(void (^)(GNStorePagingRspModel *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/column/store/release-list";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"location"] = self.locationInfo;
    mdic[@"pageNum"] = @(pageNum).stringValue;
    mdic[@"pageSize"] = @(10).stringValue;
    if (columnCode) {
        mdic[@"columnCode"] = columnCode;
    }
    if (columnType) {
        mdic[@"columnType"] = columnType;
    }
    if (filter) {
        if (filter.classificationCode) {
            mdic[@"classificationCode"] = filter.classificationCode;
        }
        if (filter.commercialDistrictNo) {
            mdic[@"commercialDistrictNo"] = filter.commercialDistrictNo;
        }
        if (filter.sortType) {
            mdic[@"sortType"] = filter.sortType;
        }
    }
    request.requestParameter = mdic;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNStorePagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getHomeColumnArticleListWithpageNum:(NSInteger)pageNum
                                 columnCode:(nonnull NSString *)columnCode
                                 columnType:(nonnull GNHomeColumnType)columnType
                                     filter:(nullable GNFilterModel *)filter
                                    success:(void (^)(GNArticlePagingRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/column/article/release-list";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"location"] = self.locationInfo;
    mdic[@"pageNum"] = @(pageNum).stringValue;
    mdic[@"pageSize"] = @(10).stringValue;
    if (columnCode) {
        mdic[@"columnCode"] = columnCode;
    }
    if (columnType) {
        mdic[@"columnType"] = columnType;
    }
    if (filter) {
        if (filter.classificationCode) {
            mdic[@"classificationCode"] = filter.classificationCode;
        }
        if (filter.commercialDistrictNo) {
            mdic[@"commercialDistrictNo"] = filter.commercialDistrictNo;
        }
        if (filter.sortType) {
            mdic[@"sortType"] = filter.sortType;
        }
    }
    request.requestParameter = mdic;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNArticlePagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getClassificationListWithCode:(nonnull NSString *)classificationCode success:(void (^)(NSArray<GNClassificationModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/classification/list";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"classificationCode"] = classificationCode;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:GNClassificationModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getHomeClassificationStoreListWithPageNum:(NSInteger)pageNum
                                       parentCode:(nullable NSString *)parentCode
                               classificationCode:(nullable NSString *)classificationCode
                                           filter:(nullable GNFilterModel *)filter
                                          success:(void (^)(GNStorePagingRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/classification/store/list";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"location"] = self.locationInfo;
    mdic[@"pageNum"] = @(pageNum).stringValue;
    mdic[@"pageSize"] = @(10).stringValue;
    if (classificationCode) {
        mdic[@"classificationCode"] = classificationCode;
    }
    if (parentCode) {
        mdic[@"parentCode"] = parentCode;
    }
    if (filter) {
        if (filter.commercialDistrictNo) {
            mdic[@"commercialDistrictNo"] = filter.commercialDistrictNo;
        }
        if (filter.sortType) {
            mdic[@"sortType"] = filter.sortType;
        }
    }
    request.requestParameter = mdic;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNStorePagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getHomeClassificationProductListWithPageNum:(NSInteger)pageNum
                                         parentCode:(nullable NSString *)parentCode
                                 classificationCode:(nullable NSString *)classificationCode
                                             filter:(nullable GNFilterModel *)filter
                                            success:(void (^)(GNProductPagingRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/classification/product/list";
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"location"] = self.locationInfo;
    mdic[@"pageNum"] = @(pageNum).stringValue;
    mdic[@"pageSize"] = @(10).stringValue;
    if (classificationCode) {
        mdic[@"classificationCode"] = classificationCode;
    }
    if (filter) {
        if (filter.commercialDistrictNo) {
            mdic[@"commercialDistrictNo"] = filter.commercialDistrictNo;
        }
        if (filter.sortType) {
            mdic[@"sortType"] = filter.sortType;
        }
    }
    request.requestParameter = mdic;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNProductPagingRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load

- (CMNetworkRequest *)merchantDetailRequest {
    if (!_merchantDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/merchant/merchant-detail";
        _merchantDetailRequest = request;
    }
    return _merchantDetailRequest;
}

- (CMNetworkRequest *)productGetDetailRequest {
    if (!_productGetDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/product/get-detail";
        _productGetDetailRequest = request;
    }
    return _productGetDetailRequest;
}

- (CMNetworkRequest *)merchantCheckCityRequest {
    if (!_merchantCheckCityRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/merchant/check-city";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _merchantCheckCityRequest = request;
    }
    return _merchantCheckCityRequest;
}

- (CMNetworkRequest *)fuzzyQueryZoneListRequest {
    if (!_fuzzyQueryZoneListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/superapp/mer/app/zone/fuzzyQuerylist.do";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _fuzzyQueryZoneListRequest = request;
    }
    return _fuzzyQueryZoneListRequest;
}

- (CMNetworkRequest *)checkMerchantStatusRequest {
    if (!_checkMerchantStatusRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/merchant/check-merchant-status";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _checkMerchantStatusRequest = request;
    }
    return _checkMerchantStatusRequest;
}

- (CMNetworkRequest *)productReviewListRequest {
    if (!_productReviewListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/product/review/list";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _productReviewListRequest = request;
    }
    return _productReviewListRequest;
}

- (void)dealloc {
    [self.checkMerchantStatusRequest cancel];
    [self.productGetDetailRequest cancel];
    [self.merchantCheckCityRequest cancel];
    [self.fuzzyQueryZoneListRequest cancel];
    [self.productReviewListRequest cancel];
}

@end
