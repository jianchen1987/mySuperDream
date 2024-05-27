//
//  PNPacketWOWNOWUserRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketWOWNOWUserRspModel.h"


@implementation PNPacketWOWNOWUserRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNPacketWOWNOWUserInfoModel.class,
    };
}

@end


@implementation PNPacketWOWNOWUserInfoModel

@end
