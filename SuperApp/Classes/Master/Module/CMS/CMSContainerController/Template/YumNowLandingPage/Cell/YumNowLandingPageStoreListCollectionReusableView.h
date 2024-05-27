//
//  YumNowLandingPageStoreListCollectionReusableView.h
//  SuperApp
//
//  Created by VanJay on 2023/12/4.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAYumNowLandingPageCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class YumNowLandingPageStoreListCollectionReusableViewModel;
@class SAAddressModel;
@class WMNearbyFilterModel;

@interface YumNowLandingPageStoreListCollectionReusableView : UICollectionReusableView
///< model
@property (nonatomic, strong) YumNowLandingPageStoreListCollectionReusableViewModel *model;

/// 筛选框出来了
@property(nonatomic, copy) void (^filterViewWillAppear)(UICollectionReusableView *_Nullable view);
/// 筛选框消失嘞
@property(nonatomic, copy) void (^filterViewWillDisAppear)(UICollectionReusableView *_Nullable view, WMNearbyFilterModel *_Nonnull filterModel);
/// 分类点击
@property(nonatomic, copy) void (^categoryTitleClicked)(UICollectionReusableView *_Nullable view, NSInteger index, WMNearbyFilterModel *_Nonnull filterModel);

- (void)reset;

@end


@interface YumNowLandingPageStoreListCollectionReusableViewModel : NSObject

///< 分类颜色
@property (nonatomic, copy) NSString *categoryColor;
///< 分类默认颜色
@property (nonatomic, copy) NSString *categoryDefaultColor;
///< 下划线颜色
@property (nonatomic, copy) NSString *categoryBottomLineColor;
///< 字体大象
@property (nonatomic, assign) NSUInteger categoryFont;
///< 展示样式
@property (nonatomic, assign) YumNowLandingPageCategoryStyle showLabel;
///< 是否展示筛选
@property (nonatomic, assign) BOOL sortFilter;
///< 整个view的高度
@property (nonatomic, assign) CGFloat viewHeight;
///< 门店卡片展示样式
@property (nonatomic, copy) YumNowLandingPageStoreCardStyle storeLogoShowType;
///< 数据
@property (nonatomic, strong) NSArray<SAYumNowLandingPageCategoryModel *> *categoryModels;

@end

NS_ASSUME_NONNULL_END
