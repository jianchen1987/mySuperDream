//
//  WMCategoryChildViewControllerConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCategoryChildViewControllerConfig.h"


@implementation WMCategoryChildViewControllerConfig
+ (instancetype)configWithTitle:(NSString *)title vc:(UIViewController<HDCategoryListContentViewDelegate> *)vc {
    WMCategoryChildViewControllerConfig *config = WMCategoryChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}
@end
