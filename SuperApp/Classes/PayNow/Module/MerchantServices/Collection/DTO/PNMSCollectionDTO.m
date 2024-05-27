//
//  PNMSCollectionDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionDTO.h"
#import "PNCommonUtils.h"
#import "PNMSCollectionModel.h"
#import "PNRspModel.h"


@implementation PNMSCollectionDTO
/// 商户 今日统计
- (void)getMSDayCountWithMerchantNo:(NSString *)merchantNo success:(void (^_Nullable)(PNMSCollectionModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/merchant/count.do";

    NSString *dayStr = [PNCommonUtils getDateStrByFormat:@"yyyy-MM-dd" withDate:NSDate.date];

    request.requestParameter = @{
        @"merId": merchantNo,
        @"day": dayStr,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSCollectionModel *listModel = [PNMSCollectionModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(listModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
