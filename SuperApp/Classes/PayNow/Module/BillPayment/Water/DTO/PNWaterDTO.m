//
//  PNWaterDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWaterDTO.h"
#import "PNCAMNetworRequest.h"


@implementation PNWaterDTO

/// 查询账单编号查询账单
- (void)queryBillWithBillCode:(NSString *)billCode
                 customerCode:(NSString *)customerCode
                 categoryType:(PNPaymentCategory)categoryType
                     currency:(PNCurrencyType)currency
                apiCredential:(NSString *)apiCredential
                   billAmount:(NSString *)billAmount
                customerPhone:(NSString *)customerPhone
                        notes:(NSString *)notes
                      success:(void (^)(PNRspModel *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    //    request.requestURI = @"/billers/app/billPayment/billingInformation/checkWaterBill";
    request.requestURI = @"/billers/app/billPayment/billingInformation/billingInquiry";

    /// 保险教育、学校 才需要传 币种
    NSString *tempCurrency = currency;
    if (categoryType != PNPaymentCategorySchool && categoryType != PNPaymentCategoryInsurance) {
        tempCurrency = @"";
    }

    /// billingSource 账单来源（10：app,11:POS)
    request.requestParameter = @{
        @"customerCode": [NSString stringWithFormat:@"%@-%@", billCode, customerCode],
        @"paymentCategory": @(categoryType),
        @"currency": tempCurrency,
        @"billingSource": @"10",
        @"apiCredential": apiCredential,
        @"billAmount": @(billAmount.doubleValue * 100),
        @"customerPhone": customerPhone,
        @"notes": notes
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询账单详情
- (void)queryBillDetailWithOrderNo:(NSString *)orderNo tradeNo:(NSString *)tradeNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/billers/app/billPayment/billingInformation/queryBillingInformation";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(orderNo)) {
        params[@"orderNo"] = orderNo;
    }
    if (HDIsStringNotEmpty(tradeNo)) {
        params[@"tradeNo"] = tradeNo;
    }
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询最近查询账单
- (void)queryRecentBillList:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/queryBillingInformationList";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 聚合下单
- (void)submitBillWithParam:(NSDictionary *)param success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/createAggregateOrder";
    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 支付结果查询
- (void)queryPaymentResultWithOrderNo:(NSString *)orderNo tradeNo:(NSString *)tradeNo success:(void (^)(PNRspModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/paymentSuccessfulInfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(orderNo)) {
        params[@"orderNo"] = orderNo;
    }
    if (HDIsStringNotEmpty(tradeNo)) {
        params[@"tradeNo"] = tradeNo;
    }
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 关闭业务账单订单
- (void)closePaymentOrderWithOrderNo:(NSString *)orderNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billingInformation/closeBillOrder";
    request.requestParameter = @{@"orderNo": orderNo};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询所有账单分类
- (void)getAllBillCategory:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billPayment/billPaymentCategories/queryCategories";

    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 根据类型获取对应的供应商列表
- (void)getBillerSupplierListWithType:(PNPaymentCategory)paymentCategory success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/billers/app/billSupplier/getBillersSuppliers";
    /// status 状态 10关闭 11开启
    /// completed   数据是否已完善： 10(false)、11(true)
    request.requestParameter = @{
        @"paymentCategory": @(paymentCategory),
        @"status": @(11),
        @"completed": @(11),
        @"pageSize": @(1000),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
