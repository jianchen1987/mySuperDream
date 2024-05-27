//
//  SAWindowModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWindowModel.h"
#import "SAInternationalizationModel.h"
#import "SAWindowItemModel.h"


@implementation SAWindowModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"bannerList": SAWindowItemModel.class,
    };
}

- (SAWindowModelType)type {
    if (self.location == SAWindowLocationWowNowKingKong) {
        return SAWindowModelTypeKingKong;
    } else if (self.location == SAWindowLocationWowNowBanner) {
        return SAWindowModelTypeBanner;
    } else if (self.location == SAWindowLocationWowNowTool) {
        return SAWindowModelTypeTool;
    } else if (self.location == SAWindowLocationWowNowWsNew) {
        return SAWindowModelTypeWsNew;
    }
    return SAWindowModelTypeUnKnow;
}

@end
