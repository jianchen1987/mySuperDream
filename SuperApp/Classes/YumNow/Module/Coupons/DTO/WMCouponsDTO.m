//
//  WMCouponsDTO.m
//  SuperApp
//
//  Created by wmz on 2022/7/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponsDTO.h"
#import "SAWindowManager.h"


@implementation WMCouponsDTO

- (void)getVoucherCouponListWithStoreNo:(NSString *)storeNo
                                 amount:(NSString *)amount
                            deliveryAmt:(NSString *)deliveryAmt
                             packingAmt:(NSString *)packingAmt
                           currencyType:(NSString *)currencyType
                             merchantNo:(NSString *)merchantNo
                           hasPromoCode:(NSString *)hasPromoCode
                      hasShippingCoupon:(NSString *)hasShippingCoupon
                               couponNo:(nullable NSString *)couponNo
                              addressNo:(NSString *)addressNo
                            activityNos:(NSArray<NSString *> *)activityNos
                                success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-voucher-coupon-list";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = NSMutableDictionary.new;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"pageNum"] = @(1);
    params[@"pageSize"] = @(200);
    params[@"orderTime"] = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000];
    params[@"hasPromoCode"] = hasPromoCode;
    params[@"hasShippingCoupon"] = hasShippingCoupon;
    params[@"storeNo"] = storeNo;
    params[@"currencyType"] = currencyType;
    params[@"amount"] = amount;
    params[@"deliveryAmt"] = deliveryAmt;
    params[@"merchantNo"] = merchantNo;
    params[@"packingAmt"] = packingAmt;
    params[@"addressNo"] = addressNo;
    params[@"appVersion"] = [HDDeviceInfo appVersion];
    if (couponNo) {
        params[@"couponNo"] = couponNo;
    }
    if (activityNos) {
        params[@"activityNos"] = activityNos;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderSubmitCouponRspModel *model = [WMOrderSubmitCouponRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMOrderSubmitCouponRspModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getShippingCouponListWithStoreNo:(NSString *)storeNo
                                  amount:(NSString *)amount
                             deliveryAmt:(NSString *)deliveryAmt
                              packingAmt:(NSString *)packingAmt
                            currencyType:(NSString *)currencyType
                              merchantNo:(NSString *)merchantNo
                            hasPromoCode:(NSString *)hasPromoCode
                       hasShippingCoupon:(NSString *)hasShippingCoupon
                                couponNo:(nullable NSString *)couponNo
                               addressNo:(NSString *)addressNo
                             activityNos:(NSArray<NSString *> *)activityNos
                                 success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-shipping-coupon-list";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = NSMutableDictionary.new;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"pageNum"] = @(1);
    params[@"pageSize"] = @(200);
    params[@"orderTime"] = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000];
    params[@"hasPromoCode"] = hasPromoCode;
    params[@"hasShippingCoupon"] = hasShippingCoupon;
    params[@"storeNo"] = storeNo;
    params[@"currencyType"] = currencyType;
    params[@"amount"] = amount;
    params[@"deliveryAmt"] = deliveryAmt;
    params[@"merchantNo"] = merchantNo;
    params[@"packingAmt"] = packingAmt;
    params[@"addressNo"] = addressNo;
    params[@"appVersion"] = [HDDeviceInfo appVersion];
    if (couponNo) {
        params[@"couponNo"] = couponNo;
    }
    if (activityNos) {
        params[@"activityNos"] = activityNos;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOrderSubmitCouponRspModel *model = [WMOrderSubmitCouponRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMOrderSubmitCouponRspModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getStoreCouponActivityStoreNo:(NSString *)storeNo success:(void (^_Nullable)(WMCouponActivityContentModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-store-coupon-activity";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.isNeedLogin = YES;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"storeNo"] = storeNo;
    mdic[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMCouponActivityContentModel *model = [WMCouponActivityContentModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMCouponActivityContentModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getStoreAllCouponActivityStoreNo:(NSString *)storeNo success:(void (^_Nullable)(WMCouponActivityModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-all-store-coupon-activity";
    request.isNeedLogin = YES;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"storeNo"] = storeNo;
    mdic[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMCouponActivityModel *model = [WMCouponActivityModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMCouponActivityModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getOneClickCouponWithActivityNo:(NSString *)activityNo
                               couponNo:(NSArray<NSString *> *)couponNo
                            storeJoinNo:(NSString *)storeJoinNo
                                storeNo:(NSString *)storeNo
                                success:(void (^_Nullable)(WMOneClickResultModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/one-click-coupon";
    request.isNeedLogin = YES;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"storeNo"] = storeNo;
    mdic[@"activityNo"] = activityNo;
    mdic[@"storeJoinNo"] = storeJoinNo;
    mdic[@"couponNo"] = couponNo;
    mdic[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOneClickResultModel *model = [WMOneClickResultModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMOneClickResultModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)giveCouponWithActivityNo:(NSString *)activityNo
                        couponNo:(NSString *)couponNo
                     storeJoinNo:(NSString *)storeJoinNo
                         storeNo:(NSString *)storeNo
                         success:(void (^_Nullable)(WMOneClickItemResultModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/give-coupon";
    request.isNeedLogin = YES;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    mdic[@"storeNo"] = storeNo;
    mdic[@"activityNo"] = activityNo;
    mdic[@"storeJoinNo"] = storeJoinNo;
    mdic[@"couponNo"] = couponNo;
    mdic[@"operatorNo"] = SAUser.shared.operatorNo;
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMOneClickItemResultModel *model = [WMOneClickItemResultModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMOneClickItemResultModel.class]) {
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
