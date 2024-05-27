//
//  PNQueryWaterPaymentViewController.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "PNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNQueryWaterPaymentViewController : PNViewController
/// 缴费类别
@property (nonatomic, assign) PNPaymentCategory paymentCategroyType;
@end

NS_ASSUME_NONNULL_END
