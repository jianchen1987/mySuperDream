//
//  PayHDRechargeableCardModel.m
//  customer
//
//  Created by 谢 on 2019/1/22.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDRechargeableCardModel.h"


@implementation PayHDRechargeableCardModel
- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        self.mark = @"+";
        self.amt = [NSNumber numberWithInteger:self.amount.integerValue];
        self.tradeType = PNTransTypeRecharge; // PNTransTypeRecharge
        self.cy = [self.data valueForKey:@"currency"];
        self.status = @"12"; // PNOrderStatusSuccess
        return YES;
    }
    return NO;
}
@end
