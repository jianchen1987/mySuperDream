//
//  PNPacketOpenDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNPacketDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketOpenDTO : PNModel

/// 开红包
- (void)openPacket:(NSString *)packetId password:(NSString *)password success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 开红包详情接口
- (void)getOpenPacketDetail:(NSString *)packetId page:(NSInteger)page success:(void (^_Nullable)(PNPacketDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
