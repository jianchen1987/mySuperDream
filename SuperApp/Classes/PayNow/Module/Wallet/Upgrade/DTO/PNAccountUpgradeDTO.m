//
//  PNAccountUpgradeDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAccountUpgradeDTO.h"


@implementation PNAccountUpgradeDTO

/// 实名提交
- (void)submitRealNameWithParams:(NSMutableDictionary *)params successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/cert/submitRealNameInfo.do";

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 实名提交V2
- (void)submitRealNameV2WithParams:(NSMutableDictionary *)params successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/cert/submitRealNameInfoV2.do";

    request.requestParameter = params;
    HDLog(@"🎆🎆最后提交的数据是： %@", params);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 手持证件认证提交 => [高级 升级到 尊享]
- (void)submitCardHandAuthWidthURL:(NSString *)cardHandURL successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/cert/submitCardHandAuth.do";

    request.requestParameter = @{@"cardHandUrl": cardHandURL ?: @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
