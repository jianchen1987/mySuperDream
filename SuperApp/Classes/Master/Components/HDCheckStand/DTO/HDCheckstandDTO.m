

//
//  HDCheckstandDTO.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckstandDTO.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "HDCreatePayOrderRspModel.h"
#import "HDOnlinePaymentToolsModel.h"
#import "HDQueryAnnoncementRspModel.h"
#import "HDQueryPaymentMethodRspModel.h"
#import "HDTradeBuildOrderModel.h"
#import "HDTradeCreatePaymentRspModel.h"
#import "HDTradeOrderStateRspModel.h"
#import "HDTradeSubmitPaymentRspModel.h"
#import "SAGetEncryptFactorDTO.h"
#import "SAGoodsModel.h"
#import "SAMoneyModel.h"
#import "SAQueryPaymentAvailableActivityAnnouncementRspModel.h"
#import "SAQueryPaymentAvailableActivityRspModel.h"


@interface HDCheckstandDTO ()
/// 关闭订单
@property (nonatomic, strong) CMNetworkRequest *closeOrderRequest;
/// 创建订单
@property (nonatomic, strong) CMNetworkRequest *orderBuildRequest;
/// 下单
@property (nonatomic, strong) CMNetworkRequest *orderCreateRequest;
/// 确认支付
@property (nonatomic, strong) CMNetworkRequest *payConfirmRequest;
/// 支付
@property (nonatomic, strong) CMNetworkRequest *orderSubmitRequest;
/// 查询订单状态
@property (nonatomic, strong) CMNetworkRequest *queryOrderStatusRequest;
/// 校验支付密码
@property (nonatomic, strong) CMNetworkRequest *verifyPayPwdRequest;
/// 获取支付方式
@property (nonatomic, strong) CMNetworkRequest *queryPaymentMethodRequest;
/// 提交支付参数
@property (nonatomic, strong) CMNetworkRequest *submitPaymentParamsRequest;
/// 创建支付单
@property (nonatomic, strong) CMNetworkRequest *createPayOrderRequest;
/// 获取加密因子 VM
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;
/// 获取支付qrcode
@property (nonatomic, strong) CMNetworkRequest *qrCodePayRequest;

@end


@implementation HDCheckstandDTO

- (CMNetworkRequest *)tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradeNo"] = tradeNo;
    self.closeOrderRequest.requestParameter = params;
    [self.closeOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSString *tradeNo = ((NSDictionary *)rspModel.data)[@"tradeNo"];
        !successBlock ?: successBlock(tradeNo);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.closeOrderRequest;
}

- (CMNetworkRequest *)tradeSubmitPaymentWithPayPwd:(NSString *)payPwd
                                           tradeNo:(NSString *)tradeNo
                                         voucherNo:(NSString *)voucherNo
                                          outBizNo:(NSString *)outBizNo
                                           success:(void (^)(HDTradeSubmitPaymentRspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:payPwd publicKey:rspModel.publicKey];
        [self _tradeSubmitPaymentWithPwdSecurityStr:pwdSecurityStr index:rspModel.index tradeNo:tradeNo voucherNo:voucherNo outBizNo:outBizNo success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.orderSubmitRequest;
}

- (CMNetworkRequest *)queryOrderStatusWithTradeNo:(NSString *)tradeNo success:(void (^)(HDTradeOrderStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradeNo"] = tradeNo;
    self.queryOrderStatusRequest.requestParameter = params;
    [self.queryOrderStatusRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDTradeOrderStateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryOrderStatusRequest;
}

- (CMNetworkRequest *)verifyPayPwd:(NSString *)payPwd
                           success:(void (^_Nullable)(NSString *token, NSString *index, NSString *pwdSecurityStr))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getWalletEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:payPwd publicKey:rspModel.publicKey];
        [self _verifyPayPwdWithPwdSecurityStr:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];

    return self.verifyPayPwdRequest;
}

#pragma mark - private methods
- (CMNetworkRequest *)_verifyPayPwdWithPwdSecurityStr:(NSString *)pwdSecurityStr
                                                index:(NSString *)index
                                              success:(void (^_Nullable)(NSString *token, NSString *index, NSString *pwdSecurityStr))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"oldTradePwd"] = pwdSecurityStr;
    params[@"bizType"] = @(16);
    self.orderSubmitRequest.requestParameter = params;
    [self.verifyPayPwdRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSString *accessToken = ((NSDictionary *)rspModel.data)[@"accessToken"];
        !successBlock ?: successBlock(accessToken, index, pwdSecurityStr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.verifyPayPwdRequest;
}

- (CMNetworkRequest *)_tradeSubmitPaymentWithPwdSecurityStr:(NSString *)pwdSecurityStr
                                                      index:(NSString *)index
                                                    tradeNo:(NSString *)tradeNo
                                                  voucherNo:(NSString *)voucherNo
                                                   outBizNo:(NSString *)outBizNo
                                                    success:(void (^)(HDTradeSubmitPaymentRspModel *rspModel))successBlock
                                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"payPwd"] = pwdSecurityStr;
    params[@"tradeNo"] = tradeNo;
    params[@"voucherNo"] = voucherNo;
    params[@"outBizNo"] = outBizNo;
    self.orderSubmitRequest.requestParameter = params;
    [self.orderSubmitRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDTradeSubmitPaymentRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.orderSubmitRequest;
}

