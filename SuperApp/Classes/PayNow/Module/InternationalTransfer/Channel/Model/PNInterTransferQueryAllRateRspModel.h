//
//  PNInterTransferQueryAllRateRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRateModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferQueryAllRateRspModel : PNModel
@property (nonatomic, strong) PNInterTransferRateModel *alipayRateInfo;
@property (nonatomic, strong) PNInterTransferRateModel *wechatRateInfo;
@end

NS_ASSUME_NONNULL_END
