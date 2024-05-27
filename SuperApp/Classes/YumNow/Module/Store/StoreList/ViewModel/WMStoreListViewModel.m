//
//  WMStoreListViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreListViewModel.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SACommonConst.h"
#import "SAWriteDateReadableModel.h"
#import "WMCategoryItem.h"
#import "WMStoreFilterModel.h"
#import "SAAddressCacheAdaptor.h"

@interface WMStoreListViewModel ()
/// 数据源
@property (nonatomic, copy) NSArray<WMStoreListItemModel *> *dataSource;
/// 获取门店搜索热门关键字
@property (nonatomic, strong) CMNetworkRequest *getStoreSearchRequest;
/// 获取品类
@property (nonatomic, strong) CMNetworkRequest *getMerchantCategoryRequest;
@end


@implementation WMStoreListViewModel

- (void)dealloc {
    [_getStoreListRequest cancel];
    [_getStoreSearchRequest cancel];
    [_getMerchantCategoryRequest cancel];
}

- (CMNetworkRequest *)getStoreListWithPageSize:(NSUInteger)pageSize
                                       pageNum:(NSUInteger)pageNum
                                       success:(void (^_Nullable)(WMSearchStoreRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/search/v2";
    request.isNeedLogin = false;
    self.getStoreListRequest = request;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self.filterModel yy_modelToJSONObject]];
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];


    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)]) {
        !successBlock ?: successBlock(nil);
        return self.getStoreListRequest;
    }
    params[@"location"] = @{@"lat": addressModel.lat.stringValue, @"lon": addressModel.lon.stringValue};
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"province"] = addressModel.city;
    params[@"district"] = addressModel.subLocality;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if(self.filterModel.sortType.length){
        params[@"sortType"] = self.filterModel.sortType;
    }
    
    if(self.filterModel.marketingTypes.count) {
        params[@"marketingTypes"] = self.filterModel.marketingTypes;
    }
    
    if(self.filterModel.storeFeature.count) {
        params[@"storeFeature"] = self.filterModel.storeFeature;
    }
    
    self.getStoreListRequest.requestParameter = params;
    @HDWeakify(self);
    [self.getStoreListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSearchStoreRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        self.isRequestFailed = true;
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getStoreListRequest;
}

- (CMNetworkRequest *)getNewStoreListWithPageSize:(NSUInteger)pageSize pageNum:(NSUInteger)pageNum success:(void (^)(WMSearchStoreNewRspModel * _Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/v2/classification/store";
    request.isNeedLogin = false;
    self.getStoreListRequest = request;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params addEntriesFromDictionary:[self.filterModel yy_modelToJSONObject]];
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];


    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)]) {
        !successBlock ?: successBlock(nil);
        return self.getStoreListRequest;
    }
    params[@"location"] = @{@"lat": addressModel.lat.stringValue, @"lon": addressModel.lon.stringValue};
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
//    params[@"province"] = addressModel.city;
//    params[@"district"] = addressModel.subLocality;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if(self.filterModel.businessScope){
        params[@"businessCode"] = self.filterModel.businessScope;
    }
    if(self.filterModel.sortType.length){
        params[@"sortType"] = self.filterModel.sortType;
    }
    
    if(self.filterModel.marketingTypes.count) {
        params[@"marketingTypes"] = self.filterModel.marketingTypes;
    }
    
    if(self.filterModel.storeFeature.count) {
        params[@"storeFeature"] = self.filterModel.storeFeature;
    }
    
    self.getStoreListRequest.requestParameter = params;
    @HDWeakify(self);
    [self.getStoreListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSearchStoreNewRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        self.isRequestFailed = true;
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getStoreListRequest;
}

- (CMNetworkRequest *)getStoreSearchHotKeywordsWithProvince:(NSString *_Nullable)province
                                                   district:(NSString *_Nullable)district
                                                   latitude:(NSNumber *)lat
                                                  longitude:(NSNumber *)lon
                                                    success:(void (^)(NSArray<NSString *> *_Nonnull))successBlock
                                                    failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"province"] = province;
    params[@"district"] = district;
    params[@"businessLine"] = SAClientTypeYumNow;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }
    self.getStoreSearchRequest.requestParameter = params;

    [self.getStoreSearchRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *list = (NSArray *)rspModel.data;
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getStoreSearchRequest;
}

- (CMNetworkRequest *)getMerchantCategorySuccess:(void (^)(NSArray<WMCategoryItem *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getMerchantCategoryRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *list = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:rspModel.data];
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:list] forKey:kCacheKeyMerchantKind];
        @HDStrongify(self);
        !self.successGetCategoryListBlock ?: self.successGetCategoryListBlock();
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getMerchantCategoryRequest;
}

- (CMNetworkRequest *)getAssociateSearchKeyword:(NSString *)keyword success:(void (^)(NSArray<WMAssociateSearchModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-associate-search";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyword"] = keyword;
    params[@"lang"] = [HDDeviceInfo getDeviceLanguage];
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lat = HDLocationManager.shared.coordinate2D.longitude;
        } else {
            lat = kDefaultLocationPhn.latitude;
            lon = kDefaultLocationPhn.longitude;
        }
    }
    params[@"geo"] = @{@"lat": [NSString stringWithFormat:@"%f", lat], @"lon": [NSString stringWithFormat:@"%f", lon]};
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:WMAssociateSearchModel.class json:rspModel.data];
        if ([arr isKindOfClass:NSArray.class]) {
            !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:WMAssociateSearchModel.class json:rspModel.data]);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/h5/no-auth/findSystemConfigs";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class] && info[key]) {
            NSDictionary *dic = info[key];
            if ([dic isKindOfClass:NSDictionary.class]) {
                !successBlock ?: successBlock(dic[@"value"]);
            } else {
                !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
            }
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

+ (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/h5/no-auth/findSystemConfigs";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class] && info[key]) {
            NSDictionary *dic = info[key];
            if ([dic isKindOfClass:NSDictionary.class]) {
                !successBlock ?: successBlock(dic[@"value"]);
            } else {
                !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
            }
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (WMStoreFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = WMStoreFilterModel.new;
    }
    return _filterModel;
}

- (CMNetworkRequest *)getStoreSearchRequest {
    if (!_getStoreSearchRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/config/hotWord/get.do";
        _getStoreSearchRequest = request;
    }
    return _getStoreSearchRequest;
}

- (CMNetworkRequest *)getMerchantCategoryRequest {
    if (!_getMerchantCategoryRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-merchant/app/super-app/businessScope/list.do";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _getMerchantCategoryRequest = request;
    }
    return _getMerchantCategoryRequest;
}

@end
