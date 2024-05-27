//
//  SARemoteNotifyViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARemoteNotifyViewModel.h"


@implementation SARemoteNotifyViewModel

- (void)registerUserRemoteNofityDeviceToken:(NSString *)deviceToken
                                    channel:(SAPushChannel)channel
                                    success:(CMNetworkSuccessVoidBlock _Nullable)successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        successBlock ?: successBlock();
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //        params[@"token"] = deviceToken;
    //        params[@"channel"] = channel;
    params[@"appId"] = @"SuperApp";
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    params[@"deviceTokenAndChannelReqDTOList"] = @[@{@"token": deviceToken, @"channel": channel}];
    params[@"appNo"] = @"11";

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/saveOrUpdateMultiplyDevice.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)unregisterUserRemoteNotificationTokenWithChannel:(SAPushChannel)channel success:(CMNetworkSuccessVoidBlock _Nullable)success failure:(CMNetworkFailureBlock _Nullable)failure {
    if (!SAUser.hasSignedIn) {
        success ?: success();
        return;
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/notification/deviceLogout.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"appId"] = @"SuperApp";
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    params[@"operatorNo"] = [SAUser hasSignedIn] ? [[SAUser shared] operatorNo] : @"";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !success ?: success();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failure ?: failure(response.extraData, response.errorType, response.error);
    }];
}

- (void)notificationCallbackInChannel:(SAPushChannel)channel
                                bizId:(NSString *)bizId
                           templateNo:(NSString *)templateNo
                              isClick:(BOOL)isClick
                          newStrategy:(BOOL)newStrategy
                              success:(CMNetworkSuccessVoidBlock)successBlock
                              failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/callback/v2.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"bizId"] = bizId;
    if (isClick) {
        params[@"click"] = @(1);
    }
    params[@"status"] = @(0);
    if (newStrategy) {
        params[@"newStrategy"] = @(1);
    } else {
        params[@"newStrategy"] = @(0);
    }

    if (HDIsStringNotEmpty(templateNo)) {
        params[@"templateNo"] = templateNo;
    }

    request.requestParameter = @{@"message": [params yy_modelToJSONString]};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
