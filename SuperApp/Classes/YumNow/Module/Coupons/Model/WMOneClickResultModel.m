//
//  WMOneClickResultModel.m
//  SuperApp
//
//  Created by wmz on 2022/7/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOneClickResultModel.h"


@implementation WMOneClickResultModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"resultCode": @"code",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponResult": WMOneClickItemResultModel.class,
    };
}
@end


@implementation WMOneClickItemResultModel

@end
