//
//  PNMSCategoryRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCategoryRspModel.h"


@implementation PNMSCategoryRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [PNMSCategoryModel class]};
}

@end


@implementation PNMSCategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sub": [PNMSCategoryModel class]};
}

@end
