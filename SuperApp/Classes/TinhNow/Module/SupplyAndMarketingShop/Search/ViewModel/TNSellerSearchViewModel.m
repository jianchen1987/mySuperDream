//
//  TNSellerSearchViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchViewModel.h"
#import "SANoDataCellModel.h"
#import "SANoDataCollectionViewCell.h"
#import "TNCategoryListCell.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNMicroShopProductCell.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNSellerProductCell.h"
#import "TNSellerProductModel.h"
#import "TNSellerProductRspModel.h"
#import "TNSellerSearchDTO.h"
#import "TNSellerStoreCell.h"
#import "TNSellerStoreModel.h"
#import "TNSellerStoreRspModel.h"
#import "TNSellerStoreSkeletonCell.h"


@interface TNSellerSearchViewModel ()
@property (strong, nonatomic) TNSellerSearchDTO *searchDto;
/// 商品数据源
@property (nonatomic, strong) HDTableViewSectionModel *productsSection;
/// 分类数据源
@property (nonatomic, strong) HDTableViewSectionModel *categorySection;
/// 店铺数据源
@property (nonatomic, strong) HDTableViewSectionModel *storeSection;
@end


@implementation TNSellerSearchViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.productCacheKey = @"";
        self.storeCacheKey = @"";
    }
    return self;
}

- (void)setCategoryList:(NSArray<TNCategoryModel *> *)categoryList {
    _categoryList = categoryList;
    //设置分类数据源
    TNCategoryListCellModel *cellModel = [[TNCategoryListCellModel alloc] init];
    cellModel.list = self.categoryList;
    //上层带过来的数据  有默认选中的
    for (NSInteger i = 0; i < cellModel.list.count; i++) {
        TNCategoryModel *oModel = cellModel.list[i];
        if ([oModel.menuId isEqualToString:self.searchSortFilterModel.categoryId]) {
            self.searchSortFilterModel.categoryName = oModel.name;
            oModel.isSelected = true;
            //滚动到选中位置
            cellModel.isNeedScrollerToSelected = true;
            cellModel.scrollerToIndex = i;
            break;
        }
    }
    self.categorySection.list = @[cellModel];
}

- (void)getNewDataByResultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        [self getStoresNewData];
    } else {
        [self getProductsNewData];
    }
}

- (void)loadMoreDataByResultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        [self loadStoresMoreData];
    } else {
        [self loadProductsMoreData];
    }
}

#pragma mark -请求商品数据
- (void)getProductsNewData {
    self.productsCurrentPage = 1;
    [self addProductSkeletonCellMode];
    if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeNone) {
        //搜索选品中心的商品数据
        [self queryProductCenterProducts:NO];
    } else {
        //有视角类型就就是搜索微店商品
        [self queryMicroShopProducts:NO];
    }
}

- (void)loadProductsMoreData {
    self.productsCurrentPage += 1;
    if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeNone) {
        //搜索选品中心的商品数据
        [self queryProductCenterProducts:YES];
    } else {
        //有视角类型就就是搜索微店商品
        [self queryMicroShopProducts:YES];
    }
}
//搜索微店商品
- (void)queryMicroShopProducts:(BOOL)isLoadMore {
    @HDWeakify(self);
    [self.searchDto queryMicroShopProductsWithPageNo:self.productsCurrentPage pageSize:20 filterModel:self.searchSortFilterModel success:^(TNSellerProductRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.searchSortFilterModel.keyWord)) {
            [self saveSearchHistoryWithKeyWord:self.searchSortFilterModel.keyWord];
        }
        if (self.productsCurrentPage == 1) {
            if (!HDIsArrayEmpty(rspModel.list)) {
                self.productsSection.list = [NSArray arrayWithArray:rspModel.list];
            } else {
                SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
                cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
                self.productsSection.list = @[cellModel];
            }
        } else {
            NSMutableArray *cacheArr = [NSMutableArray arrayWithArray:self.productsSection.list];
            [cacheArr addObjectsFromArray:rspModel.list];
            self.productsSection.list = cacheArr;
        }
        self.productRspModel = rspModel;
        self.productsCurrentPage = rspModel.pageNum;
        self.productsHasNextPage = rspModel.hasNextPage;
        self.productCacheKey = self.searchSortFilterModel.keyWord;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.productsCurrentPage == 1) {
            !self.productFailGetNewDataCallback ?: self.productFailGetNewDataCallback();
        }
    }];
}

