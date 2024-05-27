//
//  PNWalletOrderDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderDTO.h"
#import "PNRspModel.h"
#import "PNWalletListRspModel.h"
#import "PNWalletOrderDetailModel.h"


@implementation PNWalletOrderDTO
/// 获取钱包明细 - 列表
- (void)getWalletOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNWalletListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/queryWalletDetails.do";
    request.requestParameter = paramsDict;

    HDLog(@"请求入参：%@", [paramsDict yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNWalletListRspModel *listModel = [PNWalletListRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取钱包明细 - 详情
- (void)getWalletOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(PNWalletOrderDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/queryTradeDetails.do";
    request.requestParameter = @{
        @"accountSerialNo": orderNo,
    };

    HDLog(@"请求入参：%@", [request.requestParameter yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNWalletOrderDetailModel *listModel = [PNWalletOrderDetailModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
