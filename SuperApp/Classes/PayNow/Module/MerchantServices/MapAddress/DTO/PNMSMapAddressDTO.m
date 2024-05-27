//
//  PNMSMapAddressDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSMapAddressDTO.h"
#import "PNMSMapAddressModel.h"
#import "PNRspModel.h"


@implementation PNMSMapAddressDTO

/// 商户省份列表
- (void)getProvinces:(void (^)(NSArray<PNMSMapAddressModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/provinces.do";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:PNMSMapAddressModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
