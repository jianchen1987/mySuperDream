//
//  TNSellerSearchViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNSearchBaseViewModel.h"
#import "TNSearchSortFilterModel.h"
#import "TNSellerProductRspModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TNSellerSearchResultType) {
    //搜索选品商品
    TNSellerSearchResultTypeProduct = 0,
    //搜索选品店铺
    TNSellerSearchResultTypeStore = 1,
    //搜索某个店铺的商品
    TNSellerSearchResultTypeProductInStore = 2,
    //搜索整个商城的商品
    TNSellerSearchResultTypeAllProductInMall = 3
};


@interface TNSellerSearchViewModel : TNSearchBaseViewModel
/// 搜索商品结果数据
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *__nullable productList;
/// 搜索店铺结果数据
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *__nullable storeList;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 店铺内商品刷新标记
@property (nonatomic, assign) BOOL proInstoreRefreshFlag;
/// 店铺刷新标记
@property (nonatomic, assign) BOOL storeRefreshFlag;
/// 三类分类数据源  用于分类搜索页展示分类数据
@property (nonatomic, strong) NSArray<TNCategoryModel *> *categoryList;
/// 门店号 搜索某个店铺用
@property (nonatomic, copy) NSString *storeNo;

@property (nonatomic, copy) void (^productFailGetNewDataCallback)(void);
@property (nonatomic, copy) void (^storeFailGetNewDataCallback)(void);

/// 商品搜索当前页码
@property (nonatomic, assign) NSInteger productsCurrentPage;
/// 商品搜索是否有下一页
@property (nonatomic, assign) BOOL productsHasNextPage;

/// 店铺搜索当前页码
@property (nonatomic, assign) NSInteger storesCurrentPage;
/// 店铺搜索是否有下一页
@property (nonatomic, assign) BOOL storesHasNextPage;

/// 搜索商品缓存的 关键字  用于是否刷新列表数据
@property (nonatomic, copy) NSString *productCacheKey;
/// 搜索店铺缓存的 关键字
@property (nonatomic, copy) NSString *storeCacheKey;

/// 商品数据源
@property (nonatomic, strong, readonly) HDTableViewSectionModel *productsSection;

/// 微店列表单次搜索结果模型
@property (strong, nonatomic) TNSellerProductRspModel *productRspModel;

// 获取最新商品数据
- (void)getNewDataByResultType:(TNSellerSearchResultType)resultType;
// 加载更多店铺数据
- (void)loadMoreDataByResultType:(TNSellerSearchResultType)resultType;

- (void)getProductsNewData;
- (void)loadProductsMoreData;

// collectionView
// 获取collectionView sections
- (NSInteger)collectionNumberOfSectionByResultType:(TNSellerSearchResultType)resultType;
// 获取collectionView items
- (NSInteger)collectionNumberOfItemInSection:(NSInteger)section resultType:(TNSellerSearchResultType)resultType;
// 获取item 宽高
- (CGSize)collctionSizeForItemAtIndexPath:(NSIndexPath *)indexPath resultType:(TNSellerSearchResultType)resultType;
// 获取cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath resultType:(TNSellerSearchResultType)resultType;
// 获取间距
- (UIEdgeInsets)collectionInsetForSectionAtIndex:(NSInteger)section resultType:(TNSellerSearchResultType)resultType;
// 获取colletionView 每行个数
- (NSInteger)collectionColumnCountOfSection:(NSInteger)section resultType:(TNSellerSearchResultType)resultType;

//删除某个商品
- (void)removeProductFromProductListByModel:(TNSellerProductModel *)model collectionView:(UICollectionView *)collectionView;
@end

NS_ASSUME_NONNULL_END
