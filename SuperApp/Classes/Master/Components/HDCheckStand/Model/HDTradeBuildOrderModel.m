//
//  HDTradeBuildOrderModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDTradeBuildOrderModel.h"


@implementation HDTradeBuildOrderModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.supportedPaymentMethods = @[HDSupportedPaymentMethodOnline];
    }
    return self;
}

@end
