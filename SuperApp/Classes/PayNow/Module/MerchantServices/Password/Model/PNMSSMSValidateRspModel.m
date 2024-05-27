//
//  PNMSSMSValidateRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSSMSValidateRspModel.h"


@implementation PNMSSMSValidateRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"token": @"accessToken"
    };
}

@end
