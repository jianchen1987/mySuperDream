//
//  TNWholesalePriceAndBatchNumberModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNWholesalePriceAndBatchNumberModel.h"


@implementation TNWholesalePriceAndBatchNumberModel
- (BOOL)checkInsideRangeNumber:(NSInteger)count {
    BOOL bingo = NO;
    if (self.endNumber < 0) {
        if (count >= self.startNumber) {
            bingo = YES;
        }
    } else {
        if (count >= self.startNumber && count <= self.endNumber) {
            bingo = YES;
        }
    }

    return bingo;
}
@end
