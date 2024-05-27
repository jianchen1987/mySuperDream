//
//  TNReviewDTO.m
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNReviewDTO.h"
#import "TNQueryProductReviewListRspModel.h"


@interface TNReviewDTO ()
@end


@implementation TNReviewDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.showAlertErrorMsgExceptSpecCode = YES;
    }
    return self;
}

- (void)queryProductReviewListWithProductId:(NSString *)productId
                                    pageNum:(NSUInteger)pageNum
                                   pageSize:(NSUInteger)pageSize
                                    success:(void (^_Nullable)(TNQueryProductReviewListRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/product/review/list";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = self.showAlertErrorMsgExceptSpecCode;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = productId;
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNum];
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryProductReviewListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
