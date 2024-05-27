//
//  WMSelectCouponsCell.h
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitCouponModel.h"
#import "WMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSelectCouponsCell : WMTableViewCell
@property (nonatomic, strong) WMOrderSubmitCouponModel *model;
@end

NS_ASSUME_NONNULL_END
