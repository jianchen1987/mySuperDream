//
//  SAForgetLoginPwdSetPwdViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAForgetLoginPwdSetPwdViewModel.h"
#import "SAGetEncryptFactorDTO.h"


@interface SAForgetLoginPwdSetPwdViewModel ()
/// 获取加密因子 VM
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;

/// 重置登录密码
@property (nonatomic, strong) CMNetworkRequest *resetLoginPasswordRequest;

@end


@implementation SAForgetLoginPwdSetPwdViewModel

- (void)dealloc {
    [_resetLoginPasswordRequest cancel];
}

- (CMNetworkRequest *)resetLoginPasswordWithPlainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:plainPwd publicKey:rspModel.publicKey];
        [self _resetLoginPasswordWithPwdSecurityStr:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.resetLoginPasswordRequest;
}

#pragma mark - private methods
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

#pragma mark - getter
- (NSString *)fullAccountNo {
    return [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
}

#pragma mark - lazy load
- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    return _getEncryptFactorDTO ?: ({ _getEncryptFactorDTO = SAGetEncryptFactorDTO.new; });
}

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
