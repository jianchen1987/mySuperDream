//
//  SALocationUtil.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SALocationUtil.h"
#import "CMNetworkRequest.h"
#import "SAGoogleGeocodeModel.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDServiceKit/HDSystemCapabilityUtil.h>

SAAddressKey const SAAddressKeyStreet = @"Street";
SAAddressKey const SAAddressKeySubLocality = @"SubLocality";
SAAddressKey const SAAddressKeyState = @"State";
SAAddressKey const SAAddressKeySubThoroughfare = @"SubThoroughfare";
SAAddressKey const SAAddressKeyThoroughfare = @"Thoroughfare";
SAAddressKey const SAAddressKeyCountry = @"Country";
SAAddressKey const SAAddressKeyName = @"Name";
SAAddressKey const SAAddressKeyCity = @"City";


@implementation SALocationUtil
+ (void)transferCoordinateToAddress:(CLLocationCoordinate2D)coordinate
                         completion:(void (^)(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary))completion {
    void (^callBack)(SAGoogleGeocodeModel *) = ^void(SAGoogleGeocodeModel *geocodeModel) {
        if (HDIsObjectNil(geocodeModel)) {
            !completion ?: completion(nil, nil, nil);
        } else {
            NSString *streetNumber = @"";
            NSString *route = @"";
            NSString *premise = @"";
            NSString *subpremise = @"";
            NSString *neighborhood = @"";
            NSString *sublocality = @"";
            NSString *locality = @"";
            NSString *administrative_area_level_1 = @"";
            NSString *country = @"";

            for (SAGoogleGeocodeComponentsModel *model in geocodeModel.addressComponents) {
                if ([model.types containsObject:@"street_number"] && ![model.longName isEqualToString:@"Unnamed Road"]) {  /// 街道号
                    streetNumber = model.longName;
                    
                } else if ([model.types containsObject:@"route"] && ![model.longName isEqualToString:@"Unnamed Road"]) {  /// 街道名
                    route = model.longName;
                    
                } else if ([model.types containsObject:@"premise"] && ![model.longName isEqualToString:@"Unnamed Road"]) { /// 建筑 建筑群
                    premise = model.longName;
                    
                } else if ([model.types containsObject:@"subpremise"] && ![model.longName isEqualToString:@"Unnamed Road"]) {  /// 建筑
                    subpremise = model.longName;
                    
                } else if ([model.types containsObject:@"neighborhood"] && ![model.longName isEqualToString:@"Unnamed Road"]) { /// 街区
                    neighborhood = model.longName;
                    
                } else if ([model.types containsObject:@"sublocality"] && ![model.longName isEqualToString:@"Unnamed Road"]) { /// 市政区以下的一级行政实体
                    sublocality = model.longName;
                    
                } else if ([model.types containsObject:@"locality"] && ![model.longName isEqualToString:@"Unnamed Road"]) {  /// 城市 城镇
                    locality = model.longName;
                    
                } else if ([model.types containsObject:@"administrative_area_level_1"] && ![model.longName isEqualToString:@"Unnamed Road"]) { /// 国家 地区级别以下的一级行政实体
                    administrative_area_level_1 = model.longName;
                    
                } else if ([model.types containsObject:@"country"] && ![model.longName isEqualToString:@"Unnamed Road"]) {   /// 国家
                    country = model.longName;
                }
            }

            // 短地址
            NSString *shortName = @"";
            if (HDIsStringNotEmpty(route)) {
                shortName = route;
            } else if (HDIsStringNotEmpty(premise)) {
                shortName = premise;
            } else if (HDIsStringNotEmpty(subpremise)) {
                shortName = subpremise;
            }
            // 完整地址
            NSString *address = @"";
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
                address = geocodeModel.formattedAddress;
            } else {
                address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@", streetNumber, shortName, neighborhood, sublocality, locality, administrative_area_level_1, country];
            }

            NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
            addressDictionary[SAAddressKeyStreet] = neighborhood;
            addressDictionary[SAAddressKeySubLocality] = sublocality;
            addressDictionary[SAAddressKeyState] = administrative_area_level_1;
            addressDictionary[SAAddressKeySubThoroughfare] = subpremise;
            addressDictionary[SAAddressKeyThoroughfare] = premise;
            addressDictionary[SAAddressKeyCountry] = country;
            addressDictionary[SAAddressKeyName] = shortName;
            addressDictionary[SAAddressKeyCity] = locality;
            !completion ?: completion(address, subpremise, addressDictionary);
        }
    };

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/app/mobile-app-composition/map/google/geocode";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = false;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"latlng"] = [NSString stringWithFormat:@"%lf,%lf", coordinate.latitude, coordinate.longitude];
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        params[@"language"] = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        params[@"language"] = @"km";
    } else {
        params[@"language"] = @"en";
    }
    request.requestParameter = params;

    request.cacheHandler.writeMode = HDNetworkCacheWriteModeMemory;
    request.cacheHandler.readMode = HDNetworkCacheReadModeCancelNetwork;

    [request startWithCache:^(HDNetworkResponse *_Nonnull response) {
        //        HDLog(@"反编码走缓存");
        NSArray *result = response.responseObject[@"data"][@"results"];
        if (HDIsArrayEmpty(result)) {
            !completion ?: completion(nil, nil, nil);
        } else {
            SAGoogleGeocodeModel *geocodeModel = [SAGoogleGeocodeModel yy_modelWithJSON:result.firstObject];
            callBack(geocodeModel);
        }
    } success:^(HDNetworkResponse *_Nonnull response) {
        //        HDLog(@"反编码走网络");
        NSArray *result = response.responseObject[@"data"][@"results"];
        if (HDIsArrayEmpty(result)) {
            !completion ?: completion(nil, nil, nil);
        } else {
            SAGoogleGeocodeModel *geocodeModel = [SAGoogleGeocodeModel yy_modelWithJSON:result.firstObject];
            callBack(geocodeModel);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(nil, nil, nil);
    }];
}

