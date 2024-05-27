//
//  PNMarketingManager.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMarketingManager.h"
#import "PNMarketingDTO.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import <HDUIKit/NAT.h>
#import "PNRspModel.h"
#import "PNCheckMarketingRspModel.h"

static PNMarketingDTO *_marketingDTO = nil;


@implementation PNMarketingManager
+ (instancetype)sharedInstance {
    static PNMarketingManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

#pragma mark
+ (void)checkUser:(void (^)(PNCheckMarketingRspModel *rspModel))completion {
    if (!_marketingDTO) {
        _marketingDTO = PNMarketingDTO.new;
    }

    UIViewController *visableVc = SAWindowManager.visibleViewController;
    [visableVc.view showloading];

    [_marketingDTO isPromoterAndBind:^(PNCheckMarketingRspModel *_Nonnull rspModel) {
        [visableVc.view dismissLoading];
        !completion ?: completion(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [visableVc.view dismissLoading];
    }];
}

@end
