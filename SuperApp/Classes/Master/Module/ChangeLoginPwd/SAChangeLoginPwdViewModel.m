//
//  SAChangeLoginPwdViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeLoginPwdViewModel.h"
#import "SAGetEncryptFactorDTO.h"


@interface SAChangeLoginPwdViewModel ()
/// 获取加密因子 VM
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;
/// 修改密码
@property (nonatomic, strong) CMNetworkRequest *changeLoginPasswordRequest;

@end


@implementation SAChangeLoginPwdViewModel

- (void)dealloc {
    [_changeLoginPasswordRequest cancel];
}

- (CMNetworkRequest *)changeLoginPasswordWithOldPlainPwd:(NSString *)oldPlainPwd plainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:plainPwd publicKey:rspModel.publicKey];
        NSString *oldPwdSecurityStr = [RSACipher encrypt:oldPlainPwd publicKey:rspModel.publicKey];
        [self _changeLoginPasswordWithPwdSecurityStr:pwdSecurityStr oldPwdSecurityStr:oldPwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.changeLoginPasswordRequest;
}

#pragma mark - private methods
- (CMNetworkRequest *)_changeLoginPasswordWithPwdSecurityStr:(NSString *)pwdSecurityStr
                                           oldPwdSecurityStr:(NSString *)oldPwdSecurityStr
                                                       index:(NSString *)index
                                                     success:(void (^)(void))successBlock
                                                     failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"oldPwd"] = oldPwdSecurityStr;
    params[@"newPwd"] = pwdSecurityStr;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    self.changeLoginPasswordRequest.requestParameter = params;
    [self.changeLoginPasswordRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.changeLoginPasswordRequest;
}

#pragma mark - lazy load
- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    return _getEncryptFactorDTO ?: ({ _getEncryptFactorDTO = SAGetEncryptFactorDTO.new; });
}

- (CMNetworkRequest *)changeLoginPasswordRequest {
    if (!_changeLoginPasswordRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/password/update.do";

        _changeLoginPasswordRequest = request;
    }
    return _changeLoginPasswordRequest;
}

@end