- (CMNetworkRequest *)queryPaymentMethodListWithTradeNo:(NSString *)tradeNo
                                                success:(void (^_Nullable)(HDQueryPaymentMethodRspModel *rspModel))successBlock
                                                failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradeNo"] = tradeNo;
    params[@"payScene"] = @"APP";
    self.queryPaymentMethodRequest.requestParameter = params;
    [self.queryPaymentMethodRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDQueryPaymentMethodRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryPaymentMethodRequest;
}

- (CMNetworkRequest *)submitOrderParamsWithPaymentMethod:(HDCheckStandPaymentTools)payWay
                                                 orderNo:(NSString *_Nonnull)orderNo
                                                 tradeNo:(NSString *)tradeNo
                                                 success:(void (^_Nullable)(HDCheckStandOrderSubmitParamsRspModel *rspModel))successBlock
                                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"payWay"] = payWay;
    params[@"tradeNo"] = tradeNo;
    params[@"payScene"] = @"APP";
    if ([payWay isEqualToString:@"43"]) { // ac支付，增加 returnDeeplink  资金渠道App支付完唤起WOWNOW APP
        params[@"returnDeeplink"] = @"superapp://";
    } else if([payWay isEqualToString:@"45"]) {
        params[@"returnDeeplink"] = [NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?orderNo=%@", orderNo];
    }
    self.submitPaymentParamsRequest.requestParameter = params;
    [self.submitPaymentParamsRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDCheckStandOrderSubmitParamsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.submitPaymentParamsRequest;
}

- (CMNetworkRequest *)createPayOrderWithReturnUrl:(NSString *)returnUrl
                                          orderNo:(NSString *)orderNo
                                          trialId:(NSString *_Nullable)trialId
                                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    return [self createPayOrderWithReturnUrl:returnUrl orderNo:orderNo trialId:trialId payableAmount:payableAmount discountAmount:discountAmount isCashOnDelivery:NO success:successBlock
                                     failure:failureBlock];
}

- (CMNetworkRequest *)createPayOrderWithReturnUrl:(NSString *)returnUrl
                                          orderNo:(NSString *)orderNo
                                          trialId:(NSString *_Nullable)trialId
                                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                                 isCashOnDelivery:(BOOL)isCashOnDelivery
                                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"returnUrl"] = returnUrl;
    params[@"aggregateOrderNo"] = orderNo;
    if (HDIsStringNotEmpty(trialId)) {
        params[@"trialId"] = trialId;
    }
    if (discountAmount) {
        params[@"discountAmount"] = @{@"cent": discountAmount.cent, @"currency": discountAmount.cy};
    }

    params[@"totalPayableAmount"] = @{@"cent": payableAmount.cent, @"currency": payableAmount.cy};

    //针对货到付款处理
    if (isCashOnDelivery) {
        params[@"payType"] = @(10);
    }

    self.createPayOrderRequest.requestParameter = params;
    [self.createPayOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDCreatePayOrderRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.createPayOrderRequest;
}

- (CMNetworkRequest *)queryPaymentAnnouncementSuccess:(void (^_Nullable)(HDQueryAnnoncementRspModel *_Nullable announcement))success failure:(_Nullable CMNetworkFailureBlock)failure {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/app/pay/bulletin/detail.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.retryCount = 2;
    request.isNeedLogin = YES;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !success ?: success([HDQueryAnnoncementRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failure ?: failure(response.extraData, response.errorType, response.error);
    }];
    return request;
}