+ (HDAlertView *)showNeedAuthedTipConfirmButtonHandler:(HDAlertViewButtonHandler)confirmButtonHandler cancelButtonHandler:(HDAlertViewButtonHandler __nullable)cancelButtonHandler {
    NSString *message = SALocalizedString(@"discover_detail_tip_before_request", @"使用该功能需要获取您的位置，请同意 WOWNOW 使用您的位置权限");
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
    alertView.identitableString = message;
    HDAlertViewButton *confirmButton = [HDAlertViewButton buttonWithTitle:SALocalizedString(@"AUDIT_BUTTON_SURE", @"好的") type:HDAlertViewButtonTypeCustom
                                                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                      if (confirmButtonHandler) {
                                                                          confirmButtonHandler(alertView, button);
                                                                      }
                                                                  }];
    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:SALocalizedString(@"discover_detail_tip_deny", @"不同意") type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                     if (cancelButtonHandler) {
                                                                         cancelButtonHandler(alertView, button);
                                                                     } else {
                                                                         [alertView dismiss];
                                                                     }
                                                                 }];
    [alertView addButtons:@[cancelButton, confirmButton]];

    [alertView show];
    return alertView;
}

+ (HDAlertView *)showUnAuthedTipConfirmButtonHandler:(HDAlertViewButtonHandler __nullable)confirmButtonHandler cancelButtonHandler:(HDAlertViewButtonHandler __nullable)cancelButtonHandler {
    NSString *message = SALocalizedString(@"location_service_disabled_open_in_system_settings", @"您关闭了或者未允许 WOWNOW 获取您的位置，请前往设置 WOWNOW ->  位置设置允许");
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
    alertView.identitableString = message;
    HDAlertViewButton *confirmButton = [HDAlertViewButton buttonWithTitle:SALocalizedString(@"discover_detail_tip_goto_settings", @"去设置") type:HDAlertViewButtonTypeCustom
                                                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                      if (confirmButtonHandler) {
                                                                          confirmButtonHandler(alertView, button);
                                                                      } else {
                                                                          [alertView dismiss];
                                                                          // 打开系统设置
                                                                          [HDSystemCapabilityUtil openAppSystemSettingPage];
                                                                      }
                                                                  }];
    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                     if (cancelButtonHandler) {
                                                                         cancelButtonHandler(alertView, button);
                                                                     } else {
                                                                         [alertView dismiss];
                                                                     }
                                                                 }];
    [alertView addButtons:@[cancelButton, confirmButton]];

    [alertView show];
    return alertView;
}

@end
