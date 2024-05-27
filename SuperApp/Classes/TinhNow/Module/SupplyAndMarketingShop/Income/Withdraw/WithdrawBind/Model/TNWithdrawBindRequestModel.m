//
//  TNWithdrawBindRequestModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawBindRequestModel.h"


@implementation TNWithdrawBindRequestModel
- (NSString *)operatorNo {
    return [SAUser shared].operatorNo;
}
- (void)setCompanyName:(NSString *)companyName {
    _companyName = companyName;
    if (HDIsStringNotEmpty(companyName)) {
        self.paymentType = companyName; //替换
    }
}
@end
