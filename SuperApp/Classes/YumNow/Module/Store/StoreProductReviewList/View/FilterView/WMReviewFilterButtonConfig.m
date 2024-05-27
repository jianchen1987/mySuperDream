//
//  WMReviewFilterButtonConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMReviewFilterButtonConfig.h"


@implementation WMReviewFilterButtonConfig
+ (instancetype)configWithTitle:(NSString *)title type:(WMReviewFilterType)type {
    WMReviewFilterButtonConfig *config = WMReviewFilterButtonConfig.new;
    config.title = title;
    config.type = type;
    return config;
}
@end
