//
//  WMGotCouponsView.h
//  SuperApp
//
//  Created by wmz on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMCouponActivityModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMGotCouponsView : SAView <HDCustomViewActionViewProtocol>
/// 优惠活动
@property (nonatomic, strong) WMCouponActivityModel *rspModel;
/// 门店id
@property (nonatomic, copy) NSString *storeNo;
/// 查看
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMStoreCouponDetailModel *rspModel);
/// 隐藏
@property (nonatomic, copy) void (^hideBlock)(BOOL hide);
@end

NS_ASSUME_NONNULL_END