///搜索选品中心商品
- (void)queryProductCenterProducts:(BOOL)isLoadMore {
    @HDWeakify(self);
    [self.searchDto queryProductCenterProductsWithPageNo:self.productsCurrentPage pageSize:20 filterModel:self.searchSortFilterModel success:^(TNSellerProductRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.searchSortFilterModel.keyWord)) {
            [self saveSearchHistoryWithKeyWord:self.searchSortFilterModel.keyWord];
        }
        if (self.productsCurrentPage == 1) {
            if (!HDIsArrayEmpty(rspModel.list)) {
                self.productsSection.list = [NSArray arrayWithArray:rspModel.list];
            } else {
                SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
                if (HDIsStringNotEmpty(self.storeNo)) {
                    if (HDIsStringNotEmpty(self.searchSortFilterModel.storeNo)) {
                        cellModel.descText = TNLocalizedString(@"2IEOpBIr", @"未搜到相关商品，可查看商城商品");
                    } else {
                        cellModel.descText = TNLocalizedString(@"YE60b1rg", @"未搜到相关商品，请换个关键字搜索");
                    }
                } else {
                    cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
                }
                self.productsSection.list = @[cellModel];
            }
        } else {
            NSMutableArray *cacheArr = [NSMutableArray arrayWithArray:self.productsSection.list];
            [cacheArr addObjectsFromArray:rspModel.list];
            self.productsSection.list = cacheArr;
        }
        self.productsCurrentPage = rspModel.pageNum;
        self.productsHasNextPage = rspModel.hasNextPage;
        self.productCacheKey = self.searchSortFilterModel.keyWord;
        if (HDIsStringNotEmpty(self.searchSortFilterModel.storeNo)) {
            self.proInstoreRefreshFlag = !self.proInstoreRefreshFlag;
        } else {
            self.refreshFlag = !self.refreshFlag;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.productsCurrentPage == 1) {
            !self.productFailGetNewDataCallback ?: self.productFailGetNewDataCallback();
        }
    }];
}

#pragma mark -请求店铺数据
- (void)getStoresNewData {
    self.storesCurrentPage = 1;
    [self addStoreSkeletonCellModel];
    [self queryProductCenterStores:NO];
}

- (void)loadStoresMoreData {
    self.storesCurrentPage += 1;
    [self queryProductCenterStores:YES];
}

- (void)queryProductCenterStores:(BOOL)isLoadMore {
    @HDWeakify(self);
    [self.searchDto queryProductCenterStoresWithPageNo:self.storesCurrentPage pageSize:20 keyWord:self.searchSortFilterModel.keyWord success:^(TNSellerStoreRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.searchSortFilterModel.keyWord)) {
            [self saveSearchHistoryWithKeyWord:self.searchSortFilterModel.keyWord];
        }
        if (self.storesCurrentPage == 1) {
            if (!HDIsArrayEmpty(rspModel.list)) {
                self.storeSection.list = [NSArray arrayWithArray:rspModel.list];
            } else {
                SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
                cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
                self.storeSection.list = @[cellModel];
            }
        } else {
            NSMutableArray *cacheArr = [NSMutableArray arrayWithArray:self.storeSection.list];
            [cacheArr addObjectsFromArray:rspModel.list];
            self.storeSection.list = cacheArr;
        }
        self.storesCurrentPage = rspModel.pageNum;
        self.storesHasNextPage = rspModel.hasNextPage;
        self.storeCacheKey = self.searchSortFilterModel.keyWord;
        self.storeRefreshFlag = !self.storeRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.storesCurrentPage == 1) {
            !self.storeFailGetNewDataCallback ?: self.storeFailGetNewDataCallback();
        }
    }];
}

- (void)addProductSkeletonCellMode {
    NSMutableArray *skeleArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeUser) {
            TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
            [skeleArray addObject:model];
        } else {
            TNMicroShopProductSkeletonCellModel *model = TNMicroShopProductSkeletonCellModel.new;
            [skeleArray addObject:model];
        }
    }
    self.productsSection.list = [NSArray arrayWithArray:skeleArray];
    if (HDIsStringNotEmpty(self.searchSortFilterModel.storeNo)) {
        self.proInstoreRefreshFlag = !self.proInstoreRefreshFlag;
    } else {
        self.refreshFlag = !self.refreshFlag;
    }
}

