//
//  WMModifyFeeModel.m
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModifyFeeModel.h"


@implementation WMModifyFeeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"inTime": @[@"time"],
    };
}
@end
