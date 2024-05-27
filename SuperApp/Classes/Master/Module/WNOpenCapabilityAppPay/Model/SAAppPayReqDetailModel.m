//
//  SAAppPayReqDetailModel.m
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAppPayReqDetailModel.h"
#import "SAMoneyModel.h"


@implementation SAAppPayReqDetailModel

- (NSString *)payAmountShowStr {
    if (HDIsStringNotEmpty(self.payAmount) && HDIsStringNotEmpty(self.currency)) {
        return [SAMoneyModel modelWithAmount:self.payAmount currency:self.currency].thousandSeparatorAmount;
    }

    return nil;
}

@end
