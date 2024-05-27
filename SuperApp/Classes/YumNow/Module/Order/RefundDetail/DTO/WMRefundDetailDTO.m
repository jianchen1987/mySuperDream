//
//  WMRefundDetailDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRefundDetailDTO.h"
#import "WMOrderDetailModel.h"


@interface WMRefundDetailDTO ()
/// 查询订单详情
@property (nonatomic, strong) CMNetworkRequest *queryOrderDetailRequest;
@end


@implementation WMRefundDetailDTO
- (void)dealloc {
    [_queryOrderDetailRequest cancel];
}

- (CMNetworkRequest *)queryOrderDetailInfoWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(WMOrderDetailModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    self.queryOrderDetailRequest.requestParameter = params;
    [self.queryOrderDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.queryOrderDetailRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)queryOrderDetailRequest {
    if (!_queryOrderDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-order/app/user/order/detail";
        request.isNeedLogin = true;
        _queryOrderDetailRequest = request;
    }
    return _queryOrderDetailRequest;
}
@end
