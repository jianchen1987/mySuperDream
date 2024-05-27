//
//  WMProductSearchRspModel.m
//  SuperApp
//
//  Created by Chaos on 2020/11/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductSearchRspModel.h"


@implementation WMProductSearchRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreGoodsItem.class,
    };
}

@end
