//
//  WMStoreGoodsRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/12/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsRspModel.h"


@implementation WMStoreGoodsRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"products": WMStoreGoodsItem.class,
    };
}
@end
