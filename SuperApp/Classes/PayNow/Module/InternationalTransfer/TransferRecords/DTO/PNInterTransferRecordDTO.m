//
//  PNInterTransferRecordDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRecordDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNInterTransferRecordRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNInterTransferRecordDTO
- (void)queryInterTransferRecordListWithPageNum:(NSInteger)pageNum
                                       pageSize:(NSInteger)pageSize
                                        success:(void (^)(PNInterTransferRecordRspModel *rspModel))successBlock
                                        failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/orderInfo/inquiryTransferRecord";
    request.isNeedLogin = YES;
    request.requestParameter = @{@"pageNum": @(pageNum), @"pageSize": @(pageSize)};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNInterTransferRecordRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
