//
//  WMOrderDetailDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailDTO.h"
#import "WMOrderCancelReasonModel.h"
#import "WMOrderDetailCancelOrderRspModel.h"
#import "WMOrderDetailDeliveryRiderRspModel.h"
#import "WMOrderDetailRspModel.h"


@interface WMOrderDetailDTO ()
/// 获取聚合订单详情
@property (nonatomic, strong) CMNetworkRequest *getOrderDetailRequest;
/// 获取骑手位置
@property (nonatomic, strong) CMNetworkRequest *getDeliverManRequest;
/// 取消订单
@property (nonatomic, strong) CMNetworkRequest *userCancelOrderRequest;
/// 催单
@property (nonatomic, strong) CMNetworkRequest *userUrgeOrderRequest;
/// 取消订单原因
@property (nonatomic, strong) CMNetworkRequest *userCancelOrderReasonRequest;
@end


@implementation WMOrderDetailDTO
- (void)dealloc {
    [_getOrderDetailRequest cancel];
    [_getDeliverManRequest cancel];
    [_userCancelOrderRequest cancel];
    [_userUrgeOrderRequest cancel];
    [_userCancelOrderReasonRequest cancel];
}

- (CMNetworkRequest *)getOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^)(WMOrderDetailRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/app/order/detail/v1/get-order";
    self.getOrderDetailRequest = request;
    self.getOrderDetailRequest.requestParameter = params;
    [self.getOrderDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderDetailRspModel *model = [WMOrderDetailRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMOrderDetailRspModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getOrderDetailRequest;
}

- (CMNetworkRequest *)getDeliverManLocationWithDeliveryManId:(NSString *)deliveryRiderId
                                                     success:(void (^)(WMOrderDetailDeliveryRiderRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"riderId"] = deliveryRiderId;
    self.getDeliverManRequest.requestParameter = params;

    [self.getDeliverManRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderDetailDeliveryRiderRspModel *model = [WMOrderDetailDeliveryRiderRspModel yy_modelWithJSON:rspModel.data];

        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getDeliverManRequest;
}

- (CMNetworkRequest *)userCancelOrderWithOrderNo:(NSString *)orderNo success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    return [self userCancelOrderWithOrderNo:orderNo cancelReason:nil success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)userCancelOrderWithOrderNo:(NSString *)orderNo
                                    cancelReason:(nullable WMOrderCancelReasonModel *)model
                                         success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if (model) {
        NSMutableDictionary *mdic = NSMutableDictionary.new;
        if (model.ids) {
            [mdic setObject:model.ids forKey:@"id"];
        }
        if (model.cancellation) {
            [mdic setObject:model.cancellation forKey:@"cancellation"];
        }
        if (model.nameEn) {
            [mdic setObject:model.nameEn forKey:@"nameEn"];
        }
        if (model.nameKm) {
            [mdic setObject:model.nameKm forKey:@"nameKm"];
        }
        if (model.nameZh) {
            [mdic setObject:model.nameZh forKey:@"nameZh"];
        }
        if (model.operationCode) {
            [mdic setObject:model.operationCode forKey:@"operationCode"];
        }
        if (model.operatorStr) {
            [mdic setObject:model.operatorStr forKey:@"operator"];
        }
        [mdic setObject:@"10" forKey:@"operatePlatform"];
        params[@"cancelReasonReqDTO"] = mdic;
    }else{
        return self.userCancelOrderRequest;
    }
    self.userCancelOrderRequest.requestParameter = params;
    [self.userCancelOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderDetailCancelOrderRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.userCancelOrderRequest;
}
- (CMNetworkRequest *)userUrgeOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    self.userUrgeOrderRequest.requestParameter = params;
    [self.userUrgeOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.userUrgeOrderRequest;
}

- (CMNetworkRequest *)onceAgainOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/delivery/reBuy";
    request.isNeedLogin = YES;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = orderNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (CMNetworkRequest *)userCancelOrderReasonWithOrderNo:(NSString *)orderNo
                                               success:(void (^_Nullable)(NSArray<WMOrderCancelReasonModel *> *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    params[@"operatePlatform"] = @"10";
    self.userCancelOrderReasonRequest.requestParameter = params;
    [self.userCancelOrderReasonRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:[WMOrderCancelReasonModel class] json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.userCancelOrderReasonRequest;
}

- (void)wmFindSystemConfigs:(NSString *)key block:(void (^_Nullable)(BOOL canEnter))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/findSystemConfigs";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class]) {
            NSArray *operatorArr = @[];
            NSArray *langArr = @[];
            NSDictionary *im_operator_no_white_list = info[@"im_operator_no_white_list"];
            if ([im_operator_no_white_list isKindOfClass:NSDictionary.class]) {
                if ([im_operator_no_white_list[@"key"] isEqualToString:@"im_operator_no_white_list"]) {
                    if ([im_operator_no_white_list[@"value"] isKindOfClass:NSString.class]) {
                        NSString *value = im_operator_no_white_list[@"value"];
                        if ([value containsString:@","]) {
                            operatorArr = [value componentsSeparatedByString:@","];
                        } else {
                            operatorArr = @[value];
                        }
                    }
                }
            }
            NSDictionary *lang_list = info[@"im_lang_white_list"];
            if ([lang_list isKindOfClass:NSDictionary.class]) {
                if ([lang_list[@"key"] isEqualToString:@"im_lang_white_list"]) {
                    if ([lang_list[@"value"] isKindOfClass:NSString.class]) {
                        NSString *value = lang_list[@"value"];
                        if ([value containsString:@","]) {
                            langArr = [value componentsSeparatedByString:@","];
                        } else {
                            langArr = @[value];
                        }
                    }
                }
            }
            BOOL configLang = NO;
            if (!HDIsArrayEmpty(langArr) && [langArr indexOfObject:SAMultiLanguageManager.currentLanguage] != NSNotFound) {
                configLang = YES;
            }
            BOOL configUser = NO;
            if (!HDIsArrayEmpty(operatorArr) && [operatorArr indexOfObject:[SAUser.shared operatorNo]] != NSNotFound) {
                configUser = YES;
            }
            if (configLang) {
                if (HDIsArrayEmpty(operatorArr)) {
                    !successBlock ?: successBlock(YES);
                } else {
                    !successBlock ?: successBlock(configUser);
                }
            } else {
                !successBlock ?: successBlock(NO);
            }

        } else {
            !successBlock ?: successBlock(NO);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(NO);
    }];
}

- (void)WMCheckTGBindWithBlock:(void (^_Nullable)(NSString *_Nullable bindURL))successBlock;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/tg-account/query-user-has-bind";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class] && info[@"hasBind"] && ![info[@"hasBind"] boolValue] && !HDIsObjectNil(info[@"botLink"])) {
            !successBlock ?: successBlock(info[@"botLink"]);
        } else {
            !successBlock ?: successBlock(nil);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(nil);
    }];
}

#pragma mark - lazy load

- (CMNetworkRequest *)getDeliverManRequest {
    if (!_getDeliverManRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-delivery/app/rider-app/rider/current-position/query.do";
        _getDeliverManRequest = request;
    }
    return _getDeliverManRequest;
}

- (CMNetworkRequest *)userCancelOrderRequest {
    if (!_userCancelOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-order/app/user/order/cancel/apply";

        _userCancelOrderRequest = request;
    }
    return _userCancelOrderRequest;
}
- (CMNetworkRequest *)userUrgeOrderRequest {
    if (!_userUrgeOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/takeaway-order/app/user/order/reminder";
        request.isNeedLogin = YES;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _userUrgeOrderRequest = request;
    }
    return _userUrgeOrderRequest;
}

- (CMNetworkRequest *)userCancelOrderReasonRequest {
    if (!_userCancelOrderReasonRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/takeaway-order/app/user/order/cancel-reason/configuration/list";
        request.isNeedLogin = YES;
        _userCancelOrderReasonRequest = request;
    }
    return _userCancelOrderReasonRequest;
}

@end
