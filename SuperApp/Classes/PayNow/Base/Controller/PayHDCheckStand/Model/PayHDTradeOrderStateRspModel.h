//
//  PayHDTradeOrderStateRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/11/13.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayHDTradeOrderStateRspModel : SAModel
@property (nonatomic, assign) PNOrderStatus status; ///< 订单状态
@property (nonatomic, copy) NSString *tradeNo;      ///< 订单号
@end

NS_ASSUME_NONNULL_END
