//
//  WMModifyAddressDTO.m
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModifyAddressDTO.h"


@implementation WMModifyAddressDTO
- (void)getOrderUpdateAddressWithAddressNo:(NSString *)addressNo
                                   orderNo:(NSString *)orderNo
                                   success:(void (^_Nullable)(WMModifyFeeModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/orderUpdateAddress/get";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"addressNo"] = addressNo;
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMModifyFeeModel *model = [WMModifyFeeModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMModifyFeeModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)createOrderUpdateAddressWithAddressNo:(NSString *)addressNo
                                      orderNo:(NSString *)orderNo
                                     distance:(NSInteger)distance
                                         time:(NSInteger)time
                                          fee:(SAMoneyModel *)fee
                                      success:(void (^_Nullable)(WMModifyAddressSubmitOrderModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/orderUpdateAddress/create";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"addressNo"] = addressNo;
    params[@"orderNo"] = orderNo;
    params[@"time"] = @(time).stringValue;
    params[@"distance"] = @(distance).stringValue;
    params[@"fee"] = @{@"amount": fee.amount, @"cent": fee.cent, @"centFactor": @"100", @"currency": fee.cy};
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMModifyAddressSubmitOrderModel *model = [WMModifyAddressSubmitOrderModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMModifyAddressSubmitOrderModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getListOrderUpdateAddressWithOrderNo:(NSString *)orderNo
                                     success:(void (^_Nullable)(NSArray<WMModifyAddressListModel *> *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/orderUpdateAddress/list";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<WMModifyAddressListModel *> *model = [NSArray yy_modelArrayWithClass:WMModifyAddressListModel.class json:rspModel.data];
        if ([model isKindOfClass:NSArray.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)cancelOrderUpdateAddressWithOrderNo:(NSString *)orderNo success:(CMNetworkSuccessVoidBlock _Nullable)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/orderUpdateAddress/cancel";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
