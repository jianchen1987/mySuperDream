//
//  PNInterTransferDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNCommonUtils.h"
#import "PNInterTransRecordModel.h"
#import "PNInterTransferConfirmInfoModel.h"
#import "PNInterTransferCreateOrderModel.h"
#import "PNInterTransferPayerInfoModel.h"
#import "PNInterTransferQuotaAndRateModel.h"
#import "PNInterTransferRateFeeModel.h"
#import "PNInterTransferRiskListModel.h"
#import "PNNeedInputInviteCodeRspModel.h"
#import "PNRspModel.h"
#import "PNWalletHomeBannerModel.h"
#import "SAUser.h"
#import "VipayUser.h"


@implementation PNInterTransferDTO
/// 查询汇率和手续费规则
- (void)queryRateFeeWithChannel:(PNInterTransferThunesChannel)channel success:(void (^)(PNInterTransferRateFeeModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/thunes/rate-fee/query";
    request.requestParameter = @{
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransferRateFeeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取全部的风控限制
- (void)queryriskListWithChannel:(PNInterTransferThunesChannel)channel
                         success:(void (^)(NSArray<PNInterTransferRiskListModel *> *_Nonnull rspArray))successBlock
                         failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/riskControl/list";
    request.requestParameter = @{
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:PNInterTransferRiskListModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询手续费
- (void)queryFeeWithAmount:(NSString *)amount channel:(PNInterTransferThunesChannel)channel success:(void (^)(NSString *charge))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/thunes/calculateFee";

    request.requestParameter = @{
        @"sentAmount": @{@"amount": [PNCommonUtils yuanTofen:amount], @"currency": PNCurrencyTypeUSD},
        @"currency": PNCurrencyTypeUSD,
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSNumber *num = rspModel.data;
        NSString *chargeStr = [NSString stringWithFormat:@"%@", num];
        !successBlock ?: successBlock(chargeStr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 增加付款人信息
- (void)openInterTransferAccount:(NSString *)beneficiaryId channel:(PNInterTransferThunesChannel)channel success:(void (^)(void))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/payer/savePayerInfo";
    request.isNeedLogin = YES;

    /// beneficiaryId 这个参数为了校验收款人在支付宝的信息
    request.requestParameter = @{
        @"beneficiaryId": beneficiaryId,
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询额度和汇率
- (void)queryQuotaAndExchangeRateSuccess:(void (^)(PNInterTransferQuotaAndRateModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/thunes/queryQuotaAndExchangeRate";
    request.requestParameter = @{@"payoutCurrency": @"USD", @"receiverCurrency": @"CNY"};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransferQuotaAndRateModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询付款人信息
- (void)queryPayerInfoWithPayOutAmount:(NSString *)payOutAmount
                              currency:(NSString *)currency
                                msisdn:(NSString *)msisdn
                               channel:(PNInterTransferThunesChannel)channel
                               success:(void (^)(PNInterTransferPayerInfoModel *payerInfoModel))successBlock
                               failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/payer/queryPayerInformation";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{
        @"payOutAmount": payOutAmount,
        @"payOutCurrency": currency,
        @"receiverCurrency": @"CNY",
        @"msisdn": msisdn,
        @"channel": @(channel),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransferPayerInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 反洗钱校验
- (void)amlAnalyzeVerificationWithReciverName:(NSString *)reciverName
                                       idType:(NSString *)idType
                                   receiverID:(NSString *)receiverID
                                      success:(void (^)(void))successBlock
                                      failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/AmlAnalyze/verification";
    NSString *senderName = [NSString stringWithFormat:@"%@%@", [VipayUser shareInstance].lastName, [VipayUser shareInstance].firstName];
    request.requestParameter = @{
        @"receiverName": reciverName,
        @"senderID": idType,
        @"receiverID": receiverID,
        @"senderName": senderName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 下单
- (void)createOrderWithCreateModel:(PNInterTransferCreateOrderModel *)createModel
                           channel:(PNInterTransferThunesChannel)channel
                           success:(void (^)(PNInterTransferConfirmInfoModel *confirmModel))successBlock
                           failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/order_info/create";
    NSMutableDictionary *dict = [createModel yy_modelToJSONObject];
    dict[@"account"] = [VipayUser shareInstance].loginName;
    dict[@"senderIphone"] = [VipayUser shareInstance].loginName;
    dict[@"senderName"] = [NSString stringWithFormat:@"%@%@", [VipayUser shareInstance].lastName, [VipayUser shareInstance].firstName];
    dict[@"channel"] = @(channel);
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = dict;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransferConfirmInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取支付结果
- (void)getPayResultWithOrderNo:(NSString *)orderNo success:(void (^)(PNInterTransRecordModel *confirmModel))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.isNeedLogin = YES;
    request.requestURI = @"/fxt/app/order_info/status";
    request.requestParameter = @{@"orderNo": orderNo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransRecordModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 检查付款人是否可以使用国际转账功能
- (void)checkInterTransfer:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/payer/checkPayerTransferAuthority";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.isNeedLogin = YES;
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// Banner广告
- (void)getWalletHomeBanner:(void (^_Nullable)(NSArray<PNWalletHomeBannerModel *> *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/marketing/advertisement";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:PNWalletHomeBannerModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 是否是首单需要输入邀请码
- (void)checkNeedInputInvitationCode:(void (^)(PNNeedInputInviteCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/marketing/confirmFirstOrder";
    request.isNeedLogin = YES;
    request.requestParameter = @{
        @"userNo": SAUser.shared.operatorNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNNeedInputInviteCodeRspModel *model = [PNNeedInputInviteCodeRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 校验&绑定激活码
- (void)bindingInviteCode:(NSString *)inviteCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/marketing/bindingInviteCode";
    request.isNeedLogin = YES;
    request.requestParameter = @{
        @"userNo": SAUser.shared.operatorNo,
        @"inviteCode": inviteCode,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
