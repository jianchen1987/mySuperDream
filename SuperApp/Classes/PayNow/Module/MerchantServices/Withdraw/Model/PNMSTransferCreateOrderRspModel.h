//
//  PNMSTransferCreateOrderRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSTransferCreateOrderRspModel : PNModel
/// 交易单号
@property (nonatomic, copy) NSString *tradeNo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 凭证号
@property (nonatomic, copy) NSString *cashVoucherNo;
@end

NS_ASSUME_NONNULL_END
