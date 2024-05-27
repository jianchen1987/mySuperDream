//
//  TNOrderDTO.m
//  SuperApp
//
//  Created by seeu on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDTO.h"
#import "TNCheckRegionModel.h"
#import "TNOrderListRspModel.h"
#import "TNQueryExchangeOrderExplainRspModel.h"
#import "TNQueryNearbyRouteRspModel.h"
#import "TNQueryOrderDetailsRspModel.h"
#import "TNQueryProcessingOrderRspModel.h"


@implementation TNOrderDTO

//- (void)queryProccessingOrdersWithOperatorNo:(NSString *)operatorNo
//                                     success:(void (^_Nullable)(TNQueryProcessingOrderRspModel *rspModel))successBlock
//                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
//    TNNetworkRequest *request = TNNetworkRequest.new;
//    request.retryCount = 2;
//    request.requestURI = @"/api/user/order/count";
//    request.shouldAlertErrorMsgExceptSpecCode = NO;
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"operatorNo"] = operatorNo;
//    request.requestParameter = params;
//    [request
//        startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
//            SARspModel *rspModel = response.extraData;
//            !successBlock ?: successBlock([TNQueryProcessingOrderRspModel yy_modelWithJSON:rspModel.data]);
//        }
//        failure:^(HDNetworkResponse *_Nonnull response) {
//            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
//        }];
//}

- (void)queryOrderDetailsWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(TNQueryOrderDetailsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/order/detail/v1/get-order";
    //    @"/tapi/sales/order/detail";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unifiedOrderNo"] = orderNo;
    params[@"orderNo"] = orderNo;
    params[@"isTinhnow"] = @1;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryOrderDetailsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)rebuyOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(NSArray *_Nonnull))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/reBuy";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *skuIds = @[];
        if (rspModel.data != nil) {
            NSDictionary *dic = (NSDictionary *)rspModel.data;
            skuIds = dic[@"skuIds"];
        }
        !successBlock ?: successBlock(skuIds);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)cancelOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/order/cancel";
    //    @"/api/merchant/order/cancel";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unifiedOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)confirmOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/tapi/sales/order/receive";
    //    @"/api/merchant/order/receive";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unifiedOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)exchangeOrderExplainSuccess:(void (^_Nullable)(TNQueryExchangeOrderExplainRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/order/afterSale/exchangeInstructions";

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryExchangeOrderExplainRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)changeOrderAddressWithOrderNo:(NSString *)orderNo addressNo:(NSString *)addressNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/order/address/modify";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unifiedOrderNo"] = orderNo;
    params[@"addressNo"] = addressNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 检查 校验配送地址是否在配送范围内
- (void)checkRegionAreaWithLatitude:(NSNumber *)latitude
                          longitude:(NSNumber *)longitude
                            storeNo:(NSString *)storeNo
                      paymentMethod:(TNPaymentMethod)paymentMethod
                              scene:(NSString *)scene
                            Success:(void (^_Nullable)(TNCheckRegionModel *))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/region/checkRegion";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"latitude"] = latitude.stringValue;
    params[@"longitude"] = longitude.stringValue;
    params[@"storeNo"] = storeNo;
    params[@"paymentMethod"] = paymentMethod;
    if (HDIsStringNotEmpty(scene)) {
        params[@"scene"] = scene;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCheckRegionModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryNearByRouteWithOrderNo:(NSString *_Nonnull)orderNo
                            storeNo:(NSString *_Nonnull)storeNo
                            success:(void (^)(NSString *_Nullable route))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/nearbyBuy/route";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unifiedOrderNo"] = orderNo;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryNearbyRouteRspModel yy_modelWithJSON:rspModel.data].url);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryTinhNowProcessOrdersNumberWithOperateNo:(NSString *)operatorNo success:(void (^)(TNQueryProcessingOrderRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/order/orderCount";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryProcessingOrderRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)queryOrderListDataWithOperateNo:(NSString *)operatorNo
                                  state:(TNOrderState)state
                               pageSize:(NSInteger)pageSize
                                pageNum:(NSInteger)pageNum
                                success:(void (^)(TNOrderListRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/order/listData";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = operatorNo;
    if (HDIsStringNotEmpty(state)) {
        params[@"status"] = state;
    }
    params[@"pageNum"] = [NSString stringWithFormat:@"%ld", pageNum];
    params[@"pageSize"] = [NSString stringWithFormat:@"%ld", pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNOrderListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)createPayOrderWithReturnUrl:(NSString *)returnUrl orderNo:(NSString *)orderNo success:(void (^)(NSString *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/pay/createPayOrder";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"returnUrl"] = returnUrl;
    params[@"aggregateOrderNo"] = orderNo;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *dict = (NSDictionary *)rspModel.data;
        if (dict != nil) {
            NSString *outPayOrderNo = dict[@"outPayOrderNo"];
            if (HDIsStringNotEmpty(outPayOrderNo)) {
                !successBlock ?: successBlock(outPayOrderNo);
            }
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
