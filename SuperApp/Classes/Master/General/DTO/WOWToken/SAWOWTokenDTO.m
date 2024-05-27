//
//  SAWOWToken.m
//  SuperApp
//
//  Created by Chaos on 2021/3/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAWOWTokenDTO.h"
#import "SARspModel.h"
#import "SAWOWTokenModel.h"


@implementation SAWOWTokenDTO

- (void)parsingWOWTokenWithToken:(NSString *)token success:(void (^)(SAWOWTokenModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shareNo"] = token;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/config/copy/share/getShareItem.do";
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWOWTokenModel yy_modelWithJSON:((NSDictionary *)rspModel.data)[@"shareContent"]]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
