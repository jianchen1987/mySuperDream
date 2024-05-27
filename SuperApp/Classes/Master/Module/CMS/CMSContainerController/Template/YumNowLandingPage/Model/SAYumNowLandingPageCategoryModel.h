//
//  SAYumNowLandingPageCategoryRspModel.h
//  SuperApp
//
//  Created by seeu on 2023/11/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAEnumModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, YumNowLandingPageCategoryStyle) {
    YumNowLandingPageCategoryStyleTextOnly = 1,
    YumNowLandingPageCategoryStyleIconOnly = 2,
    YumNowLandingPageCategoryStyleIconText = 3,
};

///落地页门店卡片展示类型
typedef NSString *YumNowLandingPageStoreCardStyle NS_STRING_ENUM;
FOUNDATION_EXPORT YumNowLandingPageStoreCardStyle const YumNowLandingPageStoreCardStyleSmall;      ///< 小图
FOUNDATION_EXPORT YumNowLandingPageStoreCardStyle const YumNowLandingPageStoreCardStyleBig;      ///< 大图


@class SAYumNowLandingPageCategoryModel;

@interface SAYumNowLandingPageCategoryRspModel : SACodingModel

///< 展示样式
@property (nonatomic, assign) YumNowLandingPageCategoryStyle showLabel;
///< 是否展示筛选
@property (nonatomic, assign) BOOL sortFilter;
///< 门店卡片展示样式
@property (nonatomic, copy) YumNowLandingPageStoreCardStyle storeLogoShowType;
///< titles
@property (nonatomic, strong) NSArray<SAYumNowLandingPageCategoryModel *> *titles;

@end


@interface SAYumNowLandingPageCategoryModel : SACodingModel

///< 展示样式
@property (nonatomic, assign) YumNowLandingPageCategoryStyle showLabel;
///< 图标
@property (nonatomic, copy) NSString *iconUrl;
///< 名称，可忽略
@property (nonatomic, copy) NSString *tabName;
///< 是否展示筛选
@property (nonatomic, assign) BOOL sortFilter;
///< 门店卡片展示样式
@property (nonatomic, copy) YumNowLandingPageStoreCardStyle storeLogoShowType;
///< tab名字
@property (nonatomic, strong) SAInternationalizationModel *name;
///< 查询参数
@property (nonatomic, copy) NSString *queryParam;


@end

NS_ASSUME_NONNULL_END
