//
//  SACouponListViewModel.h
//  SuperApp
//
//  Created by seeu on 2021/8/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SACouponListViewStyle) {
    SACouponListViewStyleSubView,    ///< 作为子视图出现，没有导航栏
    SACouponListViewStyleIndependent ///< 作为独立视图出现，有导航栏
};


@interface SACouponListViewModel : SAViewModel
@property (nonatomic, copy) SAClientType businessLine;          ///< 业务线
@property (nonatomic, assign) SACouponListNewSortType sortType; ///< 排序状态
@property (nonatomic, assign) SACouponState couponState;        ///< 优惠券状态
@property (nonatomic, assign) SACouponListViewStyle style;      ///< 样式
@property (nonatomic, copy) NSString *title;                    ///< 标题
@property (nonatomic, assign) BOOL showFilterBar;               ///< 是否显示筛选栏
////// 优惠券类型 9-全部 15-现金券 34-运费券 37-支付券
@property (nonatomic, assign) SACouponListCouponType couponType;
@end

NS_ASSUME_NONNULL_END
