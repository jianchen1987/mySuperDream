//
//  TNPaymentDTO.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentDTO.h"
#import "SAGeneralUtil.h"
#import "SAShoppingAddressModel.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNCheckSumitOrderModel.h"
#import "TNGetPaymentMethodsRspModel.h"
#import "TNGetShippingMethodsRspModel.h"
#import "TNPaymentMethodModel.h"
#import "TNShippingMethodModel.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNSubmitOrderNoticeModel.h"
#import "WMOrderSubmitRspModel.h"
#import <HDKitCore/HDKitCore.h>
#import "TNDeliveryComponyModel.h"

@interface TNShoppingCarDeleteItem : TNModel
/// 购物项展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 减少数量
@property (nonatomic, strong) NSNumber *deleteDelta;
/// 业务线
@property (nonatomic, copy) NSString *businessType;
@end


@implementation TNShoppingCarDeleteItem

@end


@interface TNPaymentDTO ()

@end


@implementation TNPaymentDTO

- (void)calculateTotalPayFeeTrialWithCouponCode:(NSString *_Nullable)coupon
                                 shippingMethod:(TNShippingMethodModel *_Nonnull)shippingMethod
                                  groupBuyingId:(NSString *_Nullable)groupBuyingId
                                      invoiceId:(NSString *_Nullable)invoiceId
                                        address:(SAShoppingAddressModel *_Nonnull)address
                                  paymentMethod:(TNPaymentMethodModel *_Nonnull)paymentMethod
                                           memo:(NSString *)memo
                             platformCouponCode:(NSString *)platformCouponCode
                         platformCouponDiscount:(NSString *)platformCouponDiscount
                          storeShoppingCarModel:(TNShoppingCarStoreModel *_Nonnull)storeCar
                                   deliveryTime:(NSString *)deliveryTime
                                    appointment:(TNOrderAppointmentType)appointment
                                      salesType:(TNSalesType)salesType
                                  promotionCode:(NSString *)promotionCode
                               deliveryCorpCode:(NSString *)deliveryCorpCode
                                        success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/calculate/v3";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    //    @"/api/merchant/order/calculate/v2";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!paymentMethod) {
        params[@"paymentMethodId"] = paymentMethod.paymentMethodId;
    }

    if (address) {
        params[@"receiverId"] = address.addressNo;
    }
    params[@"shippingMethodId"] = @"1"; // shippingMethod.shippingMethodId;
    if (HDIsStringNotEmpty(invoiceId)) {
        params[@"invoiceId"] = invoiceId;
    }
    if (HDIsStringNotEmpty(groupBuyingId)) {
        params[@"groupBuyingId"] = groupBuyingId;
    }
    if (HDIsStringNotEmpty(memo)) {
        params[@"memo"] = memo;
    }
    if (HDIsStringNotEmpty(coupon)) {
        params[@"couponCode"] = coupon;
    }
    if (HDIsStringNotEmpty(platformCouponCode)) {
        params[@"platformCouponCode"] = platformCouponCode;
    }
    if (HDIsStringNotEmpty(platformCouponDiscount)) {
        params[@"platformCouponDiscount"] = platformCouponDiscount;
    }
    if (appointment > 0) {
        params[@"appointmentType"] = [NSNumber numberWithInteger:appointment];
    }
    if (appointment == TNOrderAppointmentTypeReserve && HDIsStringNotEmpty(deliveryTime)) {
        params[@"deliveryTime"] = deliveryTime;
    }
    /// 这里加 flow  批量  flow = "general"
    if (HDIsStringNotEmpty(salesType) && [salesType isEqualToString:TNSalesTypeBatch]) {
        params[@"flow"] = @"general";
    }
    if (HDIsStringNotEmpty(promotionCode)) {
        params[@"promotionCode"] = promotionCode;
    }
    if (HDIsStringNotEmpty(deliveryCorpCode)) {
        params[@"deliveryCorpCode"] = deliveryCorpCode;
    }
    // 加上时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    if (HDIsStringNotEmpty(zone.name)) {
        params[@"timeZone"] = zone.name;
    }
    NSArray<TNCalcPaymentFeeGoodsModel *> *cartItems = [storeCar.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        TNCalcPaymentFeeGoodsModel *model = TNCalcPaymentFeeGoodsModel.new;
        model.shareCode = obj.shareCode;
        model.quantity = obj.quantity;
        model.skuId = obj.goodsSkuId;
        model.goodsId = obj.goodsId;
        model.sp = obj.sp;
        return model;
    }];
    params[@"cartItemDTOS"] = [cartItems yy_modelToJSONObject];

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCalcTotalPayFeeTrialRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getPaymentMethodsWithStoreNo:(NSString *)storeNo
                            latitude:(nonnull NSNumber *)latitude
                           longitude:(nonnull NSNumber *)longitude
                             Success:(void (^_Nullable)(TNGetPaymentMethodsRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/paymentV2";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(storeNo)) {
        params[@"storeNo"] = storeNo;
    }
    params[@"latitude"] = latitude.stringValue;
    params[@"longitude"] = longitude.stringValue;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGetPaymentMethodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)getShippingMethodsSuccess:(void (^_Nullable)(TNGetShippingMethodsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/shipping";

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNGetShippingMethodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderSubmitWithStoreShoppingCar:(TNShoppingCarStoreModel *_Nonnull)storeShoppingCar
                                payType:(TNPaymentMethodModel *_Nonnull)paymentMethod
                           shippingType:(TNShippingMethodModel *_Nonnull)shippingMethod
                            orderAmount:(SAMoneyModel *_Nonnull)orderAmount
                         discountAmount:(SAMoneyModel *_Nonnull)discountAmount
                          paymentAmount:(SAMoneyModel *_Nonnull)paymentAmount
                             couponCode:(NSString *_Nullable)couponCode
                           addressModel:(SAShoppingAddressModel *_Nonnull)addressModel
                                   memo:(NSString *_Nullable)memo
                     platformCouponCode:(NSString *)platformCouponCode
                 platformCouponDiscount:(NSString *)platformCouponDiscount
                 verificationPromotions:(nonnull NSArray *)verificationPromotions
                              riskToken:(NSString *)riskToken
                           deliveryTime:(NSString *)deliveryTime
                            appointment:(TNOrderAppointmentType)appointment
                              salesType:(TNSalesType)salesType
                           randomString:(NSString *)randomString
                      freightPriceChina:(SAMoneyModel *_Nonnull)freightPriceChina
                          promotionCode:(NSString *)promotionCode // 优惠码
                  promotionCodeDiscount:(NSString *)promotionCodeDiscount
                       deliveryCorpCode:(NSString *)deliveryCorpCode
                                success:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/order/v2/save";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO; // 提交订单自定义处理

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    params[@"payType"] = paymentMethod.methodValue;
    params[@"totalTrialPrice"] = paymentAmount.centFace;
    params[@"businessLine"] = SAClientTypeTinhNow;
    params[@"discountAmount"] = discountAmount.centFace;
    if (HDIsStringNotEmpty(memo)) {
        params[@"description"] = memo;
    }
    params[@"currency"] = orderAmount.cy;
    params[@"totalCommodityPrice"] = storeShoppingCar.totalPrice.centFace;

    NSArray<TNShoppingCarDeleteItem *> *deleteItems = [storeShoppingCar.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        if (HDIsStringEmpty(obj.itemDisplayNo) || HDIsStringNotEmpty(obj.invalidMsg)) {
            return nil;
        }
        TNShoppingCarDeleteItem *item = TNShoppingCarDeleteItem.new;
        item.itemDisplayNo = obj.itemDisplayNo;
        item.deleteDelta = obj.quantity;
        item.businessType = @"11";
        return item;
    }];
    params[@"deleteCartItemsReqDTO"] = @{@"deleteItems": [deleteItems yy_modelToJSONObject]};
    params[@"storeNo"] = storeShoppingCar.storeNo;
    params[@"returnUrl"] = [NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", SAClientTypeTinhNow];
    params[@"autoCreatePayOrder"] = @"false";

    // 业务参数
    NSMutableDictionary *businessParams = [NSMutableDictionary dictionary];

    NSArray<TNCalcPaymentFeeGoodsModel *> *items = [storeShoppingCar.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        if (HDIsStringEmpty(obj.invalidMsg)) {
            TNCalcPaymentFeeGoodsModel *model = TNCalcPaymentFeeGoodsModel.new;
            model.shareCode = obj.shareCode;
            model.quantity = obj.quantity;
            model.skuId = obj.goodsSkuId;
            model.goodsId = obj.goodsId;
            model.sp = obj.sp;
            return model;
        } else {
            return nil;
        }
    }];
    businessParams[@"storeList"] = @[@{@"items": [items yy_modelToJSONObject], @"storeNo": storeShoppingCar.storeNo}];
    if (HDIsStringNotEmpty(couponCode)) {
        businessParams[@"couponCode"] = couponCode;
    }

    businessParams[@"addressNo"] = addressModel.addressNo;
    businessParams[@"paymentMethodId"] = paymentMethod.paymentMethodId;
    businessParams[@"shippingTypeId"] = @"1"; // shippingMethod.shippingMethodId;
    if (HDIsStringNotEmpty(randomString)) {
        businessParams[@"randomStr"] = randomString;
    }
    /// 这里加 flow  批量  flow = "general"
    if (HDIsStringNotEmpty(salesType) && [salesType isEqualToString:TNSalesTypeBatch]) {
        businessParams[@"flow"] = @"general";
    }
    if (HDIsStringNotEmpty(memo)) {
        businessParams[@"memo"] = memo;
    }
    if (HDIsStringNotEmpty(platformCouponCode)) {
        businessParams[@"platformCouponCode"] = platformCouponCode;
    }
    if (HDIsStringNotEmpty(platformCouponDiscount)) {
        businessParams[@"platformCouponDiscount"] = platformCouponDiscount;
    }

    if (HDIsStringNotEmpty(promotionCode)) {
        businessParams[@"promotionCode"] = promotionCode;
    }
    if (HDIsStringNotEmpty(promotionCodeDiscount)) {
        businessParams[@"promotionCodeDiscount"] = promotionCodeDiscount;
    }

    if (!HDIsObjectNil(freightPriceChina)) {
        businessParams[@"freightPriceChina"] = freightPriceChina.centFace;
    }
    if (appointment > 0) {
        businessParams[@"appointmentType"] = [NSNumber numberWithInteger:appointment];
    }
    if (appointment == TNOrderAppointmentTypeReserve && HDIsStringNotEmpty(deliveryTime)) {
        businessParams[@"deliveryTime"] = deliveryTime;
    }
    // 加上时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    if (HDIsStringNotEmpty(zone.name)) {
        businessParams[@"timeZone"] = zone.name;
    }
    // 如果是在线支付  还要加上在线支付渠道
    if ([paymentMethod.method isEqualToString:TNPaymentMethodOnLine] && !HDIsObjectNil(paymentMethod.selectedOnlineMethodType)) {
        businessParams[@"payChannelCode"] = paymentMethod.selectedOnlineMethodType.toolCode;
    }

    if (HDIsStringNotEmpty(deliveryCorpCode)) {
        businessParams[@"deliveryCorpCode"] = deliveryCorpCode;
    }

    params[@"businessParams"] = businessParams;
    // 包装营销活动参数
    if (!HDIsArrayEmpty(verificationPromotions)) {
        NSMutableDictionary *verifiParams = [NSMutableDictionary dictionary];
        verifiParams[@"verificationPromotions"] = verificationPromotions;
        params[@"marketingReqDTO"] = verifiParams;
    }

    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)getSubmitOrderNoticeDataSuccess:(void (^)(TNSubmitOrderNoticeModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/shop/freight/notice";

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNSubmitOrderNoticeModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)getUnifiedOrderNoByRandomStr:(NSString *)randomStr success:(void (^)(NSString *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/getUnifiedOrderNoByRandomStr";
    request.requestParameter = @{@"randomStr": randomStr};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        id data = rspModel.data;
        NSString *orderNo;
        if ([data isKindOfClass:[NSString class]]) {
            orderNo = data;
        }
        !successBlock ?: successBlock(orderNo);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)checkOrderCanSubmitWithLatitude:(NSNumber *)latitude
                              longitude:(NSNumber *)longitude
                                storeNo:(NSString *)storeNo
                          paymentMethod:(TNPaymentMethod)paymentMethod
                                  scene:(NSString *)scene
                           productItems:(NSArray<TNShoppingCarItemModel *> *)productItems
                                success:(void (^)(TNCheckSumitOrderModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/api/merchant/order/check/beforeSubmit";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *reginDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *duplicateDict = [NSMutableDictionary dictionary];

    // 经纬度相关
    reginDict[@"latitude"] = latitude.stringValue;
    reginDict[@"longitude"] = longitude.stringValue;
    reginDict[@"storeNo"] = storeNo;
    reginDict[@"paymentMethod"] = paymentMethod;
    if (HDIsStringNotEmpty(scene)) {
        reginDict[@"scene"] = scene;
    }

    // 重复订单相关
    duplicateDict[@"storeNo"] = storeNo;
    if (!HDIsArrayEmpty(productItems)) {
        NSArray<TNCalcPaymentFeeGoodsModel *> *items = [productItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
            if (HDIsStringEmpty(obj.invalidMsg)) {
                TNCalcPaymentFeeGoodsModel *model = TNCalcPaymentFeeGoodsModel.new;
                model.quantity = obj.quantity;
                model.skuId = obj.goodsSkuId;
                return model;
            } else {
                return nil;
            }
        }];
        duplicateDict[@"duplicateSkuDTOList"] = [items yy_modelToJSONObject];
    }
    params[@"storeRegionReqDTO"] = reginDict;
    params[@"createOrderDuplicateCheckReq"] = duplicateDict;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCheckSumitOrderModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryCalculateFreightStandardCostsByStoreNo:(NSString *)storeNo
                                         productIds:(NSArray *)productIds
                                            success:(void (^_Nullable)(NSArray<TNDeliveryComponyModel *> *_Nonnull))successBlock
                                            failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/tapi/sales/order/delivery/matchByStoreAndProduct";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"productIds"] = productIds;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:TNDeliveryComponyModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
