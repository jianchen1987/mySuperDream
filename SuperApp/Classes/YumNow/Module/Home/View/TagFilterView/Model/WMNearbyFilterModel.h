//
//  WMNearbyFilterModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMCategoryItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 搜索来源
typedef NSString *WMNearbyStoreSortType NS_STRING_ENUM;
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypeNone;                 ///< 默认 不排序
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypePopularity;           ///< 热门 001
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypeDeliveryFeeLowToHigh; ///< 配送费从低到高
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypeRatingHighToLow;      ///< 评分从高到低 003
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypeDistance;             ///< 距离 004
FOUNDATION_EXPORT WMNearbyStoreSortType const WMNearbyStoreSortTypeDeliveryTime;         ///< 配送时间
/// 门店标签
typedef NSString *WMNearbyStoreTag NS_STRING_ENUM;
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagFirstOrder;           ///< 首单立减  20
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagDiscount;             ///< 折扣优惠 11
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagOrderAmountFullBreak; ///< 满减优惠 18 21
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagDeliveryFeeBreak;     ///< 配送费减免 19
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagNewStore;             ///< 新店 99
FOUNDATION_EXPORT WMNearbyStoreTag const WMNearbyStoreTagSpecialOffer;         ///< 特价商品 22


@interface WMNearbyFilterModel : WMModel

/// 品类
@property (nonatomic, strong, nullable) WMCategoryItem *category;
/// 排序
@property (nonatomic, copy) WMNearbyStoreSortType sortType;
/// 标签
@property (nonatomic, strong) NSArray<NSString *> *tags;

@property (nonatomic, strong) NSArray<NSString *> *marketingTypes;

@property (nonatomic, strong) NSArray <NSString *>*storeFeature;

@end

NS_ASSUME_NONNULL_END
