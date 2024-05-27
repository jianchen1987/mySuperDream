//
//  HDOrderConfirmRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/8.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDOrderConfirmRspModel.h"


@implementation HDOrderConfirmRspModel
- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }

    return NO;
}
@end
