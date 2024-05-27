//
//  WMStoreListMenuView.h
//  SuperApp
//
//  Created by wmz on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMCategoryItem.h"
#import "WMNearbyFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WMStoreListMenuViewDelegate <NSObject>

@optional

- (void)clickItem:(WMCategoryItem *)model;

- (void)clickSort:(WMNearbyFilterModel *)filterModel;

- (void)clickFilter:(WMNearbyFilterModel *)filterModel;

@end

@class WMStoreListMenuItemView;


@interface WMStoreListMenuView : SAView
/// delegate
@property (nonatomic, assign) id<WMStoreListMenuViewDelegate> delegate;
///一级分类模
@property (nonatomic, strong) WMCategoryItem *model;
///全部分类
@property (nonatomic, strong) WMCategoryItem *allModel;
/// 视图数组
@property (nonatomic, strong) NSMutableArray<WMStoreListMenuItemView *> *dataSource;
/// 选中视图数组
@property (nonatomic, strong) WMStoreListMenuItemView *selectView;
/// 下划线
@property (nonatomic, strong) UIView *lineView;

- (void)updateAlpah:(CGFloat)num;

/// viewWillAppear
@property (nonatomic, copy) void (^viewWillAppear)(UIView *view);
/// viewWillDisappear
//@property (nonatomic, copy) void (^viewWillDisappear)(UIView *view);
/// model
@property (nonatomic, strong) WMNearbyFilterModel *filterModel;

- (void)hideAllSlideDownView;

@end


@interface WMStoreListMenuItemView : SAView

@property (nonatomic, strong) WMCategoryItem *model; ///二级分类模型

@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) UIImageView *iconLB;

@end

NS_ASSUME_NONNULL_END
