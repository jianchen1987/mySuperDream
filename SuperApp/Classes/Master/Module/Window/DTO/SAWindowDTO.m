//
//  SAWindowDTO.m
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWindowDTO.h"
#import "SAUser.h"
#import "SAWindowModel.h"
#import "SAWindowRspModel.h"


@implementation SAWindowDTO

- (void)getWindowWithPage:(SAPagePosition)page
                 location:(SAWindowLocation)location
               clientType:(SAClientType _Nullable)clientType
                 province:(NSString *_Nullable)province
                 district:(NSString *_Nullable)district
                 latitude:(NSNumber *)lat
                longitude:(NSNumber *)lon
                  success:(void (^)(SAWindowRspModel *_Nonnull))successBlock
                  failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = clientType;
    params[@"pageType"] = [NSNumber numberWithUnsignedInteger:page];
    if (location != SAWindowLocationAll) {
        params[@"location"] = [NSNumber numberWithUnsignedInteger:location];
    }
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    params[@"province"] = province;
    params[@"district"] = district;
    if (lat) {
        params[@"latitude"] = lat.stringValue;
    }
    if (lon) {
        params[@"longitude"] = lon.stringValue;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/advertisement/v2/list.do";
    request.isNeedLogin = NO;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWindowRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
