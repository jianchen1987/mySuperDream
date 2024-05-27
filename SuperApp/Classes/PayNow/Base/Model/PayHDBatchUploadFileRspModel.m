//
//  PayHDBatchUploadFileRspModel.m
//  ViPay
//
//  Created by VanJay on 2020/2/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "PayHDBatchUploadFileRspModel.h"


@implementation HDBatchUploadFileSingleRspModel

@end


@implementation PayHDBatchUploadFileRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"uploadResultDTOList": HDBatchUploadFileSingleRspModel.class,
    };
}
@end
