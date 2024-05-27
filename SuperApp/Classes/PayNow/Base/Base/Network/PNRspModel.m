//
//  PNRspModel.m
//  SuperApp
//
//  Created by seeu on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNRspModel.h"
#import <HDKitCore/HDCommonDefines.h>

PNResponseType const PNResponseTypeSuccess = @"00000";


@implementation PNRspInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code": @"rspCode", @"msg": @"rspInf"};
}
@end


@implementation PNRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code": @"rspCd", @"msg": @"rspInf", @"time": @"responseTm", @"version": @"v"};
}

@end
