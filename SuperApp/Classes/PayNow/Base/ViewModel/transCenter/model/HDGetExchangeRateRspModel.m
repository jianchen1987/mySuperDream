//
//  HDGetExchangeRateRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/20.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDGetExchangeRateRspModel.h"
#import "PNUtilMacro.h"


@implementation HDGetExchangeRateRspModel

- (BOOL)parse {
    if ([super parse]) {
        if ([self.rspCd isEqualToString:RSP_SUCCESS_CODE]) {
            [self parseAllObject];
        }

        return YES;
    }
    return NO;
}

@end
