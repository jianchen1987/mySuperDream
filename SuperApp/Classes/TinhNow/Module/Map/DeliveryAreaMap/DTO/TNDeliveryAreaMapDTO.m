//
//  TNDeliveryAreaMapDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliveryAreaMapDTO.h"
#import "TNDeliveryAreaMapModel.h"


@interface TNDeliveryAreaMapDTO ()
@end


@implementation TNDeliveryAreaMapDTO

- (void)queryStoreRegionListWithLongitude:(NSNumber *)longitude
                                 latitude:(NSNumber *)latitude
                                  success:(void (^)(TNDeliveryAreaMapModel *_Nonnull))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/region/findAllRegionList";

    if (longitude && latitude) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"longitude"] = longitude ? longitude.stringValue : @"";
        params[@"latitude"] = latitude ? latitude.stringValue : @"";
        request.requestParameter = params;
    }

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNDeliveryAreaMapModel *model = [TNDeliveryAreaMapModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
