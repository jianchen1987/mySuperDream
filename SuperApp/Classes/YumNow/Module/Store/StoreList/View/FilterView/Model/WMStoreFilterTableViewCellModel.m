//
//  WMStoreFilterTableViewCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterTableViewCellModel.h"


@implementation WMStoreFilterTableViewCellModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"subArrList": WMStoreFilterTableViewCellBaseModel.class,
    };
}
@end
