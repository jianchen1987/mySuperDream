//
//  WMOrderFeedBackDTO.m
//  SuperApp
//
//  Created by wmz on 2021/11/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackDTO.h"


@implementation WMOrderFeedBackDTO

- (void)requestSubmitOrderPostSaleFeedBackWithNo:(NSString *)orderNo
                                    postSaleType:(WMOrderFeedBackPostShowType)postSaleType
                                      reasonCode:(NSString *)reasonCode
                                   commodityInfo:(nullable NSArray *)commodityInfo
                                     description:(nullable NSString *)description
                                      imagePaths:(nullable NSArray<NSString *> *)imagePaths
                                         success:(CMNetworkSuccessBlock _Nullable)successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/post-sale/create-by-user";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (postSaleType)
        params[@"postSaleType"] = postSaleType;
    if (orderNo)
        params[@"orderNo"] = orderNo;
    if (reasonCode)
        params[@"reasonCode"] = reasonCode;
    if (imagePaths)
        params[@"imagePaths"] = imagePaths;
    if (description)
        params[@"description"] = description;
    if (commodityInfo)
        params[@"commodityInfo"] = commodityInfo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)requestFindFeedbackReasonListWithSuccess:(void (^_Nullable)(NSArray<WMOrderFeedBackReasonRspModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
{
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/findFeedback/list";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<WMOrderFeedBackReasonRspModel *> *model = [NSArray yy_modelArrayWithClass:WMOrderFeedBackReasonRspModel.class json:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)requestGetRefundableProductWithNO:(NSString *)orderNo
                                  success:(void (^_Nullable)(NSArray<WMOrderDetailProductModel *> *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/post-sale/get-refundable-product";
    request.requestParameter = @{@"orderNo": orderNo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<WMOrderDetailProductModel *> *model = [NSArray yy_modelArrayWithClass:WMOrderDetailProductModel.class json:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)requestCalculationRefundAmountWithNO:(NSString *)orderNo
                               commodityInfo:(nullable NSArray *)commodityInfo
                                     success:(void (^_Nullable)(WMFeedBackRefundAmountModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;
{
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/post-sale/calculation-refund-amount";
    request.requestParameter = @{@"orderNo": orderNo, @"commodityInfos": commodityInfo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMFeedBackRefundAmountModel *model = [WMFeedBackRefundAmountModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)requestPostSaleListByOrderWithNO:(NSString *)orderNo
                                 success:(void (^_Nullable)(NSArray<WMOrderFeedBackDetailModel *> *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;
{
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/post-sale/list-by-order-no";
    request.requestParameter = @{
        @"orderNo": orderNo,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<WMOrderFeedBackDetailModel *> *model = [NSArray yy_modelArrayWithClass:WMOrderFeedBackDetailModel.class json:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)requestPostSaleDetailByOrderWithId:(NSInteger)ids success:(void (^_Nullable)(WMOrderFeedBackDetailModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/post-sale/detail-by-user";
    request.requestParameter = @{
        @"id": @(ids).stringValue,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderFeedBackDetailModel *model = [WMOrderFeedBackDetailModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
