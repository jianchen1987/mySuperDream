//
//  SABusinessCouponListViewController.h
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponListViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SABusinessBaseCouponListViewController : SACouponListViewController
/// 底部view
@property (nonatomic, strong, readonly) UIView *bottomView;
///< 获取更多优惠券按钮
@property (nonatomic, strong, readonly) UIButton *getMoreCouponBtn;
/// 底部阴影
@property (nonatomic, strong, readonly) UIView *bottomShadowView;

@property (nonatomic, strong, readonly) UIView *bottomButtonsContainView;

@end

NS_ASSUME_NONNULL_END
