//
//  TransViewModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TransViewModel.h"


@implementation TransViewModel
#pragma mark - public methods
- (void)getData:(NSDictionary *)params Api:(NSString *)api {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = api;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.retryCount = 2;
    request.isNeedLogin = YES;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !self.successGetDataBlock ?: self.successGetDataBlock(response);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !self.failedGetDataBlock ?: self.failedGetDataBlock(response);
    }];
}
@end
