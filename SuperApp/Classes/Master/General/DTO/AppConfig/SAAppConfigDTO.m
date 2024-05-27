//
//  SAAppConfigDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppConfigDTO.h"
#import "SAAddressModel.h"
#import "SAAppStartUpConfig.h"
#import "SABlueAndGreenRspModel.h"
#import "SAUser.h"
#import "SAAddressCacheAdaptor.h"

@implementation SAAppConfigDTO
- (void)queryAppStartupConfigWithSuccess:(void (^)(SAAppStartUpConfig *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/mobile-app-composition/app/config/home-page/query";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizType"] = @"10";
    params[@"appNo"] = @"11";
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    //增加上次定位的areaCode过滤广告
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
    if (addressModel) {
        params[@"areaCode"] = addressModel.districtCode;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAAppStartUpConfig yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryKingKongAreaConfigListWithType:(SAClientType)type success:(void (^)(NSArray<SAKingKongAreaItemConfig *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/funcGuide/query.do";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = type;
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *data = (NSDictionary *)rspModel.data;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAKingKongAreaItemConfig.class json:data[@"list"]]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryTabBarConfigListWithType:(SAClientType)type success:(void (^)(NSArray<SATabBarItemConfig *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    if ([self _compare:@"2.43.0"] != NSOrderedAscending) {
        request.requestURI = @"/app/config/tabBar/v2/query.do";
    } else {
        request.requestURI = @"/app/config/tabBar/query.do";
    }
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = type;
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *data = (NSDictionary *)rspModel.data;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SATabBarItemConfig.class json:data[@"list"]]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryAppRemoteConfigWithAppNo:(NSString *)appNo success:(void (^_Nullable)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/mobile-app-composition/app/apollo/v1";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appNo"] = appNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryAppMarketingAlertWithType:(SAClientType)type
                              province:(NSString *_Nullable)province
                              district:(NSString *_Nullable)district
                              latitude:(NSNumber *)lat
                             longitude:(NSNumber *)lon
                               success:(void (^)(NSArray<SAMarketingAlertViewConfig *> *list))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/popAds/getPopAdvertisement.do";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = type;
    params[@"province"] = province;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }

    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    params[@"containFixedTime"] = @(1);
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAMarketingAlertViewConfig.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryLoginMarketingAlertWithType:(SAClientType)type
                                province:(NSString *_Nullable)province
                                district:(NSString *_Nullable)district
                                latitude:(NSNumber *)lat
                               longitude:(NSNumber *)lon
                              operatorNo:(NSString *)operatorNo
                                 success:(void (^)(NSArray<SAMarketingAlertViewConfig *> *list))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/popAds/getPopAdvertisementAfterLogin.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = type;
    params[@"province"] = province;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }
    params[@"operatorNo"] = operatorNo;
    params[@"containFixedTime"] = @(1);

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAMarketingAlertViewConfig.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryBlueAndGreenFlagCompletion:(void (^_Nullable)(NSString *_Nullable flag))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/warehouse/tag/blueAndGreen/query.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SABlueAndGreenRspModel *trueModel = [SABlueAndGreenRspModel yy_modelWithJSON:rspModel.data];
        if (trueModel.tagNos.count) {
            !completion ?: completion(trueModel.tagNos.firstObject);
        } else {
            !completion ?: completion(nil);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(nil);
    }];
}

//比对版本号
// NSOrderedAscending -1   输入版本号大于app版本号
// NSOrderedSame       0   输入版本号等于app版本号
// NSOrderedDescending 1   输入版本号小于app版本号
- (NSComparisonResult)_compare:(NSString *)version {
    //当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    NSArray *appVersionArr = [appVersion componentsSeparatedByString:@"."];
    NSArray *versionArr = [version componentsSeparatedByString:@"."];

    if ([appVersionArr[0] integerValue] > [versionArr[0] integerValue]) {
        return NSOrderedDescending;
    } else if (([appVersionArr[0] integerValue] == [versionArr[0] integerValue]) && ([appVersionArr[1] integerValue] > [versionArr[1] integerValue])) {
        return NSOrderedDescending;
    } else if (([appVersionArr[0] integerValue] == [versionArr[0] integerValue]) && ([appVersionArr[1] integerValue] == [versionArr[1] integerValue])
               && ([appVersionArr[2] integerValue] > [versionArr[2] integerValue])) {
        return NSOrderedDescending;
    } else if (([appVersionArr[0] integerValue] == [versionArr[0] integerValue]) && ([appVersionArr[1] integerValue] == [versionArr[1] integerValue])
               && ([appVersionArr[2] integerValue] == [versionArr[2] integerValue])) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

@end
