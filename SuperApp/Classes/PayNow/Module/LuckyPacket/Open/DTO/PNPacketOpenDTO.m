//
//  PNPacketOpenDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketOpenDTO.h"
#import "PNPacketDetailModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNPacketOpenDTO
/// 开红包
- (void)openPacket:(NSString *)packetId password:(NSString *)password success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/records/app/checkOutPacket";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.retryCount = 0;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setValue:packetId forKey:@"packetId"];
    if (HDIsStringNotEmpty(password)) {
        [dict setValue:password forKey:@"packetKey"];
    }

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 开红包详情接口
- (void)getOpenPacketDetail:(NSString *)packetId page:(NSInteger)page success:(void (^_Nullable)(PNPacketDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNCAMNetworRequest *request = PNCAMNetworRequest.new;
    request.requestURI = @"/lucky-packet/records/app/getLuckyDetail";

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