- (void)addStoreSkeletonCellModel {
    NSMutableArray *skeleArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNSellerStoreSkeletonCellModel *model = TNSellerStoreSkeletonCellModel.new;
        [skeleArray addObject:model];
    }
    self.storeSection.list = [NSArray arrayWithArray:skeleArray];
    self.storeRefreshFlag = !self.storeRefreshFlag;
}

- (NSInteger)collectionNumberOfSectionByResultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        return self.storeList.count;
    } else {
        return self.productList.count;
    }
    return 0;
}
- (NSInteger)collectionNumberOfItemInSection:(NSInteger)section resultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        return self.storeList[section].list.count;
    } else {
        return self.productList[section].list.count;
    }
    return 0;
}
- (CGSize)collctionSizeForItemAtIndexPath:(NSIndexPath *)indexPath resultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        id model = self.storeList[indexPath.section].list[indexPath.row];
        if ([model isKindOfClass:TNSellerStoreModel.class]) {
            return CGSizeMake(kScreenWidth, kRealWidth(100));
        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCellModel *nModel = (SANoDataCellModel *)model;
            return CGSizeMake(kScreenWidth, nModel.cellHeight);
        } else if ([model isKindOfClass:TNSellerStoreSkeletonCellModel.class]) {
            TNSellerStoreSkeletonCellModel *cellModel = (TNSellerStoreSkeletonCellModel *)model;
            return CGSizeMake(kScreenWidth, cellModel.cellHeight);
        }
    } else {
        id model = self.productList[indexPath.section].list[indexPath.row];
        if ([model isKindOfClass:TNSellerProductModel.class]) {
            TNSellerProductModel *sModel = model;
            if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeNone) {
                return CGSizeMake(kScreenWidth, sModel.cellHeight);
            } else { //微店搜索商品接口
                return CGSizeMake(kScreenWidth, sModel.microShopCellHeight);
            }
        } else if ([model isKindOfClass:TNCategoryListCellModel.class]) {
            TNCategoryListCellModel *cellModel = (TNCategoryListCellModel *)model;
            return CGSizeMake(kScreenWidth, cellModel.cellHeight);
        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCellModel *nModel = (SANoDataCellModel *)model;
            return CGSizeMake(kScreenWidth, nModel.cellHeight);
        } else if ([model isKindOfClass:TNMicroShopProductSkeletonCellModel.class]) {
            TNMicroShopProductSkeletonCellModel *cellModel = (TNMicroShopProductSkeletonCellModel *)model;
            return CGSizeMake(kScreenWidth, cellModel.cellHeight);
        } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
            CGFloat itemWidth = (kScreenWidth - kRealWidth(40)) / 2;
            return CGSizeMake(itemWidth, ChoicenessSkeletonCellHeight);
        } else if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsModel *goodModel = model;
            CGFloat itemWidth = (kScreenWidth - kRealWidth(40)) / 2;
            goodModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            goodModel.preferredWidth = itemWidth;
            return CGSizeMake(itemWidth, goodModel.cellHeight);
        }
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath resultType:(TNSellerSearchResultType)resultType {
    if (resultType == TNSellerSearchResultTypeStore) {
        id model = self.storeList[indexPath.section].list[indexPath.row];
        if ([model isKindOfClass:TNSellerStoreModel.class]) {
            TNSellerStoreCell *cell = [TNSellerStoreCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNSellerStoreCell.class)];
            return cell;
        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
            return cell;
        } else if ([model isKindOfClass:TNSellerStoreSkeletonCellModel.class]) {
            TNSellerStoreSkeletonCell *cell = [TNSellerStoreSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNSellerStoreSkeletonCell.class)];
            return cell;
        }
    } else {
        id model = self.productList[indexPath.section].list[indexPath.row];
        if ([model isKindOfClass:TNSellerProductModel.class]) {
            if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeNone) {
                TNSellerProductCell *cell = [TNSellerProductCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNSellerProductCell.class)];
                return cell;
            } else { //微店搜索商品接口
                TNMicroShopProductCell *cell = [TNMicroShopProductCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNMicroShopProductCell.class)];
                return cell;
            }
        } else if ([model isKindOfClass:TNCategoryListCellModel.class]) {
            TNCategoryListCell *cell = [TNCategoryListCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNCategoryListCell.class)];
            return cell;
        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
            return cell;
        } else if ([model isKindOfClass:TNMicroShopProductSkeletonCellModel.class]) {
            TNMicroShopProductSkeletonCell *cell = [TNMicroShopProductSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                               identifier:NSStringFromClass(TNMicroShopProductSkeletonCell.class)];
            return cell;
        } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
            TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
            return cell;
        } else if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsCollectionViewCell *cell = [TNGoodsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
            return cell;
        }
    }
    return UICollectionViewCell.new;
}

