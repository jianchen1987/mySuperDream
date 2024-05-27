//
//  PNGameDetailDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNRspModel.h"


@implementation PNGameDetailDTO
- (void)queryGameItemDetailWithCategoryId:(NSString *)categoryId success:(void (^)(PNGameDetailRspModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/itemInquiry";
    request.requestParameter = @{@"categoryId": categoryId, @"apiCredentialEnum": @"12"};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGameDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryGameBalanceInquiryWithBillCode:(NSString *)billCode
                                   currency:(NSString *)currency
                                    success:(void (^)(TNGameBalanceAccountModel *_Nonnull))successBlock
                                    failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/balanceInquiry";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(billCode)) {
        params[@"billCode"] = billCode;
        params[@"customerCode"] = billCode;
    }
    if (HDIsStringNotEmpty(currency)) {
        params[@"currency"] = currency;
    }
    params[@"billingSource"] = @"APP";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGameBalanceAccountModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryGameFeeAndPromotionWithAmt:(NSString *)amt
                               currency:(NSString *)currency
                             chargeType:(NSString *)chargeType
                           supplierCode:(nonnull NSString *)supplierCode
                               billCode:(nonnull NSString *)billCode
                                success:(nonnull void (^)(PNGameFeeModel *_Nonnull))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/queryFeeAndPromotion";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(amt)) {
        params[@"amt"] = amt;
    }
    if (HDIsStringNotEmpty(currency)) {
        params[@"currency"] = currency;
    }
    if (HDIsStringNotEmpty(chargeType)) {
        params[@"chargeType"] = chargeType;
    }
    params[@"bizType"] = @(32);
    params[@"billingSource"] = @(10);
    if (HDIsStringNotEmpty(billCode)) {
        params[@"customerCode"] = billCode;
    }
    if (HDIsStringNotEmpty(supplierCode)) {
        params[@"supplierCode"] = supplierCode;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGameFeeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryUserBalanceAndExchangeWithTotalAmount:(NSString *)totalAmount success:(void (^)(PNBalanceAndExchangeModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/queryBalanceAndExchange";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (HDIsStringNotEmpty(totalAmount)) {
        params[@"totalAmount"] = totalAmount;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNBalanceAndExchangeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)createGameAggregateOrderWithSubmitModel:(PNGameSubmitOderRequestModel *)submitModel
                                        success:(void (^)(PNGameSubmitOrderResponseModel *_Nonnull))successBlock
                                        failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/createAggregateOrderForEntertainment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(submitModel.billCode)) {
        params[@"billCode"] = submitModel.billCode;
        params[@"customerCode"] = submitModel.billCode;
    }
    if (!HDIsObjectNil(submitModel.billAmount)) {
        params[@"currency"] = submitModel.billAmount.cy;
        params[@"billAmount"] = submitModel.billAmount.amount;
    }
    params[@"operatorNo"] = submitModel.operatorNo;
    params[@"billingSource"] = submitModel.billingSource;
    params[@"billGroup"] = submitModel.billGroup;
    if (HDIsStringNotEmpty(submitModel.userNo)) {
        params[@"userNo"] = submitModel.userNo;
    }
    params[@"returnUrl"] = submitModel.returnUrl;
    if (HDIsStringNotEmpty(submitModel.categoryId)) {
        params[@"categoryId"] = submitModel.categoryId;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGameSubmitOrderResponseModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)createGameWalletOrderWithSubmitModel:(PNGameSubmitOderRequestModel *)submitModel
                                     success:(void (^)(PNGameSubmitOrderResponseModel *_Nonnull))successBlock
                                     failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/entertainment/createWalletOrderForEntertainment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(submitModel.billCode)) {
        params[@"billCode"] = submitModel.billCode;
        params[@"customerCode"] = submitModel.billCode;
    }
    if (!HDIsObjectNil(submitModel.billAmount)) {
        params[@"currency"] = submitModel.billAmount.cy;
        params[@"billAmount"] = submitModel.billAmount.amount;
    }
    params[@"operatorNo"] = submitModel.operatorNo;
    params[@"billingSource"] = submitModel.billingSource;
    params[@"billGroup"] = submitModel.billGroup;
    if (HDIsStringNotEmpty(submitModel.userNo)) {
        params[@"userNo"] = submitModel.userNo;
    }
    params[@"returnUrl"] = submitModel.returnUrl;
    if (HDIsStringNotEmpty(submitModel.categoryId)) {
        params[@"categoryId"] = submitModel.categoryId;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGameSubmitOrderResponseModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
