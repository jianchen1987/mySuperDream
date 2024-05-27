//
//  SASettingPayPwdViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASettingPayPwdViewModel.h"
#import "PNIDVerifyDTO.h"
#import "PNUserPasswordDTO.h"
#import "SAGetEncryptFactorDTO.h"
#import "SAWalletDTO.h"
#import "PNPinCodeDTO.h"
#import "PNRspModel.h"


@interface SASettingPayPwdViewModel ()
/// 钱包 DTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;

@property (nonatomic, strong) PNUserPasswordDTO *userPwdDTO;

@property (nonatomic, strong) PNIDVerifyDTO *idVerfiyDTO;

@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;
@end


@implementation SASettingPayPwdViewModel

- (void)validatePassword:(NSString *)password {
}

- (CMNetworkRequest *)enableWalletWithPassword:(NSString *)password
                                     firstName:(NSString *)firstName
                                      lastName:(NSString *)lastName
                                        gender:(NSInteger)gender
                                       headUrl:(NSString *)headUrl
                                      birthday:(NSString *)birthday
                                       success:(void (^_Nullable)(SAEnableWalletRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    return [self.walletDTO enableWalletWithPassword:password firstName:firstName lastName:lastName gender:gender headUrl:headUrl birthday:birthday success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)verifyOriginalPayPwdWithPassword:(NSString *)password success:(void (^)(NSString *accessToken))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    return [self.walletDTO verifyOriginalPayPwdWithPassword:password success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)changePayPwdWithPassword:(NSString *)password accessToken:(NSString *)accessToken success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    return [self.walletDTO changePayPwdWithPassword:password accessToken:accessToken success:successBlock failure:failureBlock];
}

- (void)resetPwd:(NSString *)password success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.userPwdDTO resetPassword:password token:self.accessToken serialNumber:self.serialNumber success:successBlock failure:failureBlock];
}

/// 钱包激活
- (void)walletActivation:(NSString *)password {
    [self.view showloading];
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:password publicKey:rspModel.publicKey];
        [self.idVerfiyDTO walletActivation:rspModel.index pwd:pwdSecurityStr verifyParam:self.verifyParam success:^(PNRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];

            [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_settting_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];

            !self.successHandler ?: self.successHandler(true, true);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)createPinCodeWithPinCode:(NSString *_Nonnull)pinCode success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel * _Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:pinCode publicKey:rspModel.publicKey];
        @HDWeakify(self);
        [PNPinCodeDTO createPinCodeWithPinCode:pwdSecurityStr index:rspModel.index success:^{
            !successBlock ?: successBlock();
        } failure:^(PNRspModel * _Nullable rspModel, NSInteger errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !failureBlock ?: failureBlock(nil, errorType, error);
        }];
        
        
        } failure:^(SARspModel * _Nullable rspModel, CMResponseErrorType errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !failureBlock ?: failureBlock(nil, errorType, error);
        }];
}

- (void)validatePinCodeWithPinCode:(NSString *_Nonnull)pinCode success:(void (^_Nonnull)(NSString *_Nullable token, NSString * _Nullable errMsg))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel * _Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:pinCode publicKey:rspModel.publicKey];
        @HDWeakify(self);
        [PNPinCodeDTO validatePinCodeWithPinCode:pwdSecurityStr index:rspModel.index success:^(NSString * _Nullable token) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !completion ?: completion(token, nil);
            
        } failure:^(PNRspModel * _Nullable rspModel, NSInteger errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !completion ?: completion(nil, rspModel.msg);
        }];
        
        } failure:^(SARspModel * _Nullable rspModel, CMResponseErrorType errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !completion ?: completion(nil, rspModel.msg);
        }];
}

- (void)modifyPinCodeWithPinCode:(NSString *_Nonnull)newPinCode token:(NSString *_Nonnull)token success:(void (^_Nonnull)(void))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel * _Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:newPinCode publicKey:rspModel.publicKey];
        @HDWeakify(self);
        [PNPinCodeDTO modifyPinCodeWithNewPinCode:pwdSecurityStr token:token index:rspModel.index success:^{
            @HDStrongify(self);
            [self.view dismissLoading];
            !successBlock ?: successBlock();
        } failure:^(PNRspModel * _Nullable rspModel, NSInteger errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !failureBlock ?: failureBlock(nil, errorType, error);
        }];

        } failure:^(SARspModel * _Nullable rspModel, CMResponseErrorType errorType, NSError * _Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !failureBlock ?: failureBlock(nil, errorType, error);
        }];
}

#pragma mark - lazy load
- (SAWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = SAWalletDTO.new;
    }
    return _walletDTO;
}

- (PNUserPasswordDTO *)userPwdDTO {
    if (!_userPwdDTO) {
        _userPwdDTO = [[PNUserPasswordDTO alloc] init];
    }
    return _userPwdDTO;
}

- (PNIDVerifyDTO *)idVerfiyDTO {
    if (!_idVerfiyDTO) {
        _idVerfiyDTO = [[PNIDVerifyDTO alloc] init];
    }
    return _idVerfiyDTO;
}

- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    if (!_getEncryptFactorDTO) {
        _getEncryptFactorDTO = [[SAGetEncryptFactorDTO alloc] init];
    }
    return _getEncryptFactorDTO;
}
@end
