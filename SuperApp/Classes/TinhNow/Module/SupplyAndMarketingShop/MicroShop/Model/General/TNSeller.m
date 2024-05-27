//
//  TNSeller.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSeller.h"


@implementation TNSeller

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"supplierId": @"id"};
}

/** @lazy isNeedShowPartTimeIncome */
- (BOOL)isNeedShowPartTimeIncome {
    BOOL show = NO;
    if (self.type == TNSellerIdentityTypePartTime) {
        show = YES;
    } else {
        if (self.everParttime == 1) {
            show = YES;
        }
    }
    return show;
}

- (BOOL)isSeller {
    return (HDIsStringNotEmpty(self.supplierId) && self.status);
}
@end
