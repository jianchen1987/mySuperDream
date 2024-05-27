//
//  SAUserBillDTO.m
//  SuperApp
//
//  Created by seeu on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillDTO.h"


@implementation SAUserBillDTO

- (void)queryUserBillListWithPageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                           startTime:(NSTimeInterval)startTime
                             endTime:(NSTimeInterval)endTime
                             success:(void (^_Nullable)(SAUserBillListRspModel *list))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/operator/listBillingRecord";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @(pageNum);
    params[@"pageSize"] = @(pageSize);
    if (startTime > 0) {
        params[@"createStartTime"] = @(startTime * 1000.0);
    }
    if (endTime > 0) {
        params[@"createEndTime"] = @(endTime * 1000.0);
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAUserBillListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryUserBillPaymentDetailsWithPayTransactionNo:(NSString *_Nullable)payTransactionNo
                                             payOrderNo:(NSString *_Nullable)payOrderNo
                                                success:(void (^)(SAUserBillPaymentDetailsRspModel *_Nonnull))successBlock
                                                failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/user/payDetail";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(payTransactionNo)) {
        params[@"payTransactionNo"] = payTransactionNo;
    }

    if (HDIsStringNotEmpty(payOrderNo)) {
        params[@"payOrderNo"] = payOrderNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAUserBillPaymentDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryUserBillRefundDetailsWithRefundTransactionNo:(NSString *_Nullable)refundTransactionNo
                                            refundOrderNo:(NSString *_Nullable)refundOrderNo
                                                  success:(void (^)(SAUserBillRefundDetailsRspModel *_Nonnull))successBlock
                                                  failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/user/refundDetail";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(refundTransactionNo)) {
        params[@"refundTransactionNo"] = refundTransactionNo;
    }

    if (HDIsStringNotEmpty(refundOrderNo)) {
        params[@"refundOrderNo"] = refundOrderNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAUserBillRefundDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getUserBillStatisticsWithStatTime:(NSTimeInterval)startTime
                                  endTime:(NSTimeInterval)endTime
                                  success:(void (^)(SAUserBillStatisticsRspModel *_Nonnull))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/operator/getBillStatistics";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (startTime > 0) {
        params[@"createStartTime"] = @(startTime * 1000.0);
    }

    if (endTime > 0) {
        params[@"createEndTime"] = @(endTime * 1000.0);
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAUserBillStatisticsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end


@implementation SAUserBillListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAUserBillListModel.class,
    };
}

@end


@implementation SAUserBillListModel

@end


@implementation SAUserBillRefundDetailsRspModel

@end


@implementation SAUserBillPaymentDetailsRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"refundRecordList": SAUserBillRefundRecordModel.class};
}
@end


@implementation SAUserBillRefundRecordModel

@end


@implementation SAUserBillRefundReceiveAccountModel

@end


@implementation SAUserBillStatisticsRspModel

@end
