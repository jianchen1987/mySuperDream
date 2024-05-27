//
//  PNPinCodeDTO.m
//  SuperApp
//
//  Created by seeu on 2023/9/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPinCodeDTO.h"
#import "PNRspModel.h"
#import "PNMSSMSValidateRspModel.h"


@implementation PNPinCodeDTO

+ (void)checkPinCodeExistsCompletion:(void (^)(BOOL isExist))completion {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/get.do";
    request.requestParameter = @{};
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSString *pinCode = [rspModel.data valueForKey:@"pinCode"];
        if (HDIsStringNotEmpty(pinCode)) {
            !completion ?: completion(YES);
        } else {
            !completion ?: completion(NO);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(NO);
    }];
}

+ (void)createPinCodeWithPinCode:(NSString *_Nonnull)pinCode index:(NSString *_Nonnull)index success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/create.do";
    request.requestParameter = @{
        @"pinCode" : pinCode,
        @"index" : index
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(nil, response.errorType, response.error);
    }];
    
    
}

+ (void)validatePinCodeWithPinCode:(NSString *_Nonnull)pinCode index:(NSString *_Nonnull)index success:(void (^_Nullable)(NSString *_Nullable token))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/validate.do";
    request.requestParameter = @{
        @"pinCode" : pinCode,
        @"index" : index
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSString *token = [rspModel.data valueForKey:@"accessToken"];
        if (HDIsStringNotEmpty(token)) {
            !successBlock ?: successBlock(token);
        } else {
            !successBlock ?: successBlock(nil);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(nil, response.errorType, response.error);
    }];
}

+ (void)modifyPinCodeWithNewPinCode:(NSString *_Nonnull)newPinCode token:(NSString *_Nonnull)token index:(NSString *_Nonnull)index success:(void (^_Nullable)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/modify.do";
    request.requestParameter = @{
        @"newPinCode" : newPinCode,
        @"index" : index,
        @"accessToken" : token
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(nil, response.errorType, response.error);
    }];
}

+ (void)forgotPinCodeSendSmsCompletion:(void (^_Nullable)(NSString *_Nullable serialNum))completion {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/reset/sendSms";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSString *serialNum = [rspModel.data valueForKey:@"serialNum"];
        if(HDIsStringNotEmpty(serialNum)) {
            !completion ?: completion(serialNum);
        } else {
            !completion ?: completion(nil);
        }
        
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(nil);
    }];
}

+ (void)validateForgotPinCodeSMSWithCode:(NSString *_Nonnull)code serialNum:(NSString *_Nonnull)serialNum success:(void (^_Nullable)(PNMSSMSValidateRspModel *_Nullable rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/pinCode/reset/verifySms";
    request.requestParameter = @{
        @"smsCode" : code,
        @"serialNum" : serialNum
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSSMSValidateRspModel *model = [PNMSSMSValidateRspModel yy_modelWithDictionary:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(nil, response.errorType, response.error);
    }];
}

@end
