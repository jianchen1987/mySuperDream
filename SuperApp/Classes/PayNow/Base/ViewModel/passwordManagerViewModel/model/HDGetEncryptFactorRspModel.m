//
//  HDGetEncryptFactorRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDGetEncryptFactorRspModel.h"


@implementation HDGetEncryptFactorRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }

    return NO;
}

@end
