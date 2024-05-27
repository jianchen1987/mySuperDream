//
//  PNUserPasswordDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUserPasswordDTO.h"
#import "PNValidateSMSCodeRspModel.h"
#import "PNRspModel.h"
#import "SAGetEncryptFactorDTO.h"


@interface PNUserPasswordDTO ()
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;
@end


@implementation PNUserPasswordDTO
/// 修改用户支付密码Step2:用户端验证短信
- (void)validateSMSCode:(NSString *)smsCode success:(void (^_Nullable)(PNValidateSMSCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/sa/user/tradePwd/reset/validateSms.do";

    request.requestParameter = @{
        @"customerType": @"PERSON",
        @"smsSendTemplate": @(12),
        @"smsCode": smsCode,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNValidateSMSCodeRspModel *infoModel = [PNValidateSMSCodeRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(infoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 修改用户支付密码Step3:确认修改交易密码
- (void)resetPassword:(NSString *)newTradePwd
                token:(NSString *)token
         serialNumber:(NSString *)serialNumber
              success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
              failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        NSString *pwdSecurityStr = [RSACipher encrypt:newTradePwd publicKey:rspModel.publicKey];
        [self _resetPassword:pwdSecurityStr index:rspModel.index token:token serialNumber:serialNumber success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !failureBlock ?: failureBlock([PNRspModel yy_modelWithJSON:[rspModel yy_modelToJSONString]], errorType, error);
    }];
}

- (void)_resetPassword:(NSString *)newTradePwd
                 index:(NSString *)index
                 token:(NSString *)token
          serialNumber:(NSString *)serialNumber
               success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
               failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/sa/user/tradePwd/reset/confirm.do";

    request.requestParameter = @{@"newTradePwd": newTradePwd, @"index": index, @"token": token, @"serialNumber": serialNumber};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark
- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    if (!_getEncryptFactorDTO) {
        _getEncryptFactorDTO = SAGetEncryptFactorDTO.new;
    }
    return _getEncryptFactorDTO;
}

@end
