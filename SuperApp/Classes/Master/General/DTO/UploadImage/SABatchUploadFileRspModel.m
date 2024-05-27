//
//  SABatchUploadFileRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SABatchUploadFileRspModel.h"


@implementation SABatchUploadFileSingleRspModel

@end


@implementation SABatchUploadFileRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"uploadResultDTOList": SABatchUploadFileSingleRspModel.class,
    };
}
@end
