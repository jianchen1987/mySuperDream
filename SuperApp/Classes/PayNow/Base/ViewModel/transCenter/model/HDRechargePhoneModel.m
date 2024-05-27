//
//  HDRechargePhoneModel.m
//  customer
//
//  Created by 谢 on 2019/1/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDRechargePhoneModel.h"


@implementation HDRechargePhoneModel
- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }

    return NO;
}

@end
