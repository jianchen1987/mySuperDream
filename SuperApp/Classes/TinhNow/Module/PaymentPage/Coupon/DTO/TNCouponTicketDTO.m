//
//  TNCouponDTO.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCouponTicketDTO.h"


@implementation TNCouponTicketDTO

- (void)getCouponByParamsModel:(TNCouponParamsModel *)paramsModel
                      pageSize:(NSUInteger)pageSize
                       pageNum:(NSUInteger)pageNum
                       Success:(void (^)(WMOrderSubmitCouponRspModel *_Nonnull))successBlock
                       failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/marketing/findAvaliableCoupon.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = paramsModel.storeNo;
    params[@"currencyType"] = paramsModel.currencyType;
    params[@"amount"] = paramsModel.amount;
    params[@"orderTime"] = paramsModel.orderTime;
    params[@"merchantNo"] = paramsModel.merchantNo;
    params[@"deliveryAmt"] = paramsModel.deliveryAmt;
    params[@"packingAmt"] = paramsModel.packingAmt;
    params[@"businessType"] = paramsModel.businessType; //电商专用
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"skuList"] = paramsModel.skuList;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitCouponRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
