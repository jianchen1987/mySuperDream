//
//  PNOutletDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOutletDTO.h"
#import "PNRspModel.h"


@implementation PNOutletDTO

/// 附近CoolCash网点
- (void)searchNearCoolCashMerchantWithLongitude:(double)longitude
                                       latitude:(double)latitude
                                       distance:(NSInteger)distance
                                   successBlock:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                                        failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/nearby/merchants.do";
    request.requestParameter = @{@"longitude": [NSString stringWithFormat:@"%f", longitude], @"latitude": [NSString stringWithFormat:@"%f", latitude], @"distance": @(distance)};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
