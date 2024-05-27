
//
//  SAUpdateUserInfoViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUpdateUserInfoViewModel.h"


@interface SAUpdateUserInfoViewModel ()

/// 更新用户信息
@property (nonatomic, strong) CMNetworkRequest *updateUserInfoRequest;

@end


@implementation SAUpdateUserInfoViewModel

- (void)dealloc {
    [_updateUserInfoRequest cancel];
}

- (CMNetworkRequest *)updateUserInfoWithHeadURL:(NSString *_Nullable)headURL
                                       nickName:(NSString *_Nullable)nickName
                                          email:(NSString *_Nullable)email
                                         gender:(SAGender _Nullable)gender
                                       birthday:(NSString *_Nullable)birthday
                                     profession:(NSString *_Nullable)profession
                                      education:(NSString *_Nullable)education
                                        success:(void (^)(void))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"version"] = HDDeviceInfo.appVersion;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if (HDIsStringNotEmpty(headURL)) {
        params[@"headURL"] = headURL;
    }
    if (HDIsStringNotEmpty(nickName)) {
        params[@"nickname"] = nickName;
    }
    if (HDIsStringNotEmpty(email)) {
        params[@"email"] = email;
    }
    if (HDIsStringNotEmpty(gender)) {
        params[@"gender"] = gender;
    }
    if (HDIsStringNotEmpty(birthday)) {
        params[@"birthday"] = birthday;
    }
    if (HDIsStringNotEmpty(profession)) {
        params[@"profession"] = profession;
    }
    if (HDIsStringNotEmpty(education)) {
        params[@"education"] = education;
    }
    self.updateUserInfoRequest.requestParameter = params;
    [self.updateUserInfoRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.updateUserInfoRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)updateUserInfoRequest {
    if (!_updateUserInfoRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/info/modify.do";

        _updateUserInfoRequest = request;
    }
    return _updateUserInfoRequest;
}

@end
