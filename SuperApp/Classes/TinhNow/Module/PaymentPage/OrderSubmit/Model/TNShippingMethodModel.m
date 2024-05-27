//
//  TNShippingMethodModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShippingMethodModel.h"


@implementation TNShippingMethodModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description", @"name": @"nameLocales"};
}
@end
