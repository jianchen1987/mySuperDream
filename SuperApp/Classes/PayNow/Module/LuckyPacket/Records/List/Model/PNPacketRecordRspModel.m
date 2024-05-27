//
//  PNPacketRecordRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordRspModel.h"


@implementation PNPacketRecordRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"records": @"records.records"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records": PNPacketRecordListItemModel.class,
    };
}
@end


@implementation PNPacketRecordListItemModel

@end
