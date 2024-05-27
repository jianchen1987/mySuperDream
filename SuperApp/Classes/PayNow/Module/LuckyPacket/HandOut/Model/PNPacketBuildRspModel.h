//
//  PNPacketBuildRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketBuildRspModel : PNModel
/// 红包ID
@property (nonatomic, copy) NSString *packetId;

/// 外部订单号号
@property (nonatomic, copy) NSString *packetSn;

/// 交易单号
@property (nonatomic, copy) NSString *tradeNo;

@end

NS_ASSUME_NONNULL_END
