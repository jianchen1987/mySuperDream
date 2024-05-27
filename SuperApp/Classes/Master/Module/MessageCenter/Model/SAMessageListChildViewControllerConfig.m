//
//  SAMessageListChildViewControllerConfig.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageListChildViewControllerConfig.h"
#import "SAMessageCenterListViewController.h"


@implementation SAMessageListChildViewControllerConfig
+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(id<HDCategoryListContentViewDelegate>)vc {
    SAMessageListChildViewControllerConfig *config = SAMessageListChildViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}
@end
