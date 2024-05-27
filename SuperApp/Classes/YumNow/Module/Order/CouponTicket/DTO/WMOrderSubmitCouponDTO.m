//
//  WMOrderSubmitCouponDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitCouponDTO.h"
#import "WMOrderSubmitCouponRspModel.h"


@interface WMOrderSubmitCouponDTO ()

/// 营销查询可用优惠券
@property (nonatomic, strong) CMNetworkRequest *couponListRequest;

@end


@implementation WMOrderSubmitCouponDTO

- (void)dealloc {
    [_couponListRequest cancel];
}

- (CMNetworkRequest *)getCouponListWithBusinessType:(SAMarketingBusinessType)businessType
                                            storeNo:(NSString *)storeNo
                                       currencyType:(NSString *)currencyType
                                             amount:(NSString *)amount
                                        deliveryAmt:(NSString *)deliveryAmt
                                         packingAmt:(NSString *)packingAmt
                                           pageSize:(NSUInteger)pageSize
                                            pageNum:(NSUInteger)pageNum
                                         merchantNo:(NSString *)merchantNo
                                          addressNo:(NSString *)addressNo
                                            success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock)failureBlock {
    [self.couponListRequest cancel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"storeNo"] = storeNo;
    params[@"currencyType"] = currencyType;
    params[@"amount"] = amount;
    params[@"deliveryAmt"] = deliveryAmt;
    params[@"pageSize"] = @(pageSize);
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"pageNum"] = @(pageNum);
    params[@"merchantNo"] = merchantNo;
    // 给时间，后台只取年月日
    params[@"orderTime"] = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000];
    params[@"packingAmt"] = packingAmt;
    params[@"addressNo"] = addressNo;
    self.couponListRequest.requestParameter = params;
    [self.couponListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitCouponRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.couponListRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)couponListRequest {
    if (!_couponListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/marketing/findAvaliableCoupon.do";

        _couponListRequest = request;
    }
    return _couponListRequest;
}

@end
