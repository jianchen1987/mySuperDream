//
//  SADiscoveryDTO.m
//  SuperApp
//
//  Created by seeu on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SADiscoveryDTO.h"
#import "SAUser.h"


@implementation SADiscoveryDTO

+ (void)likeContentWithContentId:(NSString *_Nonnull)contentId taskId:(NSString *_Nullable)taskId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/like/doLike.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizId"] = contentId;
    params[@"status"] = @"like";
    params[@"bizType"] = @"content";
    params[@"taskNo"] = taskId;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

+ (void)unlikeContentWithContentId:(NSString *)contentId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/like/doLike.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizId"] = contentId;
    params[@"status"] = @"unlike";
    params[@"bizType"] = @"content";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

+ (void)reportContentWithContentId:(NSString *)contentId
                            reason:(NSString *_Nonnull)reason
                           bizType:(NSString *_Nonnull)bizType
                           success:(void (^)(void))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/discovery/content/uninterest.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizId"] = contentId;
    params[@"unInterestType"] = reason;
    params[@"bizType"] = bizType;
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
