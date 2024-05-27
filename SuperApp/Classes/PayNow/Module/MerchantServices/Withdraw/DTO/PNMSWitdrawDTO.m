//
//  PNMSCaseInDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWitdrawDTO.h"
#import "PNMSTransferCreateOrderRspModel.h"
#import "PNMSWithdranBankInfoModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSWitdrawDTO

/// 转账入金下单【商户入金到自己的钱包】
- (void)transferMSCreateOrderWithParam:(NSDictionary *)paramDict
                               success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant-agentcash/app/mer/agent/transfer/create/order.do";
    request.requestParameter = paramDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSTransferCreateOrderRspModel *model = [PNMSTransferCreateOrderRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 绑定银行卡 - 发送短信
- (void)bindBankCardSendSMSCodeWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/withdraw/addMerWithdrawBandCardSmsCode.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 绑定添加银行卡
- (void)bindBankWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/withdraw/addMerWithdrawBankCards.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询商户提现银行卡列表
- (void)getBankCradListWithCurrency:(PNCurrencyType)currency success:(void (^)(NSArray<PNMSWithdranBankInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/withdraw/bankCards.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [param setValue:currency forKey:@"currency"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:PNMSWithdranBankInfoModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 删除商户提现银行卡
- (void)deleteBankCard:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/withdraw/deleteMerWithdrawBandCard.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// wownow APP 商户服务提现 交易前检查接口
- (void)withdrawPreCheck:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/recharge/order/agent/walletWithdraw/check.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [param setValue:VipayUser.shareInstance.operatorNo forKey:@"operatorNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// APP 商户服务提现 下单接口
- (void)bankCardWithdrawMSCreateOrderWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/recharge/order/agent/walletWithdraw/createOrder.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [param setValue:VipayUser.shareInstance.operatorNo forKey:@"operatorNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 提现 支付密码校验
- (void)ms_withdrawAutoWithOrderNo:(NSString *)orderNo
                     cashVoucherNo:(NSString *)cashVoucherNo
                            payPwd:(NSString *)payPwd
                             index:(NSString *)index
                           funcCtl:(NSString *)funcCtl
                           success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/recharge/order/agent/walletWithdraw/auth.do";

    request.requestParameter = @{
        @"orderNo": orderNo,
        @"cashVoucherNo": cashVoucherNo,
        @"payPwd": payPwd,
        @"index": index,
        @"funcCtl": funcCtl,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询银行卡信息
- (void)queryBankCardInfo:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/withdraw/queryBankCardInfo.do";

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [param setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getList:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/wallet/page/list";

    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
