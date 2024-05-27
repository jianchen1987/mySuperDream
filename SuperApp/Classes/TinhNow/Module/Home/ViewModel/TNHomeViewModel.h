//
//  TNHomeViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeCategoryModel.h"
#import "TNHomeViewModelProtocol.h"
#import "TNViewModel.h"
#import <HDUIKit/HDTableViewSectionModel.h>
NS_ASSUME_NONNULL_BEGIN

#define TNHomeGoodCellIdentity @"TNHomeGoodCellIdentity"
#define TNHomeNoDataCellIdentity @"TNHomeNoDataCellIdentity"


@interface TNHomeViewModel : TNViewModel
/// 默认数据源
@property (nonatomic, copy, readonly) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 标志，其它数据变化标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否有下一页
@property (nonatomic, assign, readonly) BOOL hasNextPage;
/// 加载更多失败
@property (nonatomic, copy) void (^failedLoadMoreDataBlock)(void);
/// 网络加载失败
@property (nonatomic, copy) void (^networkFailBlock)(void);
/// showBackButton
@property (nonatomic, assign) BOOL hideBackButton;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
//精选位置
- (NSInteger)getChoicenessSection;
//为你推荐位置
- (NSInteger)getRecommedSection;

/// 下拉加载全部数据
- (void)hd_getNewData;
/// 加载离线数据
- (void)loadOfflineData;
/// 请求广告数据
- (void)requestAdvertisementCompletion:(void (^)(void))completion;
/// 请求轮播文字
- (void)requestScrollTextCompletion:(void (^)(void))completion;
/// 请求活动卡片数据
- (void)requestActivityCardDataCompletion:(void (^)(void))completion;
/// 请求精选数据
- (void)requestNewChoicenessDataCompletion:(void (^)(void))completion;
/// 请求金刚区数据
- (void)requestKingKongAreaUseCache:(BOOL)useCache completion:(void (^)(void))completion;
/// 请求最新的推荐数据
- (void)requestNewRecommendDataCompletion:(void (^)(void))completion;
/// 加载更多推荐数据
- (void)loadMoreRecommendData;
///请求首页分类数据
- (void)requestHomeCategoryDataCompletion:(void (^)(NSArray<TNHomeCategoryModel *> *list))completion;

@end

NS_ASSUME_NONNULL_END
