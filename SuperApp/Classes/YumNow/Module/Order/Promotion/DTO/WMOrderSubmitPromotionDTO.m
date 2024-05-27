//
//  WMOrderSubmitPromotionDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitPromotionDTO.h"
#import "WMOrderSubmitPromotionModel.h"


@interface WMOrderSubmitPromotionDTO ()

/// 营销查询可用优惠活动
@property (nonatomic, strong) CMNetworkRequest *promotionListRequest;

@end


@implementation WMOrderSubmitPromotionDTO

- (void)dealloc {
    [_promotionListRequest cancel];
}

- (CMNetworkRequest *)getPromotionListWithBusinessType:(SAMarketingBusinessType)businessType
                                               storeNo:(NSString *)storeNo
                                          currencyType:(NSString *)currencyType
                                                amount:(NSString *)amount
                                           deliveryAmt:(NSString *)deliveryAmt
                                            merchantNo:(NSString *)merchantNo
                                            packingAmt:(NSString *)packingAmt
                                 specialMarketingTypes:(NSArray<NSNumber *> *)specialMarketingTypes
                                               success:(void (^_Nullable)(NSArray<WMOrderSubmitPromotionModel *> *_Nullable list))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.promotionListRequest cancel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"storeNo"] = storeNo;
    params[@"currencyType"] = currencyType;
    params[@"amount"] = amount;
    params[@"deliveryAmt"] = deliveryAmt;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"merchantNo"] = merchantNo;
    // 给时间，后台只取年月日
    params[@"orderTime"] = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000];
    params[@"packingAmt"] = packingAmt;
    params[@"specialMarketingTypes"] = specialMarketingTypes;
    self.promotionListRequest.requestParameter = params;
    [self.promotionListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:WMOrderSubmitPromotionModel.class json:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.promotionListRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)promotionListRequest {
    if (!_promotionListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/marketing/findAvaliableActivity.do";

        _promotionListRequest = request;
    }
    return _promotionListRequest;
}

@end
