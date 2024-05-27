//
//  YumNowStoreListFilterHeaderView.h
//  SuperApp
//
//  Created by seeu on 2023/12/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class YumNowStoreListFilterHeaderViewModel;
@class WMNearbyFilterModel;

typedef NS_ENUM(NSUInteger, YumNowStoreListCategoryStyle) {
    YumNowStoreListCategoryStyleTextOnly = 1,
    YumNowStoreListCategoryStyleIconOnly = 2,
    YumNowStoreListCategoryStyleIconText = 3
};

@interface YumNowStoreListFilterHeaderView : SAView
@property (nonatomic, strong) YumNowStoreListFilterHeaderViewModel *model;
/// titile切换了
@property(nonatomic, copy) void (^titleDidSelected)(NSInteger index, WMNearbyFilterModel *option);
/// 筛选组件准备出现
@property(nonatomic, copy) void (^filterViewWillAppear)(UIView *filterView);
/// 筛选组件准备消失（点了确定 or 取消)
@property(nonatomic, copy) void (^filterViewWillDisAppear)(UIView *filterView, WMNearbyFilterModel *option);

@end

@interface YumNowStoreListFilterHeaderViewModel : NSObject
///< 分类颜色
@property (nonatomic, copy) NSString *categoryColor;
///< 分类默认颜色
@property (nonatomic, copy) NSString *categoryDefaultColor;
///< 下划线颜色
@property (nonatomic, copy) NSString *categoryBottomLineColor;
///< 字体大小
@property (nonatomic, assign) NSUInteger categoryFont;
///< 样式
@property (nonatomic, assign) YumNowStoreListCategoryStyle style;
///< view的高度
@property (nonatomic, assign) CGFloat viewHeight;
///< titles
@property (nonatomic, strong) NSArray<NSString *> *titles;

///< iconsize
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, strong) NSArray<NSString *> *iconUrls;

///< 是否展示筛选
@property (nonatomic, assign) BOOL showFiltterComponent;

///< 切换分类的时候是否清空筛选组件，默认yes
@property (nonatomic, assign) BOOL clearFilterOnTitleClicked;

@end

NS_ASSUME_NONNULL_END
