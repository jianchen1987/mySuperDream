//
//  TNIncomeListFilterModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNIncomeListFilterModel.h"


@implementation TNIncomeListFilterModel
- (BOOL)isCleanFilter {
    if (HDIsStringEmpty(self.dateRangeStart) && HDIsStringEmpty(self.dateRangeEnd) && !self.showAll && self.dailyInterval == nil) {
        return YES;
    } else {
        return NO;
    }
}
@end


@implementation TNIncomeCommissionSumModel

@end
