//
//  PNGuaranteeRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeRspModel.h"


@implementation PNGuaranteeRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNGuaranteeListItemModel.class,
    };
}
@end


@implementation PNGuaranteeListItemModel

@end
