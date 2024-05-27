//
//  TNCommonAdvRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCommonAdvRspModel.h"


@implementation TNCommonAdvModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cardId": @"id"};
}
@end


@implementation TNCommonAdvRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"advList": [TNCommonAdvModel class]};
}

@end