- (void)queryPaymentAvailableActivityAnnouncementWithMerchantNo:(NSString *_Nonnull)merchantNo
                                                        storeNo:(NSString *_Nonnull)storeNo
                                                   businessLine:(SAClientType)businessLine
                                                          goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                                  payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                                        success:(void (^)(SAQueryPaymentAvailableActivityAnnouncementRspModel *_Nonnull rspModel))successBlock
                                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/activity/paymentChannel/listActivityBulletin.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchantNo"] = merchantNo;
    params[@"storeNo"] = storeNo;
    params[@"businessLine"] = businessLine;
    params[@"payableAmount"] = @{@"cent": payableAmount.cent, @"currency": payableAmount.cy};
    params[@"goods"] = [goods mapObjectsUsingBlock:^id _Nonnull(SAGoodsModel *_Nonnull obj, NSUInteger idx) {
        return @{@"goodsId": obj.goodsId, @"snapshotId": obj.snapshotId, @"skuId": obj.skuId, @"propertyIds": HDIsArrayEmpty(obj.propertys) ? @[] : obj.propertys, @"quantity": @(obj.quantity)};
    }];

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAQueryPaymentAvailableActivityAnnouncementRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryAvaliableOnlinePaymentToolsWithMerchantNo:(NSString *_Nonnull)merchantNo
                                               success:(void (^_Nullable)(NSArray<HDOnlinePaymentToolsModel *> *_Nullable paymentTools))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/payTool/list";
    request.isNeedLogin = YES;
    //    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchantNo"] = merchantNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<HDOnlinePaymentToolsModel *> *onlinePaymentTools = [NSArray yy_modelArrayWithClass:HDOnlinePaymentToolsModel.class json:rspModel.data];
        !successBlock ?: successBlock(onlinePaymentTools);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryPaymentAvailableActivityWithMerchantNo:(NSString *_Nonnull)merchantNo
                                            storeNo:(NSString *_Nonnull)storeNo
                                       businessLine:(SAClientType)businessLine
                                              goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                      payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   aggregateOrderNo:(NSString *_Nullable)aggregateOrderNo
                                            success:(void (^)(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys))successBlock
                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/marketing/findPaymentChannelAvailableActivity.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchantNo"] = merchantNo;
    params[@"storeNo"] = storeNo;
    params[@"businessLine"] = businessLine;
    params[@"payableAmount"] = @{@"cent": payableAmount.cent, @"currency": payableAmount.cy, @"amount": payableAmount.amount};
    params[@"goods"] = [goods mapObjectsUsingBlock:^id _Nonnull(SAGoodsModel *_Nonnull obj, NSUInteger idx) {
        return @{@"goodsId": obj.goodsId, @"snapshotId": obj.snapshotId, @"skuId": obj.skuId, @"propertyIds": HDIsArrayEmpty(obj.propertys) ? @[] : obj.propertys, @"quantity": @(obj.quantity)};
    }];

    if (HDIsStringNotEmpty(aggregateOrderNo)) {
        params[@"aggregateOrderNo"] = aggregateOrderNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<SAPaymentToolsActivityModel *> *activitys = [NSArray yy_modelArrayWithClass:SAPaymentToolsActivityModel.class json:rspModel.data];
        !successBlock ?: successBlock(activitys);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (CMNetworkRequest *)getQRCodePayDetailWithAggregateOrderNo:(NSString *)aggregateOrderNo
                                                     success:(void (^)(HDCheckStandQRCodePayDetailRspModel *_Nonnull))successBlock
                                                     failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = aggregateOrderNo;

    self.qrCodePayRequest.requestParameter = params;
    [self.qrCodePayRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([HDCheckStandQRCodePayDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.qrCodePayRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)closeOrderRequest {
    if (!_closeOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/super-payment/trade/order/close";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _closeOrderRequest = request;
    }
    return _closeOrderRequest;
}

- (CMNetworkRequest *)orderBuildRequest {
    if (!_orderBuildRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/trade/collection/build";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _orderBuildRequest = request;
    }
    return _orderBuildRequest;
}

- (CMNetworkRequest *)orderCreateRequest {
    if (!_orderCreateRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/trade/payment/create";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _orderCreateRequest = request;
    }
    return _orderCreateRequest;
}

- (CMNetworkRequest *)payConfirmRequest {
    if (!_payConfirmRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/trade/payment/confirm";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _payConfirmRequest = request;
    }
    return _payConfirmRequest;
}

- (CMNetworkRequest *)orderSubmitRequest {
    if (!_orderSubmitRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/super-payment/cashier/payment/submit";
        request.shouldAlertErrorMsgExceptSpecCode = true;
        _orderSubmitRequest = request;
    }
    return _orderSubmitRequest;
}

- (CMNetworkRequest *)queryOrderStatusRequest {
    if (!_queryOrderStatusRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/trade/query/orderState";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _queryOrderStatusRequest = request;
    }
    return _queryOrderStatusRequest;
}

- (CMNetworkRequest *)verifyPayPwdRequest {
    if (!_verifyPayPwdRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/tradePwd/validate/pwd/update.do";
        _verifyPayPwdRequest = request;
    }
    return _verifyPayPwdRequest;
}

- (CMNetworkRequest *)queryPaymentMethodRequest {
    if (!_queryPaymentMethodRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/super-payment/cashier-front-service/payment/tools";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _queryPaymentMethodRequest = request;
    }
    return _queryPaymentMethodRequest;
}

- (CMNetworkRequest *)submitPaymentParamsRequest {
    if (!_submitPaymentParamsRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/super-payment/payment/quick-create";
        _submitPaymentParamsRequest = request;
        _submitPaymentParamsRequest.shouldAlertErrorMsgExceptSpecCode = NO;
    }
    return _submitPaymentParamsRequest;
}

- (CMNetworkRequest *)createPayOrderRequest {
    if (!_createPayOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/pay/createPayOrder";
        _createPayOrderRequest = request;
    }
    return _createPayOrderRequest;
}

- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    return _getEncryptFactorDTO ?: ({ _getEncryptFactorDTO = SAGetEncryptFactorDTO.new; });
}

- (CMNetworkRequest *)qrCodePayRequest {
    if (!_qrCodePayRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/pay/detail";
        _qrCodePayRequest = request;
        _qrCodePayRequest.shouldAlertErrorMsgExceptSpecCode = NO;
    }
    return _qrCodePayRequest;
}

@end
