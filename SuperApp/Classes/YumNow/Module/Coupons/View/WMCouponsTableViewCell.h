//
//  WMCouponsTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMStoreCouponDetailModel.h"
#import "WMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCouponsTableViewCell : WMTableViewCell
@property (nonatomic, strong) WMStoreCouponDetailModel *model;
@property (nonatomic, strong) GNCellModel *rspModel;
@end


@interface WMCouponsTitleTableViewCell : WMTableViewCell
@property (nonatomic, strong) GNCellModel *model;
@end

NS_ASSUME_NONNULL_END
