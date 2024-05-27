//
//  PNPacketMessageListRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketMessageListRspModel.h"


@implementation PNPacketMessageListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNPacketMessageListItemModel.class,
    };
}
@end
