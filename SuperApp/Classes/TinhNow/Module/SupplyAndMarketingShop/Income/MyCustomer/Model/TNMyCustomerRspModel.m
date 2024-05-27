//
//  TNMyCustomerRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerRspModel.h"


@implementation TNMyCustomerRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNMyCustomerModel class]};
}

@end


@implementation TNMyCustomerModel

@end
