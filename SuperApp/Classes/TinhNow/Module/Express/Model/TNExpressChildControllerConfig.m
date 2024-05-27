//
//  TNExpressChildControllerConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressChildControllerConfig.h"


@implementation TNExpressChildControllerConfig
+ (instancetype)configWithTitle:(NSString *)title model:(TNExpressDetailsModel *)model {
    TNExpressChildControllerConfig *config = [[TNExpressChildControllerConfig alloc] init];
    config.title = title;
    config.model = model;
    return config;
}
@end