- (UIEdgeInsets)collectionInsetForSectionAtIndex:(NSInteger)section resultType:(TNSellerSearchResultType)resultType {
    if (resultType != TNSellerSearchResultTypeStore) {
        if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeUser) {
            HDTableViewSectionModel *sectionModel = self.productList[section];
            if (sectionModel == self.productsSection && !HDIsArrayEmpty(self.productsSection.list)) {
                id model = sectionModel.list.firstObject;
                if ([model isKindOfClass:TNGoodsModel.class] || [model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
                    return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(10), kRealWidth(15));
                } else {
                    return UIEdgeInsetsZero;
                }
            } else {
                return UIEdgeInsetsZero;
            }
        } else {
            return UIEdgeInsetsZero;
        }
    } else {
        return UIEdgeInsetsZero;
    }
}
- (NSInteger)collectionColumnCountOfSection:(NSInteger)section resultType:(TNSellerSearchResultType)resultType {
    if (resultType != TNSellerSearchResultTypeStore) {
        if (self.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeUser) {
            HDTableViewSectionModel *sectionModel = self.productList[section];
            if (sectionModel == self.productsSection && !HDIsArrayEmpty(self.productsSection.list)) {
                id model = sectionModel.list.firstObject;
                if ([model isKindOfClass:TNGoodsModel.class] || [model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
                    return 2;
                } else {
                    return 1;
                }
            } else {
                return 1;
            }
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}
- (void)removeProductFromProductListByModel:(TNSellerProductModel *)model collectionView:(UICollectionView *)collectionView {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.productsSection.list];
    if ([array containsObject:model]) {
        [array removeObject:model];
        self.productsSection.list = array;
        [collectionView reloadData];
    }
}

/** @lazy searchDto */
- (TNSellerSearchDTO *)searchDto {
    if (!_searchDto) {
        _searchDto = [[TNSellerSearchDTO alloc] init];
    }
    return _searchDto;
}
/** @lazy productList */
- (NSMutableArray *)productList {
    if (!_productList) {
        _productList = [NSMutableArray array];
        if (!HDIsArrayEmpty(self.categoryList)) {
            [_productList addObject:self.categorySection];
        }
        [_productList addObject:self.productsSection];
    }
    return _productList;
}
/** @lazy storeList */
- (NSMutableArray *)storeList {
    if (!_storeList) {
        _storeList = [NSMutableArray array];
        [_storeList addObject:self.storeSection];
    }
    return _storeList;
}

/** @lazy productsSection */
- (HDTableViewSectionModel *)productsSection {
    if (!_productsSection) {
        _productsSection = [[HDTableViewSectionModel alloc] init];
        _productsSection.list = @[];
        if (!HDIsArrayEmpty(self.categoryList)) {
            HDTableHeaderFootViewModel *headerModel = [[HDTableHeaderFootViewModel alloc] init];
            _productsSection.headerModel = headerModel;
        }
    }
    return _productsSection;
}
/** @lazy categorySection */
- (HDTableViewSectionModel *)categorySection {
    if (!_categorySection) {
        _categorySection = [[HDTableViewSectionModel alloc] init];
        _categorySection.list = @[];
    }
    return _categorySection;
}
/** @lazy productsSection */
- (HDTableViewSectionModel *)storeSection {
    if (!_storeSection) {
        _storeSection = [[HDTableViewSectionModel alloc] init];
        _storeSection.list = @[];
    }
    return _storeSection;
}
@end
