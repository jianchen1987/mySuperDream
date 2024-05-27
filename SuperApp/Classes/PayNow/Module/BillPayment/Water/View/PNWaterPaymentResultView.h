//
//  PNWaterPaymentResultView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNWaterBillModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNWaterPaymentResultView : PNView

@property (nonatomic, strong) PNWaterBillModel *paymentOrderModel;

- (void)stopQueryOnline;

@end

NS_ASSUME_NONNULL_END
