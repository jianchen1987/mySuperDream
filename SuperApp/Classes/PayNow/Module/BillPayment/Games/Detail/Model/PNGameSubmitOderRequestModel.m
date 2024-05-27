//
//  PNGameSubmitOderModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameSubmitOderRequestModel.h"
#import "SAUser.h"
#import "VipayUser.h"


@implementation PNGameSubmitOderRequestModel
- (NSNumber *)billingSource {
    return @(10);
}

- (NSString *)operatorNo {
    return SAUser.shared.operatorNo;
}
- (NSString *)billCode {
    if (HDIsStringNotEmpty(self.userId) && HDIsStringNotEmpty(self.zoneId)) {
        return [NSString stringWithFormat:@"%@:%@:%@", self.billerCode, self.userId, self.zoneId];
        ;
    } else {
        return self.billerCode;
    }
}
- (NSString *)customerCode {
    if (HDIsStringNotEmpty(self.userId) && HDIsStringNotEmpty(self.zoneId)) {
        return [NSString stringWithFormat:@"%@:%@:%@", self.billerCode, self.userId, self.zoneId];
        ;
    } else {
        return self.billerCode;
    }
}
- (NSString *)userNo {
    return [VipayUser shareInstance].userNo;
}
- (NSString *)returnUrl {
    return [NSString stringWithFormat:@"SuperApp://PayNow/paymentResult?businessLine=%@&orderNo=", SAClientTypeBillPayment];
    ;
}
@end
