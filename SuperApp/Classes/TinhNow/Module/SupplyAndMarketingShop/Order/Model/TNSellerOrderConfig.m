//
//  TNSellerOrderConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderConfig.h"


@implementation TNSellerOrderConfig
+ (instancetype)configWithTitle:(NSString *)title status:(TNSellerOrderStatus)status {
    TNSellerOrderConfig *config = [[TNSellerOrderConfig alloc] init];
    config.title = title;
    config.status = status;
    return config;
}
@end
