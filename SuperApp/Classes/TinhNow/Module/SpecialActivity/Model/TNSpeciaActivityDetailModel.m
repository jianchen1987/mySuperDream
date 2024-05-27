//
//  TNSpeciaActivityDetailModel.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSpeciaActivityDetailModel.h"


@implementation TNSpeciaActivityAdModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"adId": @"id"};
}
@end


@implementation TNSpeciaActivityDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activityId": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productSpecialAdvs": [TNSpeciaActivityAdModel class],
    };
}
@end
