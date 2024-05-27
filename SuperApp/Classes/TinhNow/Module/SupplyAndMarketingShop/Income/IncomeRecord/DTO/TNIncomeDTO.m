//
//  TNIncomeDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeDTO.h"
#import "TNIncomeDetailModel.h"
#import "TNIncomeListFilterModel.h"
#import "TNIncomeModel.h"
#import "TNNetworkRequest.h"


@implementation TNIncomeDTO

- (void)queryIncomeDataSuccess:(void (^)(TNIncomeModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/withdrawal_income";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
// 收益记录 列表
- (void)queryIncomeListWithPageNum:(NSUInteger)pageNum
                          pageSize:(NSUInteger)pageSize
                      supplierType:(TNSellerIdentityType)supplierType
                           showAll:(BOOL)showAll
                     dailyInterval:(nonnull NSNumber *)dailyInterval
                    dateRangeStart:(nonnull NSString *)dateRangeStart
                      dateRangeEnd:(nonnull NSString *)dateRangeEnd
                           success:(nonnull void (^)(TNIncomeRspModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/commissions";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"supplierType"] = [NSNumber numberWithUnsignedInteger:supplierType];
    if (showAll) {
        params[@"showAll"] = [NSNumber numberWithUnsignedInteger:1];
    }
    if (dailyInterval != nil) {
        params[@"dailyInterval"] = dailyInterval;
    }
    if (HDIsStringNotEmpty(dateRangeStart)) {
        params[@"dateRangeStart"] = dateRangeStart;
    }
    if (HDIsStringNotEmpty(dateRangeEnd)) {
        params[@"dateRangeEnd"] = dateRangeEnd;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryPreIncomeListWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize success:(void (^)(TNIncomeRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/estimated/list";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryIncomeDeTailWithObjId:(NSString *)objId
                 commissionLogType:(NSInteger)commissionLogType
                           success:(void (^)(TNIncomeDetailModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/order_commission_detail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"objId"] = objId;
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"commissionLogType"] = @(commissionLogType);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryIncomeCommisionSumWithSupplierType:(TNSellerIdentityType)supplierType
                                        showAll:(BOOL)showAll
                                  dailyInterval:(NSNumber *)dailyInterval
                                 dateRangeStart:(NSString *)dateRangeStart
                                   dateRangeEnd:(NSString *)dateRangeEnd
                                        success:(void (^)(TNIncomeCommissionSumModel *_Nonnull))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/supplierCommission/queryCommissionSum";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"supplierType"] = [NSNumber numberWithUnsignedInteger:supplierType];
    if (showAll) {
        params[@"showAll"] = [NSNumber numberWithUnsignedInteger:1];
    }
    if (dailyInterval != nil) {
        params[@"dailyInterval"] = dailyInterval;
    }
    if (HDIsStringNotEmpty(dateRangeStart)) {
        params[@"dateRangeStart"] = dateRangeStart;
    }
    if (HDIsStringNotEmpty(dateRangeEnd)) {
        params[@"dateRangeEnd"] = dateRangeEnd;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeCommissionSumModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
