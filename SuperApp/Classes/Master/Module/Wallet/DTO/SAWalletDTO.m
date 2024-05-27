//
//  SAWalletDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletDTO.h"
#import "NSDate+Extension.h"
#import "SAEnableWalletRspModel.h"
#import "SAGetEncryptFactorDTO.h"
#import "SAMoneyModel.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "SAUser.h"
#import "SAVerifySMSCodeRspModel.h"
#import "SAWalletBalanceModel.h"
#import "SAWalletBillDetailRspModel.h"
#import "SAWalletBillListRspModel.h"
#import "SAWalletChargeCreateRspModel.h"
#import "WMRspModel.h"


@interface SAWalletDTO ()
/// 查询余额
@property (nonatomic, strong) CMNetworkRequest *queryBalanceRequest;
/// 开通钱包
@property (nonatomic, strong) CMNetworkRequest *enableWalletRequest;
/// 充值单创建
@property (nonatomic, strong) CMNetworkRequest *createChargeOrderRequest;
/// 账单查询
@property (nonatomic, strong) CMNetworkRequest *queryBillListRequest;
/// 账单详情查询
@property (nonatomic, strong) CMNetworkRequest *queryBillDetailRequest;
/// 发送短信验证码
@property (nonatomic, strong) CMNetworkRequest *sendSMSCodeRequest;
/// 校验短信验证码
@property (nonatomic, strong) CMNetworkRequest *verifySMSCodeRequest;
/// 校验支付密码
@property (nonatomic, strong) CMNetworkRequest *verifyPayPwdRequest;
/// 修改支付密码
@property (nonatomic, strong) CMNetworkRequest *changePayPwdRequest;
/// 获取加密因子
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;

@property (nonatomic, strong) CMNetworkRequest *queryAvaliableChannelReq; ///< 查询可用的渠道

@property (nonatomic, strong) CMNetworkRequest *queryHistoryBillList; ///<
@end


@implementation SAWalletDTO
- (void)dealloc {
    [_queryBalanceRequest cancel];
    [_enableWalletRequest cancel];
    [_createChargeOrderRequest cancel];
    [_queryBillListRequest cancel];
    [_sendSMSCodeRequest cancel];
    [_verifySMSCodeRequest cancel];
    [_verifyPayPwdRequest cancel];
    [_changePayPwdRequest cancel];
    [_queryAvaliableChannelReq cancel];
    [_queryHistoryBillList cancel];
}

