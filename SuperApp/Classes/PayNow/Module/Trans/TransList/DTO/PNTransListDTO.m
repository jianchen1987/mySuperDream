//
//  PNTransListDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransListDTO.h"
#import "HDAnalysisQRCodeRspModel.h"
#import "HDPayeeInfoModel.h"
#import "HDTransferOrderBuildRspModel.h"
#import "HDUserBillDetailRspModel.h"
#import "PNBillListRspModel.h"
#import "PNQueryWithdrawCodeModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNTransListDTO

/// 获取转账列表配置
- (void)getPayNowTransListConfig:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/user/config.do";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取最近转账联系人
- (void)getPayNowTransferUser:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/queryTransferUser.do";

    request.requestParameter = @{
        @"loginName": [VipayUser shareInstance].loginName,
        @"userNo": [VipayUser shareInstance].userNo,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 收藏/取消 最近联系人
- (void)userCollectAction:(NSInteger)flag
                  rivalNo:(NSString *)rivalNo
                  bizType:(PNTransferType)bizEntity
                  success:(void (^_Nullable)(void))successBlock
                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;

    if (flag == 0) {
        request.requestURI = @"/bill/user/collect.do";
    } else {
        request.requestURI = @"/bill/user/cancel.do";
    }

    request.requestParameter = @{
        @"userNo": [VipayUser shareInstance].userNo,
        @"rivalNo": rivalNo,
        @"bizType": bizEntity

    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //            PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取对应的 收款人信息
- (void)getPayeeInfo:(NSDictionary *)paramsDict
             bizType:(PNTransferType)bizType
             success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock
             failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    // 1001-转账到个人 1002-转账到bakong 1003-转账到银行
    NSString *requestURI = @"";
    if ([bizType isEqualToString:PNTransferTypeToCoolcash]) {
        //查询 coolcash 收款账户基本信息
        requestURI = @"/usercenter/info/query.do";
    } else if ([bizType isEqualToString:PNTransferTypePersonalToBaKong]) {
        //查询 bakong 收款账户基本信息
        requestURI = @"/merchant-agentcash/app/mer/agent/bakong/accountInfo.do";
    } else if ([bizType isEqualToString:PNTransferTypePersonalToBank]) {
        //查询 银行 收款账户基本信息
        requestURI = @"/merchant-agentcash/app/mer/agent/bakong/bank/accountInfo.do";
    } else {
        NSAssert(requestURI, @"requestURI不能为空");
    }

    request.requestURI = requestURI;
    request.requestParameter = paramsDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDPayeeInfoModel *infoModel = [HDPayeeInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(infoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取对应的 收款人信息 - 针对bakong二维码解析
- (void)getPayeeInfoFromBaKongQRCodeWithAccuontNo:(NSString *)accountNo
                                       merchantId:(NSString *)merchantId
                                     merchantType:(NSString *)merchantType
                                    terminalLabel:(NSString *)terminalLabel
                                          success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock
                                          failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant-agentcash/app/mer/agent/bakong/qr/pay/parse.do";
    /// 自行在外层处理错误 - 因为要扫描动画要重新触发
    //    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{
        @"accountNo": accountNo,
        @"merchantId": merchantId,
        @"merchantType": merchantType,
        @"terminalLabel": terminalLabel,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDPayeeInfoModel *infoModel = [HDPayeeInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(infoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取对应的 收款人信息 - 针对Coolcash二维码解析
- (void)getPayeeInfoFromCoolcashQRCodeWithQRData:(NSString *)qrData success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant-agentcash/app/mer/agent/qr/pay/parse.do";
    /// 自行在外层处理错误 - 因为要扫描动画要重新触发
    //    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{
        @"qrData": qrData ?: @"",
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDPayeeInfoModel *infoModel = [HDPayeeInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(infoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// coolcash出金确认
- (void)coolcashOutConfirmOrderWithFeeAmt:(NSString *)feeAmt
                                   payAmt:(NSString *)payAmt
                                  orderNo:(NSString *)orderNo
                                  purpose:(NSString *)purpose
                                  success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant-agentcash/app/mer/agent/confirm/order.do";

    request.requestParameter = @{
        @"feeAmt": feeAmt,
        @"payAmt": payAmt,
        @"orderNo": orderNo,
        @"purpose": purpose,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDTransferOrderBuildRspModel *orderBuildModer = [HDTransferOrderBuildRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(orderBuildModer);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 转账下单
- (void)outConfirmOrderWithParams:(NSDictionary *)paramsDict
    shouldAlertErrorMsgExceptSpecCode:(BOOL)errorAlert
                              success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock
                              failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/transfer/build.do";
    request.requestParameter = paramsDict;
    request.shouldAlertErrorMsgExceptSpecCode = errorAlert;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDTransferOrderBuildRspModel *orderBuildModel = [HDTransferOrderBuildRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(orderBuildModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取交易列表
- (void)getTransOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNBillListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/queryBillList.do";
    request.requestParameter = paramsDict;

    HDLog(@"请求入参：%@", [paramsDict yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNBillListRspModel *listModel = [PNBillListRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取交易详情/订单详情
- (void)getTransOrderDetailWithtTadeNo:(NSString *)tradeNo
                             tradeType:(NSString *)tradeType
                               success:(void (^_Nullable)(HDUserBillDetailRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/checkUserBillDetail.do";

    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramsDict setValue:tradeNo ?: @"" forKey:@"tradeNo"];
    if (HDIsStringNotEmpty(tradeType)) {
        [paramsDict setValue:tradeType forKey:@"tradeType"];
    }
    request.requestParameter = paramsDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDUserBillDetailRspModel *detailModel = [HDUserBillDetailRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(detailModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 解析二维码V2
- (void)doAnalysisQRCode:(NSString *)qrCodeStr success:(void (^_Nullable)(HDAnalysisQRCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/code/scan";
    //    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{@"contentQrCode": qrCodeStr};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDAnalysisQRCodeRspModel *qrCodeModel = [HDAnalysisQRCodeRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(qrCodeModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 根据汇款交易单号，查询提码信息
- (void)queryWithdrawCodeWithTradeNo:(NSString *)tradeNo success:(void (^_Nullable)(PNQueryWithdrawCodeModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant-agentcash/app/per/withdrawCode/query";
    request.requestParameter = @{@"tradeNo": tradeNo};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNQueryWithdrawCodeModel *withdrawCodeModel = [PNQueryWithdrawCodeModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(withdrawCodeModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
