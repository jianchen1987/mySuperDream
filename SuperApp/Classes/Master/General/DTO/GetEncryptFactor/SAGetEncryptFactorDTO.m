//
//  SAGetEncryptFactorDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetEncryptFactorDTO.h"
#import "SAGetEncryptFactorRspModel.h"


@implementation SAGetEncryptFactorDTO

- (void)getEncryptFactorSuccess:(void (^)(SAGetEncryptFactorRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/encryption/factor.do";
    request.isNeedLogin = false;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAGetEncryptFactorRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getWalletEncryptFactorSuccess:(void (^)(SAGetEncryptFactorRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/super-payment/sa/encryption/factor.do";

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAGetEncryptFactorRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
