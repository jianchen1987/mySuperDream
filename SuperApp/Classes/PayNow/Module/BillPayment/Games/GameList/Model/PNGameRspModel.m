//
//  PNGameRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameRspModel.h"


@implementation PNGameTitleInfoModel

@end


@implementation PNGameCategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"gameId": @"id", @"des": @"description"};
}
@end


@implementation PNGameRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories": [PNGameCategoryModel class]};
}
@end
