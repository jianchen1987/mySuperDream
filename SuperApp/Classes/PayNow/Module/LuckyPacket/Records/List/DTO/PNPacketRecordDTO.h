//
//  PNPacketRecordDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNPacketRecordRspModel;
@class PNPacketDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordDTO : PNModel

/// 红包记录列表
- (void)getPacketRecordList:(NSDictionary *)param success:(void (^_Nullable)(PNPacketRecordRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 红包领取详情接口
- (void)getPacketDetail:(NSString *)packetId page:(NSInteger)page success:(void (^_Nullable)(PNPacketDetailModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
