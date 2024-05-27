//
//  SACouponListConfig.m
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponListChildViewControllerConfig.h"


@implementation SACouponListChildViewControllerConfig
//+ (instancetype)configWithTitle:(NSString *)title vc:(id<HDCategoryListContentViewDelegate>)vc businessLine:(SAClientType)businessLine {
//    SACouponListChildViewControllerConfig *config = SACouponListChildViewControllerConfig.new;
//    config.title = title;
//    config.vc = vc;
//    config.businessLine = businessLine;
//    return config;
//}

+ (instancetype)configWithTitle:(NSString *)title vc:(id<HDCategoryListContentViewDelegate>)vc couponType:(SACouponListCouponType)couponType {
    SACouponListChildViewControllerConfig *config = SACouponListChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    config.couponType = couponType;
    return config;
}

@end
