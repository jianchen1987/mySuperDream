//
//  WMStoreListItemModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreListItemModel.h"


@implementation WMStoreListItemModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfLinesOfNameLabel = 0;
        self.numberOfLinesOfPromotion = 1;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"commentsCount": @"reviewCount",
        @"ratingScore": @"reviewScore",
        @"isNewStore": @[@"new", @"isNew"],
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"businessScopes": SAInternationalizationModel.class,
        @"products": WMStoreProductModel.class,
        @"signatures": WMSpecialStoreSignaturesModel.class,
        @"promotions": WMStoreDetailPromotionModel.class,
    };
}
@end

@implementation WMStoreListNewItemModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfLinesOfNameLabel = 0;
        self.numberOfLinesOfPromotion = 1;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"commentsCount": @"reviewCount",
        @"ratingScore": @"reviewScore",
        @"isNewStore": @[@"new", @"isNew"],
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"businessScopes": SAInternationalizationModel.class,
        @"products": WMStoreProductModel.class,
        @"signatures": WMSpecialStoreSignaturesModel.class,
    };
}
@end
