//
//  SASearchAddressDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASearchAddressDTO.h"
#import "SAAddressAutoCompleteRspModel.h"
#import "SAAddressSearchRspModel.h"


@interface SASearchAddressDTO ()

@property (nonatomic, strong) CMNetworkRequest *placeDetailsRequest;
@end


@implementation SASearchAddressDTO

- (void)searchAddressWithKeyword:(NSString *)keyword
                        location:(CLLocationCoordinate2D)coordinate
                          radius:(CGFloat)radius
                    sessionToken:(NSString *)sessionToken
                         success:(void (^)(SAAddressAutoCompleteRspModel *_Nonnull))successBlock
                         failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"language"] = SAMultiLanguageManager.isCurrentLanguageCN ? @"zh-CN" : SAMultiLanguageManager.isCurrentLanguageKH ? @"km" : @"en";
    params[@"input"] = keyword;
    params[@"components"] = @"country:kh";
    params[@"sessiontoken"] = sessionToken;
    params[@"radius"] = @(radius);
    if ([HDLocationManager.shared isCoordinate2DValid:coordinate]) {
        params[@"location"] = [NSString stringWithFormat:@"%lf,%lf", coordinate.latitude, coordinate.longitude];
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/app/mobile-app-composition/map/google/place-autocomplete";
    request.isNeedLogin = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = [SARspModel yy_modelWithJSON:response.responseObject];
        !successBlock ?: successBlock([SAAddressAutoCompleteRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getPlaceDetailsWithPlaceId:(NSString *)placeId
                      sessionToken:(NSString *)sessionToken
                           success:(void (^_Nullable)(SAAddressSearchRspModel *rspModel))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"language"] = SAMultiLanguageManager.isCurrentLanguageCN ? @"zh-CN" : SAMultiLanguageManager.isCurrentLanguageKH ? @"km" : @"en";
    params[@"place_id"] = placeId;
    params[@"fields"] = @"formatted_address,name,geometry";
    params[@"sessiontoken"] = sessionToken;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/app/mobile-app-composition/map/google/place/details";
    request.isNeedLogin = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = [SARspModel yy_modelWithDictionary:response.responseObject];
        !successBlock ?: successBlock([SAAddressSearchRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
