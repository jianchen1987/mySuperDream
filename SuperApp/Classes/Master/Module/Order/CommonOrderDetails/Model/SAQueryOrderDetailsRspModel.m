//
//  SAQueryOrderDetailsRspModel.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAQueryOrderDetailsRspModel.h"


@implementation SAQueryOrderDetailsRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"operationList": NSString.class};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeNo": @[@"storeId", @"storeNo"]};
}

@end
