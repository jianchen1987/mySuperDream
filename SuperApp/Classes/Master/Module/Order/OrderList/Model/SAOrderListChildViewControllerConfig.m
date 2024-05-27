//
//  SAOrderListChildViewControllerConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderListChildViewControllerConfig.h"


@implementation SAOrderListChildViewControllerConfig
+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAOrderListViewController *)vc {
    SAOrderListChildViewControllerConfig *config = SAOrderListChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}
@end


@implementation SAOrderCenterListChildViewControllerConfig

+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAOrderCenterListViewController *)vc {
    SAOrderCenterListChildViewControllerConfig *config = SAOrderCenterListChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}

@end
