//
//  SAYumNowLandingPageCategoryRspModel.m
//  SuperApp
//
//  Created by seeu on 2023/11/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAYumNowLandingPageCategoryModel.h"

YumNowLandingPageStoreCardStyle const YumNowLandingPageStoreCardStyleSmall = @"SLST001";      ///< 小图
YumNowLandingPageStoreCardStyle const YumNowLandingPageStoreCardStyleBig = @"SLST002";      ///< 大图

@implementation SAYumNowLandingPageCategoryModel

- (instancetype)init {
    if(self = [super init]) {
        self.storeLogoShowType = YumNowLandingPageStoreCardStyleSmall;
    }
    return self;
}

@end


@implementation SAYumNowLandingPageCategoryRspModel


@end
