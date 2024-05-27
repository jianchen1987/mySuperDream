//
//  SAMyInfomationViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMyInfomationViewModel.h"
#import "SAUserViewModel.h"


@interface SAMyInfomationViewModel ()
/// 用户 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 用户信息
@property (nonatomic, strong) SAGetUserInfoRspModel *userInfoRspModel;
/// 更新绑定信息
@property (nonatomic, strong) CMNetworkRequest *updateRequest;

@end


@implementation SAMyInfomationViewModel

- (void)dealloc {
    [_updateRequest cancel];
}

- (void)getNewData {
    @HDWeakify(self);
    [self.userViewModel getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.userInfoRspModel = rspModel;
        [SAUser.shared saveWithUserInfo:rspModel];
    } failure:nil];
}

- (CMNetworkRequest *)updateThirdAccountBindStatusForChannel:(SAThirdPartyBindChannel)channel
                                                    userName:(NSString *)userName
                                                       token:(NSString *)token
                                                     success:(void (^)(void))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"thirdUserName"] = userName;
    params[@"thirdToken"] = token;
    self.updateRequest.requestParameter = params;
    [self.updateRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.updateRequest;
}

#pragma mark - getter
- (SAUserViewModel *)userViewModel {
    return _userViewModel ?: ({ _userViewModel = SAUserViewModel.new; });
}

#pragma mark - lazy load
- (CMNetworkRequest *)updateRequest {
    if (!_updateRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/register/auth/bind.do";

        _updateRequest = request;
    }
    return _updateRequest;
}

@end
