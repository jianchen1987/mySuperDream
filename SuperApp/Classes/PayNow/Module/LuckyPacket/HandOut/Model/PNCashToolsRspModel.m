//
//  PNCashToolsRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCashToolsRspModel.h"


@implementation PNCashToolsRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"methodPayment": PNCashToolsMethodPaymentItemModel.class,
    };
}

@end


@implementation PNCashToolsMethodPaymentItemModel

@end
