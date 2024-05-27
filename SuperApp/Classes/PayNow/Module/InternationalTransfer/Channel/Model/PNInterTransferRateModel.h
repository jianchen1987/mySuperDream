//
//  PNInterTransferRateModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferSubRateModel : PNModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *currency;
@end


@interface PNInterTransferRateModel : PNModel
/// 兑换前的金额
@property (nonatomic, strong) PNInterTransferSubRateModel *sourceAmt;

/// 兑换之后的金额
@property (nonatomic, strong) PNInterTransferSubRateModel *targetAmt;
@end

NS_ASSUME_NONNULL_END
