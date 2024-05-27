//
//  HDTradeOrderStateRspModel.h
//  SuperApp
//
//  Created by VanJay on 2019/11/13.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDTradeOrderStateRspModel : SAModel
@property (nonatomic, assign) HDOrderStatus status; ///< 订单状态
@property (nonatomic, copy) NSString *tradeNo;      ///< 订单号
@end

NS_ASSUME_NONNULL_END
