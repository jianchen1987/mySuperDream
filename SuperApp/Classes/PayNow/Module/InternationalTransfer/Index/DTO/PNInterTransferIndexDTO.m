//
//  PNInterTransferIndexDTO.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferIndexDTO.h"
#import "PNCAMNetworRequest.h"
#import "PNInterTransferRecordRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNInterTransferIndexDTO

/// 查询付款人所有收款人列表
- (void)queryInterTransferRecentRecordListWithPageNum:(NSInteger)pageNum
                                             pageSize:(NSInteger)pageSize
                                              success:(void (^)(PNInterTransferRecordRspModel *rspModel))successBlock
                                              failure:(PNNetworkFailureBlock)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/fxt/app/orderInfo/inquiryTrByBeneficiaryId";
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
