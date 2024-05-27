//
//  PNMSOrderDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOrderDTO.h"
#import "HDUserBillDetailRspModel.h"
#import "PNMSBillListRspModel.h"
#import "PNMSFilterStoreOperatorDataModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSOrderDTO
/// 获取商户账单列表
- (void)getMSTransOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNMSBillListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/merchant/queryBillListNew.do";
    request.requestParameter = paramsDict;

    HDLog(@"请求入参：%@", [paramsDict yy_modelToJSONString]);

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSBillListRspModel *listModel = [PNMSBillListRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取交易详情/订单详情
- (void)getMSTransOrderDetailWithtTadeNo:(NSString *)tradeNo
                              merchantNo:(NSString *)merchantNo
                               tradeType:(PNTransType)tradeType
                             needBalance:(BOOL)needBalance
                                 success:(void (^_Nullable)(HDUserBillDetailRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/merchant/bill/detail.do";

    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [paramsDict setValue:tradeNo ?: @"" forKey:@"tradeNo"];
    [paramsDict setValue:@(tradeType) forKey:@"tradeType"];
    if (needBalance) {
        [paramsDict setValue:@(1) forKey:@"needBalance"];
    } else {
        [paramsDict setValue:@(0) forKey:@"needBalance"];
    }

    if (HDIsStringNotEmpty(merchantNo)) {
        [paramsDict setValue:merchantNo forKey:@"merchantNo"];
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

/// 查询所有门店和操作员 - 筛选用
- (void)getFilterData:(void (^_Nullable)(PNMSFilterStoreOperatorDataModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/merchant/app/mer/role/selectStoreAndOper.do";

    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramsDict setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    request.requestParameter = paramsDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSFilterStoreOperatorDataModel *detailModel = [PNMSFilterStoreOperatorDataModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(detailModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
