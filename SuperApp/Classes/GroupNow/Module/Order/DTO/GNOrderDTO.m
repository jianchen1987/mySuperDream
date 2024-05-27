//
//  GNOrderDTO.m
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderDTO.h"
#import "GNNotificationConst.h"
#import "NAT.h"
#import "SAQueryOrderDetailsRspModel.h"
#import "SAUser.h"
#import "SAWindowManager.h"


@interface GNOrderDTO ()

/// 抢购
@property (nonatomic, strong) CMNetworkRequest *orderRushBuyRequest;
/// 下单
@property (nonatomic, strong) CMNetworkRequest *orderCreateRequest;
/// 订单列表
@property (nonatomic, strong) CMNetworkRequest *orderListRequest;
/// 订单列表数量
@property (nonatomic, strong) CMNetworkRequest *orderListCountRequest;
/// 订单取消
@property (nonatomic, strong) CMNetworkRequest *orderCanceledRequest;
/// 订单详情
@property (nonatomic, strong) CMNetworkRequest *orderDetailRequest;
/// 获取订单核销信息
@property (nonatomic, strong) CMNetworkRequest *orderVerificationStateRequest;

@end


@implementation GNOrderDTO

- (void)orderRushBuyRequestStoreNo:(nonnull NSString *)storeNo
                              code:(nonnull NSString *)code
                           success:(nullable void (^)(GNOrderRushBuyModel *rspModel))successBlock
                           failure:(nullable CMNetworkFailureBlock)failureBlock {
    if (![SAUser hasSignedIn]) {
        @HDWeakify(self)[SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:^{
            @HDStrongify(self)
                ///重新发起请求
                [self orderRushBuyRequestStoreNo:storeNo code:code success:successBlock failure:failureBlock];
        }];
        !failureBlock ?: failureBlock(nil, CMResponseErrorTypeLoginExpired, nil);
        return;
    }

    self.orderRushBuyRequest.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:storeNo, @"storeNo", code, @"code", nil];
    [self.orderRushBuyRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNOrderRushBuyModel *model = [GNOrderRushBuyModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        if ([rspModel.code isEqualToString:GNPayErrorTypeProductUp] || /// 商品下架
            [rspModel.code isEqualToString:GNPayErrorTypeSolded]) {    ///已售罄
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProductUp object:nil];
        }
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderCreateRequestInfo:(nonnull NSDictionary *)info success:(nullable CMNetworkSuccessBlock)successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    self.orderCreateRequest.requestParameter = info;
    [self.orderCreateRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderListRequestCustomerNo:(nonnull NSString *)customerNo
                           pageNum:(NSInteger)pageNum
                          bizState:(nullable NSString *)bizState
                           success:(nullable void (^)(GNOrderPagingRspModel *rspModel))successBlock
                           failure:(nullable CMNetworkFailureBlock)failureBlock {
    self.orderListRequest.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:customerNo, @"customerNo", @(pageNum), @"pageNum", @(20), @"pageSize", bizState, @"bizState", nil];
    [self.orderListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNOrderPagingRspModel *model = [GNOrderPagingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderListCountRequestSuccess:(nullable CMNetworkSuccessBlock)successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;
{
    self.orderListCountRequest.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:SAUser.shared.operatorNo, @"customerNo", nil];
    [self.orderListCountRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderCanceledRequestCustomerNo:(nonnull NSString *)customerNo
                               orderNo:(nonnull NSString *)orderNo
                           cancelState:(nonnull NSString *)cancelState
                                remark:(nullable NSString *)remark
                               success:(nullable CMNetworkSuccessBlock)successBlock
                               failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = NSMutableDictionary.new;
    params[@"customerNo"] = customerNo;
    params[@"orderNo"] = orderNo;
    params[@"cancelState"] = cancelState;
    if (remark) {
        params[@"remark"] = remark;
    }
    self.orderCanceledRequest.requestParameter = params;
    [self.orderCanceledRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(response.extraData);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderDetailRequestCustomerNo:(nonnull NSString *)customerNo
                             orderNo:(nonnull NSString *)orderNo
                             success:(nullable void (^)(GNOrderCellModel *rspModel))successBlock
                             failure:(nullable CMNetworkFailureBlock)failureBlock {
    self.orderDetailRequest.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:customerNo, @"customerNo", orderNo, @"orderNo", nil];
    @HDWeakify(self);
    [self.orderDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        GNOrderCellModel *model = [GNOrderCellModel yy_modelWithJSON:rspModel.data];
        [self p_queryOrderInfoWith:model success:successBlock failure:failureBlock];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)p_queryOrderInfoWith:(GNOrderCellModel *)model success:(nullable void (^)(GNOrderCellModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/queryDetail";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = model.aggregateOrderNo;
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SAQueryOrderDetailsRspModel *orderInfoModel = [SAQueryOrderDetailsRspModel yy_modelWithJSON:rspModel.data];
        model.payDiscountAmount = orderInfoModel.payDiscountAmount;
        model.payActualPayAmount = orderInfoModel.payActualPayAmount;
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderVerificationStateRequestCustomerNo:(nonnull NSString *)customerNo
                                        orderNo:(nonnull NSString *)orderNo
                                        success:(nullable void (^)(GNMessageCode *rspModel))successBlock
                                        failure:(nullable CMNetworkFailureBlock)failureBlock {
    self.orderVerificationStateRequest.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:customerNo, @"customerNo", orderNo, @"orderNo", nil];
    [self.orderVerificationStateRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        GNMessageCode *model = [GNMessageCode yy_modelWithJSON:info[@"verificationState"]];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderGetOrderProductCodeWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNProductModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.isNeedLogin = YES;
    request.requestURI = @"/groupon-service/user/order/getOrderProductCode";
    request.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:orderNo, @"orderNo", nil];
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNProductModel *model = [GNProductModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderRefundDetailWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNRefundModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.isNeedLogin = YES;
    request.requestURI = @"/shop/app/refund/detail";
    request.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:orderNo, @"aggregateOrderNo", nil];
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNRefundModel *model = [GNRefundModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderCancelListSuccess:(nullable void (^)(NSArray<GNOrderCancelRspModel *> *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.isNeedLogin = YES;
    request.requestURI = @"/groupon-service/user/order/cancel/cause";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:GNOrderCancelRspModel.class json:rspModel.data];
        if (!HDIsArrayEmpty(arr)) {
            !successBlock ?: successBlock(arr);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getOrderCouponListWithOrderNo:(nonnull NSString *)orderNo
                              success:(nullable void (^)(NSArray<GNCouponDetailModel *> *rspModel))successBlock
                              failure:(nullable CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestParameter = [NSDictionary dictionaryWithObjectsAndKeys:SAUser.shared.operatorNo, @"customerNo", orderNo, @"orderNo", nil];
    request.isNeedLogin = YES;
    request.requestURI = @"/groupon-service/user/order/coupon";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:GNCouponDetailModel.class json:rspModel.data];
        if (!HDIsArrayEmpty(arr)) {
            !successBlock ?: successBlock(arr);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (CMNetworkRequest *)orderRushBuyRequest {
    if (!_orderRushBuyRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.requestURI = @"/groupon-service/user/order/rushBuy/V2";
        _orderRushBuyRequest = request;
    }
    return _orderRushBuyRequest;
}

- (CMNetworkRequest *)orderCreateRequest {
    if (!_orderCreateRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/order/create";
        request.isNeedLogin = YES;
        _orderCreateRequest = request;
    }
    return _orderCreateRequest;
}

- (CMNetworkRequest *)orderListRequest {
    if (!_orderListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/order/list";
        request.isNeedLogin = YES;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _orderListRequest = request;
    }
    return _orderListRequest;
}

- (CMNetworkRequest *)orderListCountRequest {
    if (!_orderListCountRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.requestURI = @"/groupon-service/user/order/list/count";
        _orderListCountRequest = request;
    }
    return _orderListCountRequest;
}

- (CMNetworkRequest *)orderCanceledRequest {
    if (!_orderCanceledRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.requestURI = @"/groupon-service/user/order/canceled";
        _orderCanceledRequest = request;
    }
    return _orderCanceledRequest;
}
- (CMNetworkRequest *)orderDetailRequest {
    if (!_orderDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        /// getDetailByAggregateOrderNo
        request.requestURI = @"/groupon-service/user/order/detail";
        _orderDetailRequest = request;
    }
    return _orderDetailRequest;
}

- (CMNetworkRequest *)orderVerificationStateRequest {
    if (!_orderVerificationStateRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.isNeedLogin = YES;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.requestURI = @"/groupon-service/user/order/verification/state";
        _orderVerificationStateRequest = request;
    }
    return _orderVerificationStateRequest;
}

- (void)dealloc {
    [self.orderRushBuyRequest cancel];
    [self.orderVerificationStateRequest cancel];
    [self.orderDetailRequest cancel];
    [self.orderCanceledRequest cancel];
    [self.orderListCountRequest cancel];
    [self.orderListRequest cancel];
    [self.orderRushBuyRequest cancel];
}

@end
