//
//  SACouponListConfig.h
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import <HDUIKit/HDCategoryView.h>

NS_ASSUME_NONNULL_BEGIN


@interface SACouponListChildViewControllerConfig : SACodingModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 控制器
@property (nonatomic, strong) id<HDCategoryListContentViewDelegate> vc;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 优惠券类型 9-全部 15-现金券 34-运费券 37-支付券
@property (nonatomic, assign) SACouponListCouponType couponType;

+ (instancetype)configWithTitle:(NSString *)title vc:(id<HDCategoryListContentViewDelegate>)vc couponType:(SACouponListCouponType)couponType;

@end

NS_ASSUME_NONNULL_END
