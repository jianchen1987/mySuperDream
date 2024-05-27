//
//  SAAppStartUpConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/4/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAppStartUpConfig.h"
#import "SATabBarItemConfig.h"
#import "SAKingKongAreaItemConfig.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "SAStartupAdModel.h"


@implementation SAAppStartUpConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"tabbars": SAAppStartUpTabbarConfig.class,
        @"kingkongArea": SAAppStartUpKingkongAreaConfig.class,
        @"paymentTools": SAAppStartUpPaymentToolConfig.class,
        @"advertising": SAStartupAdModel.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"kingkongArea": @"kingkongAre"};
}

@end


@implementation SAAppStartUpTabbarConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SATabBarItemConfig.class,
    };
}

@end


@implementation SAAppStartUpKingkongAreaConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAKingKongAreaItemConfig.class,
    };
}

@end


@implementation SAAppStartUpPaymentToolConfig

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list": @"payWays"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAPaymentChannelModel.class,
    };
}

@end
