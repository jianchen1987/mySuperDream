//
//  PNGuaranteeListDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeListDTO.h"
#import "PNGuaranteeRspModel.h"
#import "PNRspModel.h"


@implementation PNGuaranteeListDTO

/// 订单列表接口
- (void)getGuarateenRecordList:(NSDictionary *)paramDic success:(void (^_Nullable)(PNGuaranteeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/secured-txn/app/order/list";

    request.requestParameter = paramDic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGuaranteeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
