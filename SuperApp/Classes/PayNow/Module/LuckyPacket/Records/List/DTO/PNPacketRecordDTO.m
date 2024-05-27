//
//  PNPacketRecordDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordDTO.h"
#import "PNPacketDetailModel.h"
#import "PNPacketRecordRspModel.h"
#import "PNRspModel.h"


@implementation PNPacketRecordDTO

/// 红包记录列表
- (void)getPacketRecordList:(NSDictionary *)param success:(void (^_Nullable)(PNPacketRecordRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/records/app/getLuckyPacketList";
    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNPacketRecordRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 红包领取详情接口
- (void)getPacketDetail:(NSString *)packetId page:(NSInteger)page success:(void (^_Nullable)(PNPacketDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/records/app/getLuckyPacketDetail";

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setValue:packetId forKey:@"packetId"];
    [dict setValue:@(page) forKey:@"pageNum"];
    [dict setValue:@(20) forKey:@"pageSize"];

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNPacketDetailModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
