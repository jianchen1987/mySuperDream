//
//  TNSellerSearchConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchConfig.h"


@implementation TNSellerSearchConfig
+ (instancetype)configWithTitle:(NSString *)title resultType:(TNSellerSearchResultType)resultType {
    TNSellerSearchConfig *config = [[TNSellerSearchConfig alloc] init];
    config.title = title;
    config.type = resultType;
    config.isNeedRefresh = YES;
    return config;
}
@end
