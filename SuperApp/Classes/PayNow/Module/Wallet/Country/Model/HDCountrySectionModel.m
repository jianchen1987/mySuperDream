//
//  HDCountrySectionModel.m
//  ViPay
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCountrySectionModel.h"


@implementation HDCountrySectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"data": CountryModel.class,
    };
}
@end
