//
//  SAAggregateSearchViewControllerConfig.m
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchViewControllerConfig.h"


@implementation SAAggregateSearchViewControllerConfig
+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAAggregateSearchResultViewController *)vc {
    SAAggregateSearchViewControllerConfig *config = SAAggregateSearchViewControllerConfig.new;
    config.title = title;
    config.vc = vc;
    return config;
}
@end
