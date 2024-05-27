//
//  TNQueryGoodsCategoryRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNQueryGoodsCategoryRspModel.h"
#import "TNCategoryModel.h"


@implementation TNQueryGoodsCategoryRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNCategoryModel class]};
}
@end
