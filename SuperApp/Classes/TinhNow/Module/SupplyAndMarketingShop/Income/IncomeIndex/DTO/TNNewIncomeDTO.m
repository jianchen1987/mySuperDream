//
//  TNNewIncomeDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeDTO.h"


@implementation TNNewIncomeDTO
- (void)queryCheckUserOpenedSuccess:(void (^)(TNCheckWalletOpenedModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/user/wallet/checkUserOpened";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCheckWalletOpenedModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryProfitIncomeDataSuccess:(void (^)(TNNewProfitIncomeModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/supplier/profit/sum";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNNewProfitIncomeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryIncomeListWithPageNum:(NSUInteger)pageNum
                          pageSize:(NSUInteger)pageSize
                       filterModel:(TNIncomeListFilterModel *)filterModel
                           success:(void (^)(TNNewIncomeRspModel *_Nonnull))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/supplier/profit/settlementQuery";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"commissionType"] = [NSNumber numberWithUnsignedInteger:filterModel.supplierType];
    params[@"queryMode"] = [NSNumber numberWithUnsignedInteger:filterModel.queryMode];
    if (filterModel.showAll) {
        params[@"showAll"] = [NSNumber numberWithUnsignedInteger:1];
    }
    if (filterModel.dailyInterval != nil) {
        params[@"dailyInterval"] = filterModel.dailyInterval;
    }
    if (HDIsStringNotEmpty(filterModel.dateRangeStart)) {
        params[@"dateRangeStart"] = filterModel.dateRangeStart;
    }
    if (HDIsStringNotEmpty(filterModel.dateRangeEnd)) {
        params[@"dateRangeEnd"] = filterModel.dateRangeEnd;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNNewIncomeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryIncomeSettlementSumWithFilterModel:(TNIncomeListFilterModel *)filterModel
                                        success:(void (^)(TNIncomeCommissionSumModel *_Nonnull))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/supplier/profit/settlementSum";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    params[@"commissionType"] = [NSNumber numberWithUnsignedInteger:filterModel.supplierType];
    params[@"queryMode"] = [NSNumber numberWithUnsignedInteger:filterModel.queryMode];
    if (filterModel.showAll) {
        params[@"showAll"] = [NSNumber numberWithUnsignedInteger:1];
    }
    if (filterModel.dailyInterval != nil) {
        params[@"dailyInterval"] = filterModel.dailyInterval;
    }
    if (HDIsStringNotEmpty(filterModel.dateRangeStart)) {
        params[@"dateRangeStart"] = filterModel.dateRangeStart;
    }
    if (HDIsStringNotEmpty(filterModel.dateRangeEnd)) {
        params[@"dateRangeEnd"] = filterModel.dateRangeEnd;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNIncomeCommissionSumModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryIncomeDeTailWithObjId:(NSString *)objId success:(void (^)(TNNewIncomeDetailModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/supplier/profit/profitDetail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = objId;
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNNewIncomeDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
