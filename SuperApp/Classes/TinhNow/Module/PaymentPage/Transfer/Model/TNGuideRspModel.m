//
//  TNGuideRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNGuideRspModel.h"


@implementation TNGuideItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"advId": @"id"};
}
@end


@implementation TNGuideRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"advList": [TNGuideItemModel class]};
}
@end
