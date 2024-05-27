//
//  SAWalletBillModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillModel.h"


@implementation SAWalletBillModelDetail

@end


@implementation SAWalletBillModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"details": SAWalletBillModelDetail.class,
    };
}
@end
