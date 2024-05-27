//
//  GNModel.m
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "SAAddressModel.h"
#import "SACommonConst.h"


@implementation GNModel

- (NSDictionary *)locationInfo {
    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        lat = kDefaultLocationPhn.latitude;
        lon = kDefaultLocationPhn.longitude;
    }
    if (lat == 0 || lon == 0) {
        lat = kDefaultLocationPhn.latitude;
        lon = kDefaultLocationPhn.longitude;
    }
    return @{
        @"lat": @(lat).stringValue,
        @"lon": @(lon).stringValue,
    };
}
@end
