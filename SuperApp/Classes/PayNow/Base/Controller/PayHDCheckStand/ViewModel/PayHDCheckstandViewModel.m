

//
//  PayHDCheckstandViewModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckstandViewModel.h"
#import "PNCheckstandDTO.h"
#import "PNMSWitdrawDTO.h"
#import "PNRspModel.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "PayHDTradeCreatePaymentRspModel.h"
#import "PayHDTradeSubmitPaymentRspModel.h"


@interface PayHDCheckstandViewModel ()
@property (nonatomic, strong) PNCheckstandDTO *standDTO;
@property (nonatomic, strong) PNMSWitdrawDTO *withdrawDTO;
@end


@implementation PayHDCheckstandViewModel

/// 关闭业务订单
- (void)pn_tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.standDTO pn_tradeClosePaymentWithTradeNo:tradeNo success:successBlock failure:failureBlock];
}

///出金 资金/支付受理 [coolcash]
- (void)coolCashOutCashAcceptWithTradeNo:(NSString *)tradeNo
                         paymentCurrency:(NSInteger)paymentCurrency
                           methodPayment:(PNCashToolsMethodPaymentItemModel *_Nullable)methodPayment
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.standDTO coolCashOutCashAcceptWithTradeNo:tradeNo paymentCurrency:paymentCurrency methodPayment:methodPayment success:successBlock failure:failureBlock];
}

/// 获取支付工具 [返回订单支持的支付方式，比如钱包USD、钱包KHR、或者其他支付方式]
- (void)paymentTools:(NSString *)tradeNo success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.standDTO paymentTools:tradeNo success:successBlock failure:failureBlock];
}

- (void)cashTool:(NSString *)tradeNo success:(void (^)(PNCashToolsRspModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    [self.standDTO cashTool:tradeNo success:successBlock failure:failureBlock];
}
/// 下单
- (void)pn_tradeCreatePaymentWithAmount:(NSString *)amountStr
                               currency:(NSString *)currency
                                tradeNo:(NSString *)tradeNo
                                success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.standDTO pn_tradeCreatePaymentWithAmount:amountStr currency:currency tradeNo:tradeNo success:successBlock failure:failureBlock];
}

/// 订单确认 [确认支付]
- (void)pn_tradeConfirmPaymentWithTradeNo:(NSString *)tradeNo
                          paymentCurrency:(NSInteger)paymentCurrency
                                  success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.standDTO pn_tradeConfirmPaymentWithTradeNo:tradeNo paymentCurrency:paymentCurrency payWay:@"" success:successBlock failure:failureBlock];
}

/// 提现 下单
- (void)ms_withdrawToBankCardCreateOrder:(NSString *)amountStr
                                currency:(NSString *)currency
                           accountNumber:(NSString *)accountNumber
                         participantCode:(NSString *)participantCode
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:amountStr forKey:@"orderAmt"];
    [dict setValue:currency forKey:@"currency"];
    [dict setValue:accountNumber forKey:@"accountNumber"];
    [dict setValue:participantCode forKey:@"participantCode"];

    [self.withdrawDTO bankCardWithdrawMSCreateOrderWithParam:dict success:^(PNRspModel *_Nonnull rspModel) {
        PayHDTradeConfirmPaymentRspModel *model = [PayHDTradeConfirmPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:failureBlock];
}

#pragma mark
- (PNCheckstandDTO *)standDTO {
    if (!_standDTO) {
        _standDTO = [[PNCheckstandDTO alloc] init];
    }
    return _standDTO;
}

- (PNMSWitdrawDTO *)withdrawDTO {
    if (!_withdrawDTO) {
        _withdrawDTO = [[PNMSWitdrawDTO alloc] init];
    }
    return _withdrawDTO;
}
@end
