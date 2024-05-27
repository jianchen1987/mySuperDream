//
//  PNPacketMessageDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketMessageDTO.h"
#import "PNPacketMessageListRspModel.h"
#import "PNRspModel.h"


@implementation PNPacketMessageDTO

/// 订单消息
- (void)packetMessageList:(NSDictionary *)param success:(void (^_Nullable)(PNPacketMessageListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/app/order/message/list";
    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNPacketMessageListRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 未领取统计
- (void)getPacketMessageCount:(void (^_Nullable)(NSInteger count))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/app/order/message/total";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSDictionary *dict = rspModel.data;
        NSInteger totalUnclaimed = [[dict objectForKey:@"totalUnclaimed"] integerValue];
        !successBlock ?: successBlock(totalUnclaimed);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
