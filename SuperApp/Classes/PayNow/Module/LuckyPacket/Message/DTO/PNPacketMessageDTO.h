//
//  PNPacketMessageDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNPacketMessageListRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketMessageDTO : PNModel

/// 订单消息
- (void)packetMessageList:(NSDictionary *)param success:(void (^_Nullable)(PNPacketMessageListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 未领取统计
- (void)getPacketMessageCount:(void (^_Nullable)(NSInteger count))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
