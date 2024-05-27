//
//  HDWebViewModel.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/27.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebViewModel.h"

static HDWebViewModel *_webViewModel;


@implementation HDWebViewModel

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webViewModel = [[HDWebViewModel alloc] init];
    });

    return _webViewModel;
}

- (void)postWebIntferface:(NSString *)interfaceText parameter:(NSDictionary *)param success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = interfaceText;
    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
