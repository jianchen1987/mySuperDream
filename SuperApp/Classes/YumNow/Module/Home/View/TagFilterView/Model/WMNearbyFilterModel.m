//
//  WMNearbyFilterModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNearbyFilterModel.h"
WMNearbyStoreSortType const WMNearbyStoreSortTypeNone = @"";
WMNearbyStoreSortType const WMNearbyStoreSortTypePopularity = @"MS_001";           ///< 热门
WMNearbyStoreSortType const WMNearbyStoreSortTypeDeliveryFeeLowToHigh = @"MS_002"; ///< 配送费从低到高
WMNearbyStoreSortType const WMNearbyStoreSortTypeRatingHighToLow = @"MS_003";      ///< 评分从高到低
WMNearbyStoreSortType const WMNearbyStoreSortTypeDistance = @"MS_004";             ///< 距离
WMNearbyStoreSortType const WMNearbyStoreSortTypeDeliveryTime = @"MS_005";         ///< 配送时间

WMNearbyStoreTag const WMNearbyStoreTagFirstOrder = @"20";              ///< 首单立减  20
WMNearbyStoreTag const WMNearbyStoreTagDiscount = @"11";                ///< 折扣优惠 11
WMNearbyStoreTag const WMNearbyStoreTagOrderAmountFullBreak = @"18,21"; ///< 满减优惠 18 21
WMNearbyStoreTag const WMNearbyStoreTagDeliveryFeeBreak = @"19";        ///< 配送费减免 19
WMNearbyStoreTag const WMNearbyStoreTagNewStore = @"99";                ///< 新店 99
WMNearbyStoreTag const WMNearbyStoreTagSpecialOffer = @"23";            ///< 特价商品 23


@implementation WMNearbyFilterModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sortType = WMNearbyStoreSortTypeNone;
        self.tags = @[];
    }
    return self;
}

@end
