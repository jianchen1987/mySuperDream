//
//  SAAddressAutoCompleteRspModel.m
//  SuperApp
//
//  Created by seeu on 2021/3/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddressAutoCompleteRspModel.h"


@implementation SAAddressAutoCompleteRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"results": @"predictions"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"results": SAAddressAutoCompleteItem.class,
    };
}
@end
