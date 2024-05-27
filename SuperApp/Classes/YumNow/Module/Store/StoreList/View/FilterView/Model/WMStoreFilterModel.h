//
//  WMStoreFilterModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreFilterModel : WMModel
///搜索类型
@property (nonatomic, strong) WMSearchType type;
@property (nonatomic, copy) NSString *_Nullable keyword;       ///< 查询关键字
@property (nonatomic, copy) NSString *_Nullable businessScope; ///< 经营品类code
@property (nonatomic, copy) NSString *_Nullable sortType;      ///< 分类，MS_001: Popularity, MS_002: Delivery fee: Low to High, MS_003: Rating: High to Low, MS_004: Distance, MS_005: Delivery time
/// 是否只查看配送范围内的，true 、 false
@property (nonatomic, copy) SABoolValue inRange;

@property (nonatomic, strong) NSArray<NSString *> *marketingTypes;

@property (nonatomic, strong) NSArray <NSString *>*storeFeature;

@end

NS_ASSUME_NONNULL_END
