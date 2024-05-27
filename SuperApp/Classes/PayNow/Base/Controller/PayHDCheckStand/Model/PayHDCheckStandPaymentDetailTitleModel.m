//
//  PayHDCheckstandPaymentDetailTitleModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/10.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandPaymentDetailTitleModel.h"
#import "HDAppTheme.h"


@implementation PayHDCheckstandPaymentDetailTitleModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.sideFontSize = 30;
        self.middleFontSize = 17;
        self.sideColor = [HDAppTheme.color G1];
        self.middleColor = [HDAppTheme.color G1];
    }
    return self;
}
@end
