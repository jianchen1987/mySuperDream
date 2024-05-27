//
//  WMStoreStatusModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreStatusModel.h"


@implementation WMStoreStatusModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"status": @"code"};
}
@end
