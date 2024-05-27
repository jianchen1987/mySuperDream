//
//  WMStoreProductDetailDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailDTO.h"
#import "WMStoreProductDetailRspModel.h"


@interface WMStoreProductDetailDTO ()
/// 获取详情
@property (nonatomic, strong) CMNetworkRequest *getStoreProductDetailRequest;
@end


@implementation WMStoreProductDetailDTO

- (void)dealloc {
    [_getStoreProductDetailRequest cancel];
}

- (CMNetworkRequest *)getStoreProductDetailInfoWithGoodsId:(NSString *)goodsId
                                                   success:(void (^_Nullable)(WMStoreProductDetailRspModel *rspModel))successBlock
                                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = goodsId;
    self.getStoreProductDetailRequest.requestParameter = params;
    [self.getStoreProductDetailRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMStoreProductDetailRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.getStoreProductDetailRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)getStoreProductDetailRequest {
    if (!_getStoreProductDetailRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-product/app/user/product/get.do";
        request.isNeedLogin = false;
        _getStoreProductDetailRequest = request;
    }
    return _getStoreProductDetailRequest;
}
@end
