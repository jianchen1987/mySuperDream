//
//  PNPacketDetailModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketDetailModel.h"


@implementation PNPacketDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"records": @"listRespDTOPageRespDTO.records"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records": PNPacketDetailListItemModel.class,
    };
}
@end


@implementation PNPacketDetailListItemModel

@end
