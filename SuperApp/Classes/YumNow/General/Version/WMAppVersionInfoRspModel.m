//
//  WMAppVersionInfoRspModel.m
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAppVersionInfoRspModel.h"


@implementation WMAppVersionInfoRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"descriptionStr": @[@"description"],
    };
}
@end
