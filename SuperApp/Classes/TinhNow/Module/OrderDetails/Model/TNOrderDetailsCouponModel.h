//
//  TNOrderDetailsCouponModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsCouponModel : TNModel

///
@property (nonatomic, copy) NSString *title;
/// 优惠券的优惠金额
@property (nonatomic, strong) SAMoneyModel *discount;
/// 优惠券code
@property (nonatomic, strong) NSString *code;

/// 优惠码的优惠金额
@property (nonatomic, strong) SAMoneyModel *promotionCodeDiscount;
/// 优惠码code
@property (nonatomic, strong) NSString *promotionCode;

@end

NS_ASSUME_NONNULL_END
