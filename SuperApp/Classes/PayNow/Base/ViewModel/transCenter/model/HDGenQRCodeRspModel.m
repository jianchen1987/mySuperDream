//
//  HDGenQRCodeRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/7.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDGenQRCodeRspModel.h"


@implementation HDGenQRCodeRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }

    return NO;
}

@end
