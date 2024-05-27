//
//  PNPacketMessageListItemModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketMessageListItemModel.h"


@implementation PNPacketMessageListItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"messageStatus": @"messageStatus.code",
        @"packetType": @"packetType.code",
    };
}

@end
