//
//  TNQueryUserShoppingCarRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNQueryUserShoppingCarRspModel.h"
#import "TNShoppingCarStoreModel.h"


@implementation TNQueryUserShoppingCarRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeShoppingCars": @"merchantCartDTOS"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"storeShoppingCars": [TNShoppingCarStoreModel class]};
}

@end
