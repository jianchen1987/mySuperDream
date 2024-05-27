//
//  PNMSTradePwdViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSTradePwdViewModel.h"
#import "NSString+AES.h"
#import "NSString+MD5.h"
#import "PNCommonUtils.h"
#import "PNMSEncryptFactorRspModel.h"
#import "PNMSPwdDTO.h"
#import "RSACipher.h"


@interface PNMSTradePwdViewModel ()
@property (nonatomic, strong) PNMSPwdDTO *pwdDTO;
@end


@implementation PNMSTradePwdViewModel

/// 加密因子
- (NSString *)_aes_encryptionFactor:(NSString *)encrypFactor password:(NSString *)pwd {
    NSString *md5_1String = [NSString stringWithFormat:@"%@%@%@", @"Chaos", pwd, @"technology"];
    NSString *md5_1 = [md5_1String MD5];
    NSString *md5_2String = [NSString stringWithFormat:@"%@%@", md5_1, @"We!are@Family#"];
    NSString *md5_2 = [md5_2String MD5];
    NSString *AES_password = [md5_2 AES128CBCEncryptWithKey:encrypFactor andVI:@"A-16-Byte-String"];

    return AES_password;
}

/// 设置交易密码
- (void)saveTradePwd:(NSString *)pwd success:(void (^)(void))successBlock {
    [self.view showloading];
    NSString *random = [PNCommonUtils getRandomKey];

    @HDWeakify(self);
    [self.pwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self _savePwd:[self _aes_encryptionFactor:rspModel.encrypFactor password:pwd] index:rspModel.index success:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)_savePwd:(NSString *)securityTxt index:(NSString *)index success:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.pwdDTO saveMSTradePwd:securityTxt index:index operatorNo:self.operatorNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 校验交易密码
- (void)validatorTradePwd:(NSString *)pwd success:(void (^)(void))successBlock {
    [self.view showloading];
    NSString *random = [PNCommonUtils getRandomKey];

    @HDWeakify(self);
    [self.pwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self _validatorPwd:[self _aes_encryptionFactor:rspModel.encrypFactor password:pwd] index:rspModel.index success:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)_validatorPwd:(NSString *)securityTxt index:(NSString *)index success:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.pwdDTO validatorMSTradePwd:securityTxt index:index operatorNo:self.operatorNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 更新交易密码
- (void)updateTradePwd:(NSString *)pwd oldPwd:(NSString *)oldPwd success:(void (^)(void))successBlock {
    [self.view showloading];
    NSString *random = [PNCommonUtils getRandomKey];

    @HDWeakify(self);
    [self.pwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self _updatePwd:[self _aes_encryptionFactor:rspModel.encrypFactor password:pwd] oldSecurityTxt:[self _aes_encryptionFactor:rspModel.encrypFactor password:oldPwd] index:rspModel.index
                   success:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)_updatePwd:(NSString *)securityTxt oldSecurityTxt:(NSString *)oldSecurityTxt index:(NSString *)index success:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.pwdDTO updateMSTradePwd:securityTxt oldTradePwd:oldSecurityTxt index:index operatorNo:self.operatorNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 重新交易密码
- (void)resetTradePwd:(NSString *)pwd success:(void (^)(void))successBlock {
    [self.view showloading];
    NSString *random = [PNCommonUtils getRandomKey];

    @HDWeakify(self);
    [self.pwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self _resetPwd:[self _aes_encryptionFactor:rspModel.encrypFactor password:pwd] index:rspModel.index success:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)_resetPwd:(NSString *)securityTxt index:(NSString *)index success:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.pwdDTO resetMSTradePwd:securityTxt index:index operatorNo:self.operatorNo serialNumber:self.serialNumber token:self.token success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 重新交易密码 - 重置操作员密码
- (void)operatorResetTradePwd:(NSString *)pwd success:(void (^)(void))successBlock {
    [self.view showloading];
    NSString *random = [PNCommonUtils getRandomKey];

    @HDWeakify(self);
    [self.pwdDTO getMSEncryptFactorWithRandom:random success:^(PNMSEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self _operaotrResetPwd:[self _aes_encryptionFactor:rspModel.encrypFactor password:pwd] index:rspModel.index success:successBlock];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)_operaotrResetPwd:(NSString *)securityTxt index:(NSString *)index success:(void (^)(void))successBlock {
    @HDWeakify(self);
    [self.pwdDTO operatorResetMSTradePwd:securityTxt index:index operatorNo:self.operatorNo serialNumber:self.serialNumber token:self.token success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNMSPwdDTO *)pwdDTO {
    return _pwdDTO ?: ({ _pwdDTO = PNMSPwdDTO.new; });
}
@end
