//
//  GNArticleDTO.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDTO.h"


@implementation GNArticleDTO

- (void)getArticleDetailWithCode:(NSString *)articleCode success:(void (^)(GNArticleModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;
{
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/groupon-service/user/home/article/detail";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{@"articleCode": articleCode, @"location": self.locationInfo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([GNArticleModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
