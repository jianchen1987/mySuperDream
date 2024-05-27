//
//  SAAddressAutoCompleteItem.m
//  SuperApp
//
//  Created by seeu on 2021/3/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddressAutoCompleteItem.h"


@implementation SAAddressAutoCompleteItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name": @"description", @"placeId": @"place_id"};
}
@end
