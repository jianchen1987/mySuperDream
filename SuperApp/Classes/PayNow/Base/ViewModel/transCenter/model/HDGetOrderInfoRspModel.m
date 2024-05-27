//
//  HDGetOrderInfoRspModel.m
//  customer
//
//  Created by 帅呆 on 2018/11/30.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDGetOrderInfoRspModel.h"


@implementation HDGetOrderInfoRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }

    return NO;
}

@end
