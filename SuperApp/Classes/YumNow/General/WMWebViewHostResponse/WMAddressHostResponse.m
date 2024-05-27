//
//  WMAddressHostResponse.m
//  SuperApp
//
//  Created by wmz on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAddressHostResponse.h"
#import "SAAddressModel.h"
#import "SANotificationConst.h"
#import "SAAddressCacheAdaptor.h"

@implementation WMAddressHostResponse

+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{@"getSelectedAddress$": kHDWHResponseMethodOn, @"reginerYumnowNotifications$": kHDWHResponseMethodOn};
}

- (void)reginerYumnowNotificationsWithCallback:(NSString *)callBackKey {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeCodeScanningOrderStatusAction) name:kNotificationNameNewMessages object:nil];
}

- (void)changeCodeScanningOrderStatusAction {
    [self.webViewHost fire:@"changeCodeScanningOrderStatus" param:@{}];
}

- (void)getSelectedAddressWithCallback:(NSString *)callBackKey {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"getSelectedAddress" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
    } else {
        [self.webViewHost fireCallback:callBackKey actionName:@"getSelectedAddress" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{
            @"address": addressModel.address,
            @"city": addressModel.city,
            @"country": addressModel.country,
            @"latitude": addressModel.lat,
            @"longitude": addressModel.lon,
            @"province": addressModel.provinceCode,
        }];
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
