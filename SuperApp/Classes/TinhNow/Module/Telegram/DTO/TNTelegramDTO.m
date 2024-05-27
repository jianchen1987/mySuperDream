//
//  TNTelegramDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTelegramDTO.h"
#import "TNTelegramGroupModel.h"


@implementation TNTelegramDTO
- (void)queryTelegramGroupInfoSuccess:(void (^)(TNTelegramGroupModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/tg/chat/group/findClientGroupConfig";
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        TNTelegramGroupModel *model = [TNTelegramGroupModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
