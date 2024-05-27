//
//  WMOrderSubmitCalDeliveryFeeRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitCalDeliveryFeeRspModel.h"


@implementation WMOrderSubmitCalDeliveryFeeRspModel
- (void)setInRange:(SABoolValue)inRange {
    if ([@[@"1", @"true", @"yes"] containsObject:inRange.lowercaseString]) {
        _inRange = SABoolValueTrue;
    } else {
        _inRange = SABoolValueFalse;
    }
}
@end
