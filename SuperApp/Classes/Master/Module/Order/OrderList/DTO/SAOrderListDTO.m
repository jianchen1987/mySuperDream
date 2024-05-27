//
//  SAOrderListDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "SAUser.h"


@implementation SAOrderListDTO

- (void)getOrderListWithBusinessType:(SAClientType)businessType
                          orderState:(SAOrderState)orderState
                             pageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                      orderTimeStart:(nullable NSString *)orderTimeStart
                        orderTimeEnd:(nullable NSString *)orderTimeEnd
                             success:(nonnull void (^)(SAOrderListRspModel *_Nonnull))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    [self getOrderListWithBusinessType:businessType orderState:orderState pageNum:pageNum pageSize:pageSize orderTimeStart:orderTimeStart orderTimeEnd:orderTimeEnd keyName:nil success:successBlock
                               failure:failureBlock];
}

- (void)getOrderListWithBusinessType:(SAClientType)businessType
                          orderState:(SAOrderState)orderState
                             pageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                      orderTimeStart:(nullable NSString *)orderTimeStart
                        orderTimeEnd:(nullable NSString *)orderTimeEnd
                             keyName:(nullable NSString *)keyName
                             success:(nonnull void (^)(SAOrderListRspModel *_Nonnull))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        !successBlock ?: successBlock(SAOrderListRspModel.new);
        return;
    };

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/queryList";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderType"] = [NSNumber numberWithUnsignedInteger:orderState];
    params[@"pageNum"] = @(pageNum);
    params[@"pageSize"] = @(pageSize);
    params[@"userNo"] = SAUser.shared.operatorNo;
    params[@"businessLine"] = [businessType isEqualToString:SAClientTypeMaster] ? @"" : businessType;
    if (orderTimeStart.length == 10) {
        params[@"orderTimeStart"] = orderTimeStart;
    }

    if (orderTimeEnd.length == 10) {
        params[@"orderTimeEnd"] = orderTimeEnd;
    }

    if (HDIsStringNotEmpty(keyName)) {
        params[@"keyName"] = keyName;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAOrderListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)confirmOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-order/app/user/order/receipt";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)submitPickUpOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-order/app/user/order/finish";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !successBlock ?: successBlock();
        });
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}


- (void)rebuyOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/cart/ecommerce/reBuy";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)deleteOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/order/delete";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getOrderBillListWithOrderNo:(NSString *)orderNo success:(void (^)(SAOrderBillListModel *model))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/order/getOrderCard";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAOrderBillListModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
