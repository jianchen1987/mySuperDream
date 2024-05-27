//
//  TNCategoryChildControllerConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryChildControllerConfig.h"


@implementation TNCategoryChildControllerConfig
+ (instancetype)configWithModel:(TNHomeCategoryModel *)model {
    TNCategoryChildControllerConfig *config = [[TNCategoryChildControllerConfig alloc] init];
    config.model = model;
    return config;
}
@end
