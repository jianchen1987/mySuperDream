//
//  WMOneClickCouponTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCouponDetailModel.h"
#import "WMStoreCouponDetailModel.h"
#import "WMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOneClickCouponTableViewCell : WMTableViewCell

@property (nonatomic, strong) WMStoreCouponDetailModel *model;

@end

NS_ASSUME_NONNULL_END
