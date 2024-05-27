//
//  WMStoreDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDTO.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SALocationUtil.h"
#import "WMCategoryItem.h"
#import "WMCheckIsStoreCanDeliveryRspModel.h"
#import "WMQueryMerchantFilterCategoryRspModel.h"
#import "WMQueryNearbyStoreRspModel.h"
#import <HDServiceKit/HDLocationUtils.h>

typedef void (^ContinueRequestHandler)(void);


@interface WMStoreDTO ()
/// 判断是否可配送
@property (nonatomic, strong) CMNetworkRequest *checkIsStoreCanDelivery;
@end


@implementation WMStoreDTO

- (void)dealloc {
    [_checkIsStoreCanDelivery cancel];
}

- (CMNetworkRequest *)getNearbyStoreWithRequestSource:(WMMerchantRecommendType)requestSource
                                            longitude:(NSString *)longitude
                                             latitude:(NSString *)latitude
                                             pageSize:(NSUInteger)pageSize
                                              pageNum:(NSUInteger)pageNum
                                             sortType:(NSString *)sortType
                                       marketingTypes:(NSArray<NSString *> *)marketingTypes
                                         storeFeature:(NSArray<NSString *> *)storeFeature
                                        businessScope:(NSString *)businessScope
                                              success:(void (^)(WMQueryNearbyStoreNewRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"location"] = @{@"lat": latitude, @"lon": longitude};
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    //    params[@"requestSource"] = requestSource;
    params[@"sortType"] = sortType ? sortType : @"";
    params[@"businessCode"] = businessScope ? businessScope : @"";
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if (marketingTypes && marketingTypes.count > 0) {
        NSString *strArr = [marketingTypes componentsJoinedByString:@","];
        NSArray<NSString *> *newArr = [strArr componentsSeparatedByString:@","];
        NSMutableArray<NSString *> *lastArr = [NSMutableArray arrayWithArray:newArr];
        [lastArr removeObject:@"99"];
        params[@"marketingTypes"] = lastArr;
    } else {
        params[@"marketingTypes"] = @[];
    }
    
    if (storeFeature.count){
        params[@"storeFeature"] = storeFeature;
    }else{
        params[@"storeFeature"] = @[];
    }
    
    if ([marketingTypes containsObject:@"99"]) {
        params[@"isNew"] = @1;
    } else {
        params[@"isNew"] = @0;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
//    request.requestURI = @"/takeaway-merchant/app/super-app/nearby";
    request.requestURI = @"/takeaway-merchant/app/super-app/v2/nearby";

    // 如果当前参数中经纬度不合法再使用定位地址
    CLLocationCoordinate2D paramsCoordinate2D = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:paramsCoordinate2D];
    if (isParamsCoordinate2DValid) {
        request.requestParameter = params;
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            !successBlock ?: successBlock([WMQueryNearbyStoreNewRspModel yy_modelWithJSON:rspModel.data]);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
        return request;
    }

    BOOL isLocationPermissionAuthed = [HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed;
    void (^continueRequest)(void) = ^(void) {
        // 经度纬度无效不请求，也不触发失败（因为此时可能是首次安装正在让用户授权）
        if (![HDLocationManager.shared isCurrentCoordinate2DValid]) {
            return;
        }

        params[@"location"] = @{
            @"lat": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue,
            @"lon": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue
        };
        request.requestParameter = params;

        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            !successBlock ?: successBlock([WMQueryNearbyStoreNewRspModel yy_modelWithJSON:rspModel.data]);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
    };

    // 已经授权授权
    if (isLocationPermissionAuthed) {
        // 已经获取到位置
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            continueRequest();
        } else {
            // 有权限但是没获取到位置
            [HDLocationManager.shared startUpdatingLocation];
        }
    } else {
        continueRequest();
    }

    return request;
}

- (void)getDeliveryFeeStoreListLongitude:(NSString *)longitude
                                latitude:(NSString *)latitude
                                pageSize:(NSUInteger)pageSize
                                 pageNum:(NSUInteger)pageNum
                                   param:(nullable NSDictionary *)param
                                 success:(void (^)(WMQueryNearbyStoreRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/queryStoreAtIndexColumn";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([param isKindOfClass:NSDictionary.class]) {
        params = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    params[@"location"] = @{@"lat": latitude, @"lon": longitude};
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMQueryNearbyStoreRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (CMNetworkRequest *)checkIsStoreCanDeliveryWithStoreNo:(NSString *)storeNo
                                               longitude:(NSString *)longitude
                                                latitude:(NSString *)latitude
                                                 success:(void (^)(WMCheckIsStoreCanDeliveryRspModel *_Nonnull))successBlock
                                                 failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"location"] = @{@"lat": latitude, @"lon": longitude};
    self.checkIsStoreCanDelivery.requestParameter = params;
    [self.checkIsStoreCanDelivery startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMCheckIsStoreCanDeliveryRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.checkIsStoreCanDelivery;
}

- (CMNetworkRequest *)getWMAplioConfigSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/apollo/get";
    request.requestParameter = @{@"code": @"open.YumNowHomeLayout"};
    //
    //    if([SAMultiLanguageManager isCurrentLanguageCN]) {
    //        request.requestParameter = @{@"code": @"open.page.theme.area.name.zh"};
    //    }else if([SAMultiLanguageManager isCurrentLanguageEN]) {
    //        request.requestParameter = @{@"code": @"open.page.theme.area.name.km"};
    //    }else{
    //        request.requestParameter = @{@"code": @"open.page.theme.area.name.km"};
    //    }
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *info = (id)rspModel.data;
        !successBlock ?: successBlock([info isKindOfClass:NSArray.class] ? info.firstObject[@"value"] : nil);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (CMNetworkRequest *)getWMAplioConfigAreaNameSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/apollo/get";

    if ([SAMultiLanguageManager isCurrentLanguageCN]) {
        request.requestParameter = @{@"code": @"open.page.theme.area.name.zh"};
    } else if ([SAMultiLanguageManager isCurrentLanguageEN]) {
        request.requestParameter = @{@"code": @"open.page.theme.area.name.km"};
    } else {
        request.requestParameter = @{@"code": @"open.page.theme.area.name.km"};
    }
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *info = (id)rspModel.data;
        !successBlock ?: successBlock([info isKindOfClass:NSArray.class] ? info.firstObject[@"value"] : nil);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (void)getWMIndexShowColumnSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        lat = HDLocationManager.shared.coordinate2D.latitude;
        lon = HDLocationManager.shared.coordinate2D.longitude;
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/indexShowColumn";
    request.requestParameter = @{@"lat": @(lat).stringValue, @"lon": @(lon).stringValue};
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (id)rspModel.data;
        !successBlock ?: successBlock([info isKindOfClass:NSDictionary.class] ? info[@"context"] : nil);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load
- (CMNetworkRequest *)checkIsStoreCanDelivery {
    if (!_checkIsStoreCanDelivery) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-merchant/app/super-app/check-store";
        request.isNeedLogin = true;
        _checkIsStoreCanDelivery = request;
    }
    return _checkIsStoreCanDelivery;
}

@end
