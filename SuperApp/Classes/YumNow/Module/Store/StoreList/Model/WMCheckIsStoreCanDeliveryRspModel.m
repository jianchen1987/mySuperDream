//
//  WMCheckIsStoreCanDeliveryRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCheckIsStoreCanDeliveryRspModel.h"


@implementation WMCheckIsStoreCanDeliveryRspModel
- (void)setCanDelivery:(SABoolValue)canDelivery {
    if ([@[@"1", @"true", @"yes", @"10"] containsObject:canDelivery.lowercaseString]) {
        _canDelivery = SABoolValueTrue;
    } else {
        _canDelivery = SABoolValueFalse;
    }
}
@end
