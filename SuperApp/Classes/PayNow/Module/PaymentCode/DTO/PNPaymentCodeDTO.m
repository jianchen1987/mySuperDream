//
//  PNPaymentCodeDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPaymentCodeDTO.h"
#import "SAUser.h"


@implementation PNPaymentCodeDTO

/// 查下用户业务
- (void)queryUserBussinessStatusWithType:(PNUserBussinessType)bussinessType success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    NSString *businessTypeStr = @"";
    if (bussinessType == PNUserBussinessTypePaymentCode) {
        businessTypeStr = @"12";
    }

    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.needSessionKey = true;
    request.requestURI = @"/biz-codepayment-service/trade/user/business/query";
    request.requestParameter = @{@"businessType": businessTypeStr};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 开通业务
- (void)openBussinessWithType:(PNUserBussinessType)bussinessType
                        index:(NSString *)index
                     password:(NSString *)password
                      success:(void (^)(PNRspModel *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    NSString *businessTypeStr = @"";
    if (bussinessType == PNUserBussinessTypePaymentCode) {
        businessTypeStr = @"12";
    }

    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/biz-codepayment-service/trade/user/business/create";
    request.requestParameter = @{
        @"businessType": businessTypeStr,
        @"index": index,
        @"password": password,
    };
    request.needSessionKey = true;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 用户关闭业务
- (void)closeBussinessWithType:(PNUserBussinessType)bussinessType success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    NSString *businessTypeStr = @"";
    NSString *operationType = @"";
    if (bussinessType == PNUserBussinessTypePaymentCode) {
        businessTypeStr = @"12"; //业务请求身份标识枚举 12付款码
        operationType = @"11";   //操作类型枚举(停用:11)
    }

    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/biz-codepayment-service/trade/user/business/pay/state/update";
    request.retryCount = 2;
    request.requestParameter = @{
        @"businessType": businessTypeStr,
        @"operationType": operationType,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 用户付款码支付结果查询
- (void)queryPaymentCodeResultWithContentQrCode:(NSString *)contentQrCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/biz-codepayment-service/trade/paycode/payment/query";
    request.requestParameter = @{@"contentQrCode": contentQrCode};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 免密支付 更新 【开启/停用】
- (void)updateCertifiledWithType:(PNUserBussinessType)bussinessType
                   operationType:(PNUserCertifiedTypes)operationType
                         success:(void (^)(PNRspModel *rspModel))successBlock
                         failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    ///// 免密支付 的更新
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/biz-codepayment-service/trade/user/business/pay/certified/update";
    request.requestParameter = @{
        @"businessType": @(bussinessType),
        @"operationType": @(operationType),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取收款码
- (void)genQRCodeByLoginName:(NSString *)loginName
                      Amount:(NSString *)amount
                    Currency:(NSString *)currency
                     success:(void (^)(PNRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/trade/bakong/individual/qr/create";
    request.retryCount = 2;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setValue:@(amount.doubleValue * 100) forKey:@"amount"];
    [params setValue:currency forKey:@"currency"];
    [params setValue:loginName forKey:@"merchantId"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