- (CMNetworkRequest *)queryBalanceSuccess:(void (^)(SAWalletBalanceModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SAUser.shared.operatorNo forKey:@"operatorNo"];
    [params setValue:SAUser.getUserMobile forKey:@"loginName"];
    self.queryBalanceRequest.requestParameter = params;
    [self.queryBalanceRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWalletBalanceModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryBalanceRequest;
}

- (CMNetworkRequest *)enableWalletWithPassword:(NSString *)password
                                     firstName:(NSString *)firstName
                                      lastName:(NSString *)lastName
                                        gender:(NSInteger)gender
                                       headUrl:(NSString *)headUrl
                                      birthday:(NSString *)birthday
                                       success:(void (^_Nullable)(SAEnableWalletRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:password publicKey:rspModel.publicKey];
        HDLog(@"index: %@  _  %@", rspModel.index, pwdSecurityStr);
        [self _enableWalletWithPassword:pwdSecurityStr index:rspModel.index firstName:firstName lastName:lastName gender:gender headUrl:headUrl birthday:birthday success:successBlock
                                failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.enableWalletRequest;
}

- (CMNetworkRequest *)createChargeOrderWithPayAmt:(SAMoneyModel *)payAmt
                                          success:(void (^_Nullable)(SAWalletChargeCreateRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"payAmt"] = @{@"cy": payAmt.cy, @"cent": payAmt.cent};
    params[@"tradeOrigin"] = @"APP";
    self.createChargeOrderRequest.requestParameter = params;
    [self.createChargeOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWalletChargeCreateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.createChargeOrderRequest;
}

- (CMNetworkRequest *)queryWalletBillListWithPageSize:(NSUInteger)pageSize
                                              pageNum:(NSUInteger)pageNum
                                              success:(void (^_Nullable)(SAWalletBillListRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);

    self.queryBillListRequest.requestParameter = params;
    [self.queryBillListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWalletBillListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryBillListRequest;
}

- (CMNetworkRequest *)queryWalletHistoryBillListWithPageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(SAWalletBillListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);

    self.queryHistoryBillList.requestParameter = params;
    [self.queryHistoryBillList startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWalletBillListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryHistoryBillList;
}

- (CMNetworkRequest *)queryWalletBillDetailWithTradeNo:(NSString *)tradeNo
                                               success:(void (^_Nullable)(SAWalletBillDetailRspModel *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradeNo"] = tradeNo;
    self.queryBillDetailRequest.requestParameter = params;
    [self.queryBillDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWalletBillDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryBillDetailRequest;
}

- (CMNetworkRequest *)sendSMSCodeSuccess:(void (^)(NSString *serialNum))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.sendSMSCodeRequest.requestParameter = params;
    [self.sendSMSCodeRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *data = (NSDictionary *)rspModel.data;
        NSString *number = @"";
        if ([data isKindOfClass:NSDictionary.class]) {
            number = data[@"serialNum"];
        }
        !successBlock ?: successBlock(number);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.sendSMSCodeRequest;
}

- (CMNetworkRequest *)verifySMSCodeWithSmsCode:(NSString *)smsCode
                                     serialNum:(NSString *)serialNum
                                       success:(void (^)(SAVerifySMSCodeRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"smsCode"] = smsCode;
    params[@"serialNum"] = serialNum;
    self.verifySMSCodeRequest.requestParameter = params;
    [self.verifySMSCodeRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAVerifySMSCodeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.verifySMSCodeRequest;
}

- (CMNetworkRequest *)verifyOriginalPayPwdWithPassword:(NSString *)password success:(void (^)(NSString *accessToken))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:password publicKey:rspModel.publicKey];
        [self _verifyOriginalPayPwdWithPassword:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.verifyPayPwdRequest;
}

- (CMNetworkRequest *)changePayPwdWithPassword:(NSString *)password accessToken:(NSString *)accessToken success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:password publicKey:rspModel.publicKey];
        [self _changePayPwdWithPassword:pwdSecurityStr index:rspModel.index accessToken:accessToken success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.verifyPayPwdRequest;
}

#pragma mark - private methods
- (CMNetworkRequest *)_changePayPwdWithPassword:(NSString *)password
                                          index:(NSString *)index
                                    accessToken:(NSString *)accessToken
                                        success:(void (^)(void))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"newTradePwd"] = password;
    params[@"accessToken"] = accessToken;
    params[@"index"] = index;
    self.changePayPwdRequest.requestParameter = params;
    [self.changePayPwdRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.changePayPwdRequest;
}

- (CMNetworkRequest *)_verifyOriginalPayPwdWithPassword:(NSString *)password index:(NSString *)index success:(void (^)(NSString *accessToken))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"oldTradePwd"] = password;
    params[@"index"] = index;
    self.verifyPayPwdRequest.requestParameter = params;
    [self.verifyPayPwdRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *data = (NSDictionary *)rspModel.data;
        NSString *number = @"";
        if ([data isKindOfClass:NSDictionary.class]) {
            number = data[@"accessToken"];
        }
        !successBlock ?: successBlock(number);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.verifyPayPwdRequest;
}

- (CMNetworkRequest *)_enableWalletWithPassword:(NSString *)password
                                          index:(NSString *)index
                                      firstName:(NSString *)firstName
                                       lastName:(NSString *)lastName
                                         gender:(NSInteger)gender
                                        headUrl:(NSString *)headUrl
                                       birthday:(NSString *)birthday
                                        success:(void (^_Nullable)(SAEnableWalletRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"pwd"] = password;
    params[@"userNo"] = SAUser.shared.operatorNo;
    params[@"firstName"] = firstName;
    params[@"lastName"] = lastName;
    params[@"sex"] = @(gender);
    params[@"headUrl"] = headUrl;
    ///接口需要到毫秒
    NSInteger timesTap = [NSDate dateStringddMMyyyyHHmmss:birthday] * 1000;
    params[@"birthday"] = @(timesTap);
    HDLog(@"enableWallet: %@", params);
    self.enableWalletRequest.requestParameter = params;
    [self.enableWalletRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAEnableWalletRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.enableWalletRequest;
}

- (void)queryAvaliableChannelWithTransType:(HDWalletTransType)transType
                                clientType:(SAClientType)clientType
                                   success:(void (^)(NSArray<NSString *> *channels))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/super-payment/payment/dynamic-tools";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizType"] = @(transType);
    if ([clientType isEqualToString:SAClientTypeViPay]) {
        params[@"payeeNo"] = @"ViPay";
    } else {
        params[@"payeeTradeType"] = clientType;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SAQueryAvaliableChannelRspModel *result = [SAQueryAvaliableChannelRspModel yy_modelWithJSON:rspModel.data];
        NSMutableArray<NSString *> *channels = [[NSMutableArray alloc] initWithCapacity:5];
        for (SAPaymentChannelModel *model in result.payWays) {
            if (HDWalletPaymethodBalance == model.code) {
                [channels addObject:@"ic_channel_wallet"];
            }
            if (HDWalletPaymethodWechat == model.code) {
                [channels addObject:@"ic_channel_wechat"];
            }
            if (HDWalletPaymethodABAPay == model.code) {
                [channels addObject:@"ic_channel_aba"];
            }
            if (HDWalletPaymethodCreditCard == model.code) {
                [channels addObject:@"ic_channel_visa"];
                [channels addObject:@"ic_channel_master"];
                [channels addObject:@"ic_channel_union"];
            }
            if (HDWalletPaymethodWingPay == model.code) {
                [channels addObject:@"ic_channel_wing"];
            }
        }
        !successBlock ?: successBlock(channels);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - lazy load
- (CMNetworkRequest *)queryBalanceRequest {
    if (!_queryBalanceRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/wallet/check/statusAndBalance.do";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _queryBalanceRequest = request;
    }
    return _queryBalanceRequest;
}

- (CMNetworkRequest *)enableWalletRequest {
    if (!_enableWalletRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/wallet/create.do";
        request.isNeedLogin = YES;
        _enableWalletRequest = request;
    }
    return _enableWalletRequest;
}

- (CMNetworkRequest *)createChargeOrderRequest {
    if (!_createChargeOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/recharge/create";
        _createChargeOrderRequest = request;
    }
    return _createChargeOrderRequest;
}

- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    if (!_getEncryptFactorDTO) {
        _getEncryptFactorDTO = SAGetEncryptFactorDTO.new;
    }
    return _getEncryptFactorDTO;
}

- (CMNetworkRequest *)queryBillListRequest {
    if (!_queryBillListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/wallet/bill/list";
        _queryBillListRequest = request;
    }
    return _queryBillListRequest;
}

- (CMNetworkRequest *)queryBillDetailRequest {
    if (!_queryBillDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/wallet/bill/detail";
        _queryBillDetailRequest = request;
    }
    return _queryBillDetailRequest;
}

- (CMNetworkRequest *)sendSMSCodeRequest {
    if (!_sendSMSCodeRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/sms/send.do";
        _sendSMSCodeRequest = request;
    }
    return _sendSMSCodeRequest;
}

- (CMNetworkRequest *)verifySMSCodeRequest {
    if (!_verifySMSCodeRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/smsCode/validate.do";
        _verifySMSCodeRequest = request;
    }
    return _verifySMSCodeRequest;
}

- (CMNetworkRequest *)verifyPayPwdRequest {
    if (!_verifyPayPwdRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/pwd/validate.do";
        _verifyPayPwdRequest = request;
    }
    return _verifyPayPwdRequest;
}

- (CMNetworkRequest *)changePayPwdRequest {
    if (!_changePayPwdRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/sa/pwd/modify.do";
        _changePayPwdRequest = request;
    }
    return _changePayPwdRequest;
}
- (CMNetworkRequest *)queryAvaliableChannelReq {
    if (!_queryAvaliableChannelReq) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/payment/dynamic-tools";
        request.isNeedLogin = YES;
        _queryAvaliableChannelReq = request;
    }
    return _queryAvaliableChannelReq;
}

- (CMNetworkRequest *)queryHistoryBillList {
    if (!_queryHistoryBillList) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/shop/super-payment/wallet/bill/list/vipay";
        //        request.requestURI = @"/shop/super-payment/wallet/bill/list";
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _queryHistoryBillList = request;
    }
    return _queryHistoryBillList;
}

@end
