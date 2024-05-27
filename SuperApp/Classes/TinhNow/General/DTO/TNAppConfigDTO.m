//
//  TNAppConfigDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNAppConfigDTO.h"
#import "SATabBarItemConfig.h"


@implementation TNAppConfigDTO
- (void)queryTinhnowTabBarConfigListSuccess:(void (^)(NSArray<SATabBarItemConfig *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/common/tabBarList";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SATabBarItemConfig.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
