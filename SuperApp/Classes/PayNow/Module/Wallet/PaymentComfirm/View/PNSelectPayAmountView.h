//
//  PNSelectPayAmountView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentComfirmRspModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNSelectPayAmountView : PNView
@property (nonatomic, strong) PNPaymentComfirmRspModel *model;
@end

NS_ASSUME_NONNULL_END
