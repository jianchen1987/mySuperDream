//
//  PayHDCouponModel.h
//  customer
//
//  Created by null on 2019/3/8.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCouponModel : SAModel

@property (nonatomic, copy) NSString *cy;
@property (nonatomic, strong) NSNumber *amt;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *typeDesc;      ///< 优惠描述
@property (nonatomic, copy) NSString *incomeFlag;    ///< 收益符号
@property (nonatomic, assign) NSInteger merchantAmt; ///< 商户优惠金额

@end

NS_ASSUME_NONNULL_END
