//
//  TNCheckWalletOpenedModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCheckWalletOpenedModel.h"


@implementation TNCheckWalletOpenedModel
- (void)setAccountLevel:(NSString *)accountLevel {
    _accountLevel = accountLevel;
    if (HDIsStringNotEmpty(accountLevel) && ![accountLevel isEqualToString:@"PRIMARY"]) {
        self.isVerifiedRealName = YES;
    }
}
@end
