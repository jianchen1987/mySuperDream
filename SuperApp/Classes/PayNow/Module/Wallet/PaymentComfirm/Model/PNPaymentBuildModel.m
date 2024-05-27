//
//  PNPaymentBuildModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentBuildModel.h"


@implementation PNPaymentBuildModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fromType = PNPaymentBuildFromType_Default;
        self.isShowUnifyPayResult = YES;
    }
    return self;
}
@end


@implementation PNPaymentBuildWithdrawExtendModel

@end
