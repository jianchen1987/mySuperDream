//
//  PayHDCheckstandChooseCouponTicketViewController.h
//  ViPay
//
//  Created by VanJay on 2019/6/13.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckstandBaseViewController.h"
@class PayHDTradePreferentialModel;

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandChooseCouponTicketViewController : PayHDCheckstandBaseViewController
- (void)configureWithCouponList:(NSArray<PayHDTradePreferentialModel *> *)couponList isSelectedDontUseCoupon:(BOOL)isSelectedDontUseCoupon;

@property (nonatomic, copy) void (^choosedCouponModelHandler)(PayHDTradePreferentialModel *model); ///< 选择了优惠
@end

NS_ASSUME_NONNULL_END
