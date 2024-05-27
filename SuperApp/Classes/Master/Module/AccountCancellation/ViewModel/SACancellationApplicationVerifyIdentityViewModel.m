//
//  SACancellationApplicationVerifyIdentityViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationVerifyIdentityViewModel.h"
#import "SACancellationReasonModel.h"


@interface SACancellationApplicationVerifyIdentityViewModel ()

@property (nonatomic, copy) NSString *countryCode;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, copy) NSString *fullAccountNo;

@property (nonatomic, strong) SACancellationReasonModel *model;

@end


@implementation SACancellationApplicationVerifyIdentityViewModel

- (instancetype)initWithModel:(SACancellationReasonModel *)model {
    if (self = [super initWithModel:model]) {
        self.model = model;
    }
    return self;
}

- (void)setLastLoginFullAccount:(NSString *)lastLoginFullAccount {
    _lastLoginFullAccount = lastLoginFullAccount;
    self.countryCode = [SAGeneralUtil getCountryCodeFromFullAccountNo:lastLoginFullAccount];
    self.accountNo = [SAGeneralUtil getShortAccountNoFromFullAccountNo:lastLoginFullAccount];
    self.fullAccountNo = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
}

- (void)getSMSCodeWithSuccess:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/sms/send.do";
    request.isNeedLogin = YES;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
    params[@"biz"] = @"CANCELLATION";

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)verifySMSCodeWithSmsCode:(NSString *)smsCode success:(nonnull void (^)(NSString *_Nullable))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/sms/verify.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"mobile"] = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
    params[@"biz"] = @"CANCELLATION";
    params[@"verifyCode"] = smsCode;

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *dic = (NSDictionary *)rspModel.data;
        NSString *apiTicket = dic[@"apiTicket"];
        !successBlock ?: successBlock(apiTicket);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)submitCanncellationApplicationWithApiTicket:(NSString *)apiTicket success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/cancellation/submit.do";
    request.isNeedLogin = YES;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cancellationReason"] = self.model.type;
    params[@"otherReason"] = self.model.reason;
    params[@"apiTicket"] = apiTicket;

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
