//
//  WMHomeCustomDTO.m
//  SuperApp
//
//  Created by wmz on 2022/4/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeCustomDTO.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"

@implementation WMHomeCustomDTO

- (void)queryYumNowHomeNoticeSuccess:(void (^_Nullable)(NSArray<WMHomeNoticeModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-home-notice";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *mdic = NSMutableDictionary.new;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];

    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        lat = HDLocationManager.shared.coordinate2D.latitude;
        lon = HDLocationManager.shared.coordinate2D.longitude;
    }
    mdic[@"lat"] = @(lat).stringValue;
    mdic[@"lon"] = @(lon).stringValue;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        [NSUserDefaults.standardUserDefaults removeObjectForKey:@"noneNoticeKey"];
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:WMHomeNoticeModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
