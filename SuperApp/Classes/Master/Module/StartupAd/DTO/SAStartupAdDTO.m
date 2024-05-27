//
//  SAStartupAdDTO.m
//  SuperApp
//
//  Created by Tia on 2022/9/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAStartupAdDTO.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SAStartupAdModel.h"
#import "SAAddressCacheAdaptor.h"

@implementation SAStartupAdDTO

- (void)queryAdSuccess:(void (^)(NSArray<SAStartupAdModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/openScreenAd/list.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"language"] = [SAMultiLanguageManager currentLanguage];

    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
    if (addressModel) {
        params[@"areaCode"] = addressModel.districtCode;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SAStartupAdModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
