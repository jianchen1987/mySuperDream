//
//  SASetPasswordViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASetPasswordViewModel.h"


@interface SASetPasswordViewModel ()
/// 重置登录密码
@property (nonatomic, strong) CMNetworkRequest *resetLoginPasswordRequest;

@end


@implementation SASetPasswordViewModel

- (void)dealloc {
    [_resetLoginPasswordRequest cancel];
}

- (CMNetworkRequest *)resetLoginPasswordWithPlainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:plainPwd publicKey:rspModel.publicKey];
        if (HDIsStringNotEmpty(self.apiTicket)) {
            [self _resetLoginPasswordWithPwdSecurityStr:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
        } else {
            [self _setPasswordWithPwd:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.resetLoginPasswordRequest;
}

#pragma mark - private methods
- (void)_setPasswordWithPwd:(NSString *)pwd index:(NSString *)index success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.userDTO setLoginPasswordWithEncryptPwd:pwd index:index success:successBlock failure:failureBlock];
}

- (void)_resetLoginPasswordWithPwdSecurityStr:(NSString *)pwdSecurityStr index:(NSString *)index success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"apiTicket"] = self.apiTicket;
    params[@"loginName"] = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
    params[@"password"] = pwdSecurityStr;
    self.resetLoginPasswordRequest.requestParameter = params;
    [self.resetLoginPasswordRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load
- (CMNetworkRequest *)resetLoginPasswordRequest {
    if (!_resetLoginPasswordRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/password/resetPwd.do";
        request.isNeedLogin = false;

        _resetLoginPasswordRequest = request;
    }
    return _resetLoginPasswordRequest;
}

@end
