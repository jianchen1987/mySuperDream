//
//  TNQueryProcessingOrderRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNQueryProcessingOrderRspModel.h"


@implementation TNQueryProcessingOrderRspModel
- (NSInteger)getTotalOrderNum {
    NSInteger total = 0;
    if (!HDIsObjectNil(self.reviewCount)) {
        total += [self.reviewCount integerValue];
    }
    if (!HDIsObjectNil(self.paymentCount)) {
        total += [self.paymentCount integerValue];
    }
    if (!HDIsObjectNil(self.shipmentCount)) {
        total += [self.shipmentCount integerValue];
    }
    if (!HDIsObjectNil(self.shippedCount)) {
        total += [self.shippedCount integerValue];
    }
    return total;
}
@end
