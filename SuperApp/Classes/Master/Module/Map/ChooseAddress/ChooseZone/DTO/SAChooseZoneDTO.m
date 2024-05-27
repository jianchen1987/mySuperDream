//
//  SAChooseZoneDTO.m
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseZoneDTO.h"
#import "SAAddressZoneModel.h"
#import "SAAppSwitchManager.h"
#import <KSInstantMessagingKit/KSCall.h>


@implementation SAChooseZoneDTO

- (void)getZoneListWithSuccess:(void (^)(NSArray<SAAddressZoneModel *> *))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/superapp/mer/app/zone/all.do";
    request.isNeedLogin = false;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        NSArray *list = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:response.responseObject[@"data"]];
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)fuzzyQueryZoneListWithProvince:(NSString *)province
                              district:(NSString *)district
                               commune:(NSString *)commune
                              latitude:(NSNumber *)lat
                             longitude:(NSNumber *)lon
                               success:(void (^)(SAAddressZoneModel *))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"province"] = province;
    params[@"commune"] = commune;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/superapp/mer/app/zone/fuzzyQuerylist.do";
    request.isNeedLogin = false;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        NSArray<SAAddressZoneModel *> *list = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:response.responseObject[@"data"]];
        SAAddressZoneModel *model = list.firstObject.children.firstObject;
        if (!HDIsObjectNil(model) && model.zlevel == SAAddressZoneLevelProvince) {
            !successBlock ?: successBlock(model);
        } else {
            !successBlock ?: successBlock(list.firstObject);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)fuzzyQueryZoneListWithoutDefaultWithProvince:(NSString *)province
                                            district:(NSString *)district
                                             commune:(NSString *)commune
                                            latitude:(NSNumber *)lat
                                           longitude:(NSNumber *)lon
                                             success:(void (^)(SAAddressZoneModel *))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"province"] = province;
    params[@"commune"] = commune;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }
    params[@"defaultNum"] = @(0);

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/superapp/mer/app/zone/fuzzyQuerylist.do";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = params;

    request.cacheHandler.writeMode = HDNetworkCacheWriteModeMemory;
    request.cacheHandler.readMode = HDNetworkCacheReadModeCancelNetwork;

    //是否根据定位判断callkit开启，默认不需要判断定位
    NSString *callKitLocation = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAppCallKitLocation];
    BOOL needCallKitLocation = (callKitLocation && [callKitLocation isEqualToString:@"on"]);

    [request startWithCache:^(HDNetworkResponse *_Nonnull response) {
        //        HDLog(@"走缓存");
        NSArray<SAAddressZoneModel *> *list = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:response.responseObject[@"data"]];
        SAAddressZoneModel *model = list.firstObject.children.firstObject;
        if (!HDIsObjectNil(model) && model.zlevel == SAAddressZoneLevelProvince) {
            // callkit开关判断
            if (needCallKitLocation) {
                [KSCallKitCenter.sharedInstance enableCallKit:model.code.length > 0];
                [NSUserDefaults.standardUserDefaults setBool:model.code.length > 0 forKey:@"appCallKitSwitch"];
                [NSUserDefaults.standardUserDefaults synchronize];
            }
            !successBlock ?: successBlock(model);
        } else {
            SAAddressZoneModel *model = list.firstObject;

            // callkit开关判断
            if (needCallKitLocation) {
                [KSCallKitCenter.sharedInstance enableCallKit:model.code.length > 0];
                [NSUserDefaults.standardUserDefaults setBool:model.code.length > 0 forKey:@"appCallKitSwitch"];
                [NSUserDefaults.standardUserDefaults synchronize];
            }
            !successBlock ?: successBlock(list.firstObject);
        }
    } success:^(HDNetworkResponse *_Nonnull response) {
        //        HDLog(@"走网络");
        NSArray<SAAddressZoneModel *> *list = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:response.responseObject[@"data"]];
        SAAddressZoneModel *model = list.firstObject.children.firstObject;
        if (!HDIsObjectNil(model) && model.zlevel == SAAddressZoneLevelProvince) {
            // callkit开关判断
            if (needCallKitLocation) {
                [KSCallKitCenter.sharedInstance enableCallKit:model.code.length > 0];
                [NSUserDefaults.standardUserDefaults setBool:model.code.length > 0 forKey:@"appCallKitSwitch"];
                [NSUserDefaults.standardUserDefaults synchronize];
            }
            !successBlock ?: successBlock(model);
        } else {
            SAAddressZoneModel *model = list.firstObject;
            //            //callkit开关判断
            if (needCallKitLocation) {
                [KSCallKitCenter.sharedInstance enableCallKit:model.code.length > 0];
                [NSUserDefaults.standardUserDefaults setBool:model.code.length > 0 forKey:@"appCallKitSwitch"];
                [NSUserDefaults.standardUserDefaults synchronize];
            }
            !successBlock ?: successBlock(list.firstObject);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
