
//
//  SAWalletBillListRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillListRspModel.h"


@implementation SAWalletBillListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAWalletBillModel.class,
    };
}
@end
