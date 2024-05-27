//
//  HDReflushTokenRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/16.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDReflushTokenRspModel.h"


@implementation HDReflushTokenRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }
    return NO;
}

@end
