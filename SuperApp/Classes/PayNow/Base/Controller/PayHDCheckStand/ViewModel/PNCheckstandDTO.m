//
//  PNCheckstandDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCheckstandDTO.h"
#import "PNCashToolsRspModel.h"
#import "PNRspModel.h"
#import "PNUtilMacro.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "PayHDTradeCreatePaymentRspModel.h"


@implementation PNCheckstandDTO

/// 关闭订单
- (void)pn_tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/trade/order/close";
    request.requestParameter = @{@"tradeNo": tradeNo};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSDictionary *dict = rspModel.data;
        NSString *tradeNo = @"";
        if ([dict.allKeys containsObject:@"tradeNO"]) {
            tradeNo = dict[@"tradeNo"];
        }
        !successBlock ?: successBlock(tradeNo);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

///出金 资金/支付受理 [coolcash]
- (void)coolCashOutCashAcceptWithTradeNo:(NSString *)tradeNo
                         paymentCurrency:(NSInteger)paymentCurrency
                           methodPayment:(PNCashToolsMethodPaymentItemModel *_Nullable)methodPayment
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/cashier-front-service/cash/accept";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setValue:tradeNo forKey:@"tradeNo"];
    [dict setValue:@(paymentCurrency) forKey:@"paymentCurrency"];

    if (!WJIsObjectNil(methodPayment)) {
        NSMutableDictionary *newMethodDict = [NSMutableDictionary dictionaryWithDictionary:[methodPayment yy_modelToJSONObject]];
        NSString *amount = [PNCommonUtils fenToyuan:[PNCommonUtils yuanTofen:[NSString stringWithFormat:@"%@", [newMethodDict objectForKey:@"amount"]]]];
        [newMethodDict setValue:amount forKey:@"amount"];

        [dict setValue:@[newMethodDict] forKey:@"methodPayment"];
    }

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeConfirmPaymentRspModel *tradeSubmitModel = [PayHDTradeConfirmPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(tradeSubmitModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取支付工具 [返回订单支持的支付方式，比如钱包USD、钱包KHR、或者其他支付方式]
- (void)paymentTools:(NSString *)tradeNo success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/payment/tool";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{
        @"tradeNo": tradeNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeCreatePaymentRspModel *model = [PayHDTradeCreatePaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 下单
- (void)pn_tradeCreatePaymentWithAmount:(NSString *)amountStr
                               currency:(NSString *)currency
                                tradeNo:(NSString *)tradeNo
                                success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/payment/create";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSDictionary *dict = @{@"cent": amountStr, @"cy": currency};

    NSDictionary *paramDict = @{@"orderAmt": dict, @"tradeNo": tradeNo};

    request.requestParameter = paramDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeCreatePaymentRspModel *model = [PayHDTradeCreatePaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 订单确认 [确认支付] - 新的支付收银台用
- (void)pn_tradeConfirmPaymentWithTradeNo:(NSString *)tradeNo
                          paymentCurrency:(NSInteger)paymentCurrency
                                   payWay:(NSString *)payWay
                                  success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/v3/payment/confirm";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:3];
    parameter[@"tradeNo"] = tradeNo;
    parameter[@"paymentCurrency"] = @(paymentCurrency);

    if (WJIsStringNotEmpty(payWay)) {
        parameter[@"payWay"] = payWay;
    }

    request.requestParameter = parameter;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeConfirmPaymentRspModel *model = [PayHDTradeConfirmPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取资金工具
- (void)cashTool:(NSString *)tradeNo success:(void (^_Nullable)(PNCashToolsRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/cashier-front-service/cash/tools";
    request.requestParameter = @{
        @"tradeNo": tradeNo,
        @"payScene": @"APP",
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNCashToolsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
