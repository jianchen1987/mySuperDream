//
//  PNInterTransferFeeRateAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
@class PNInterTransferRateFeeModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferFeeRateAlertView : HDActionAlertView
- (instancetype)initWithFeeModel:(PNInterTransferRateFeeModel *)feeModel;
@end

NS_ASSUME_NONNULL_END
