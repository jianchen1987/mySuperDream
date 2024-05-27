//
//  TNOrderListCategoryConfig.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListCategoryConfig.h"


@implementation TNOrderListCategoryConfig
+ (instancetype)configWithTitle:(NSString *)title state:(TNOrderState)state num:(NSNumber *)num {
    TNOrderListCategoryConfig *config = [[TNOrderListCategoryConfig alloc] init];
    config.title = title;
    config.state = state;
    config.orderNum = num;
    return config;
}
@end
