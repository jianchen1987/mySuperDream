//
//  SAQueryAvaliableChannelRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/12/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAQueryAvaliableChannelRspModel.h"


@implementation SAPaymentChannelModel

@end


@implementation SAQueryAvaliableChannelRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"payWays": SAPaymentChannelModel.class};
}

@end
