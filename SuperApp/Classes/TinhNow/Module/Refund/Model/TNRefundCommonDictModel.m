//
//  TNRefundCommonDictModel.m
//  SuperApp
//
//  Created by xixi on 2021/1/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundCommonDictModel.h"


@implementation TNRefundCommonDictModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id": @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"REFUND_REASON": [TNRefundCommonDictItemModel class],
        @"APPLY_REASON": [TNRefundCommonDictItemModel class],
        @"REFUND_TYPE": [TNRefundCommonDictItemModel class],
    };
}
@end


@implementation TNRefundCommonDictItemModel

@end
