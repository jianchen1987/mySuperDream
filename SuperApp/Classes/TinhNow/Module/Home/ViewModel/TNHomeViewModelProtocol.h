//
//  TNHomeViewModelProtocol.h
//  SuperApp
//
//  Created by Chaos on 2021/7/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewModelProtocol.h"
#import "TNHomeCategoryModel.h"
#import <Foundation/Foundation.h>
#import <HDUIKit/HDTableViewSectionModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TNHomeViewModelProtocol <SAViewModelProtocol>
/// 默认数据源
@property (nonatomic, copy, readonly) NSArray<HDTableViewSectionModel *> *dataSource;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasNextPage;
/// 加载更多失败
@property (nonatomic, copy) void (^failedLoadMoreDataBlock)(void);
/// 网络加载失败
@property (nonatomic, copy) void (^networkFailBlock)(void);
/// 是否显示购物车按钮
@property (nonatomic, assign) BOOL shouldShowShoppingCartBTN;
/// showBackButton
@property (nonatomic, assign) BOOL hideBackButton;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;

/// 加载离线数据
- (void)loadOfflineData;

- (void)hd_getNewData;

/// 加载更多
- (void)loadMoreChoicenessData;

- (void)reloadWindowWhenChangLanguage;
///请求首页分类数据
- (void)requestHomeCategoryDataCompletion:(void (^)(NSArray<TNHomeCategoryModel *> *list))completion;

@end

NS_ASSUME_NONNULL_END
