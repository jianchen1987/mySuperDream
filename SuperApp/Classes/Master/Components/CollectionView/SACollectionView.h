//
//  SACollectionView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDUIKit/UIViewPlaceholder.h>
#import <MJRefresh/MJRefresh.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SACollectionView : UICollectionView <UIGestureRecognizerDelegate>

@property (nonatomic, copy) void (^requestNewDataHandler)(void);
@property (nonatomic, copy) void (^requestMoreDataHandler)(void);

@property (nonatomic, assign) BOOL needRefreshHeader;  ///< 需要下拉刷新
@property (nonatomic, assign) BOOL needRefreshFooter;  ///< 需要下拉加载
@property (nonatomic, assign) BOOL needShowNoDataView; ///< 需要显示无数据占位
@property (nonatomic, assign) BOOL needShowErrorView;  ///< 需要显示网络错误占位

@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel; ///< 数据为空占位图配置模型

/// 刷新，内部会调用 mj_header beginRefreshing（根据 needRefreshHeader）
- (void)getNewData;

/// 下拉刷新后调用 reloadData，根据是否还有更多数据决定是否显示刷新控件 footer
/// @param isNoMore 是否还有更多数据
- (void)successGetNewDataWithNoMoreData:(BOOL)isNoMore;

/// 下拉刷新后调用 reloadData，根据是否还有更多数据决定是否显示刷新控件 footer
/// @param isNoMore 是否还有更多数据
/// @param isScrollToTop 是否需要置顶
- (void)successGetNewDataWithNoMoreData:(BOOL)isNoMore scrollToTop:(BOOL)isScrollToTop;

/// 上拉加载更多后调用 reloadData，根据是否还有更多数据决定是否显示刷新控件 footer
/// @param isNoMore 是否还有更多数据
- (void)successLoadMoreDataWithNoMoreData:(BOOL)isNoMore;

/// 刷新获取数据失败
- (void)failGetNewData;

/// 上拉加载获取数据失败
- (void)failLoadMoreData;

@property (nonatomic, copy) void (^tappedRefreshBtnHandler)(void); ///< 刷新按钮回调

/// 请使用 successGetNewDataWithNoMoreData：方法
- (void)reloadData NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
