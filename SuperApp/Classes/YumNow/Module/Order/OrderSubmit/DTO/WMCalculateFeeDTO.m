//
//  WMCalculateFeeDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCalculateFeeDTO.h"
#import "WMCalculateProductPriceRspModel.h"
#import "WMOrderSubmitCalDeliveryFeeRspModel.h"
#import "WMQueryOrderInfoRspModel.h"


@interface WMCalculateFeeDTO ()
/// 计算配送费和配送时间
@property (nonatomic, strong) CMNetworkRequest *calculateDeliveryFeeRequest;
/// 计算、核算商品打包费和总价
@property (nonatomic, strong) CMNetworkRequest *calculateProductsFeeRequest;
@end


@implementation WMCalculateFeeDTO
- (void)dealloc {
    [_calculateDeliveryFeeRequest cancel];
    [_calculateProductsFeeRequest cancel];
}

- (CMNetworkRequest *)getDeliveryFeeAndDeliveryTimeWithStoreNo:(NSString *)storeNo
                                                     longitude:(NSString *)longitude
                                                      latitude:(NSString *)latitude
                                             deliveryTimeModel:(WMOrderSubscribeTimeModel *)deliveryTimeModel
                                                       success:(void (^)(WMOrderSubmitCalDeliveryFeeRspModel *rspModel))successBlock
                                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.calculateDeliveryFeeRequest cancel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"location"] = @{@"lat": latitude, @"lon": longitude};
    params[@"storeNo"] = storeNo;
    if (!HDIsObjectNil(deliveryTimeModel)) {
        params[@"arriveType"] = deliveryTimeModel.type;
        params[@"orderTime"] = deliveryTimeModel.date;
    }
    self.calculateDeliveryFeeRequest.requestParameter = params;
    [self.calculateDeliveryFeeRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitCalDeliveryFeeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.calculateDeliveryFeeRequest;
}

- (CMNetworkRequest *)calculateOrCheckProductPriceWithType:(NSUInteger)type
                                  packingChargesTotalPrice:(SAMoneyModel *_Nullable)packingChargesTotalPrice
                                                 goodsList:(NSArray<WMCalculateProductPriceGoodsItem *> *)goodsList
                                         productTotalPrice:(SAMoneyModel *_Nullable)productTotalPrice
                                                   success:(void (^)(WMCalculateProductPriceRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountingCheckEnum"] = @(type);
    params[@"productAndSpecCheckDetailsReqDTOS"] = [goodsList yy_modelToJSONObject];
    if (type == 11) {
        params[@"packingChargesTotalPrice"] = [packingChargesTotalPrice yy_modelToJSONObject];
        params[@"productTotalPrice"] = [productTotalPrice yy_modelToJSONObject];
    }
    self.calculateProductsFeeRequest.requestParameter = params;
    [self.calculateProductsFeeRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMCalculateProductPriceRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.calculateProductsFeeRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)calculateDeliveryFeeRequest {
    if (!_calculateDeliveryFeeRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-merchant/app/super-app/calculate-deliver-fee";
        _calculateDeliveryFeeRequest = request;
    }
    return _calculateDeliveryFeeRequest;
}

- (CMNetworkRequest *)calculateProductsFeeRequest {
    if (!_calculateProductsFeeRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-product/app/product/accounting/check.do";
        _calculateProductsFeeRequest = request;
    }
    return _calculateProductsFeeRequest;
}
@end
