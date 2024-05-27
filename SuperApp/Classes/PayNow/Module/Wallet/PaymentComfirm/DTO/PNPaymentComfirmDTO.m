//
//  PNPaymentComfirmDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentComfirmDTO.h"
#import "PNPaymentComfirmRspModel.h"
#import "PNPaymentResultRspModel.h"
#import "PNRspModel.h"


@implementation PNPaymentComfirmDTO
// 确认支付币种汇兑信息
- (void)getTradePaymentInfo:(NSString *)tradeNo
                       type:(PNWalletBalanceType)type
                     payWay:(NSString *)payWay
                    success:(void (^_Nullable)(PNPaymentComfirmRspModel *rspModel))successBlock
                    failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/query/balance";

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setValue:tradeNo forKey:@"tradeNo"];
    if (type != PNWalletBalanceType_Non) {
        [dict setValue:@(type) forKey:@"balanceTypeEnum"];
    }

    if (WJIsStringNotEmpty(payWay)) {
        [dict setValue:payWay forKey:@"payWay"];
    }

    request.requestParameter = dict;

    //
    HDLog(@"请求入参：%@", [request.requestParameter yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNPaymentComfirmRspModel *listModel = [PNPaymentComfirmRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 中台下单 【copy 了一份过来用】
- (void)submitOrderParamsWithPaymentMethod:(HDCheckStandPaymentTools)payWay
                                   tradeNo:(NSString *)tradeNo
                           paymentCurrency:(NSInteger)paymentCurrency
                                   success:(void (^_Nullable)(HDCheckStandOrderSubmitParamsRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/super-payment/payment/quick-create";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"payWay"] = payWay;
    params[@"tradeNo"] = tradeNo;
    params[@"payScene"] = @"APP";
    params[@"paymentCurrency"] = @(paymentCurrency);

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDCheckStandOrderSubmitParamsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询支付结果页
- (void)getPaymentResultWithTradeNo:(NSString *)tradeNo success:(void (^_Nullable)(PNPaymentResultRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/unify/payResult";
    request.requestParameter = @{
        @"tradeNo": tradeNo,
    };

    //
    HDLog(@"请求入参：%@", [request.requestParameter yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNPaymentResultRspModel *listModel = [PNPaymentResultRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
