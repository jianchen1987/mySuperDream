//
//  TNRefundDTO.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDTO.h"
#import "TNRefundCommonDictModel.h"
#import "TNRefundDetailsModel.h"
#import "TNRefundSimpleOrderInfoModel.h"


@implementation TNRefundDTO

/// 取消申请退款
- (void)cancelApplyRefundWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/order/refund/cancel";
    //    @"/api/merchant/order/refund/cancel";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询退款记录
- (void)getRefundDetailsWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(TNRefundDetailsModel *refundDetailsModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/refund/refundRecord";
    //    @"/api/merchant/order/refund/refundRecord";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;

        TNRefundDetailsModel *model = [TNRefundDetailsModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 申请退款
- (void)postApplyInfoData:(NSDictionary *)paramsDic success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/order/refund/apply";
    //    @"/api/merchant/order/refund/apply";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 通过订单ID获取订单信息
- (void)getSimpleOrderInfoByOrderId:(NSString *)orderNo success:(void (^_Nullable)(TNRefundSimpleOrderInfoModel *orderInfoModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/refund/queryOrderInfoByOrderId";
    //    @"/api/merchant/order/refund/queryOrderInfoByOrderId";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;

        TNRefundSimpleOrderInfoModel *model = [TNRefundSimpleOrderInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取字典数据
- (void)getCommonDataDictByTypes:(NSArray *)types success:(void (^_Nullable)(TNRefundCommonDictModel *commonDictModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/common/queryDictByTypes";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"typeList"] = types;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;

        TNRefundCommonDictModel *model = [TNRefundCommonDictModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
