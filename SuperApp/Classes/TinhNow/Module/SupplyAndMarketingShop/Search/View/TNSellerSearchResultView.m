//
//  TNSellerSearchResultView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchResultView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SANoDataCollectionViewCell.h"
#import "TNCategoryListCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNGoodsSortFilterReusableView.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNMicroShopProductCell.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNSearchSortFilterBar.h"
#import "TNSellerProductCell.h"
#import "TNSellerStoreCell.h"
#import "TNSellerStoreSkeletonCell.h"


@interface TNSellerSearchResultView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
@property (nonatomic, strong) TNCollectionView *collectionView;     ///<
@property (nonatomic, strong) TNSearchSortFilterBar *sortFilterBar; ///<指定搜索栏
/// viewModel
@property (strong, nonatomic) TNSellerSearchViewModel *viewModel;
@property (nonatomic, assign) BOOL hadLoadData; //记录是否已经加载过数据
///
@property (nonatomic, assign) BOOL isSearchProductList;            //是否是搜索商品页面
@property (nonatomic, assign) TNSellerSearchResultType resultType; ///< 搜索显示类型
//@property (nonatomic, assign) BOOL isLoadingData;  //记录正在加载过数据
@end


@implementation TNSellerSearchResultView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel resultType:(TNSellerSearchResultType)resultType {
    self.viewModel = viewModel;
    self.resultType = resultType;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.sortFilterBar];
    [self addSubview:self.collectionView];
    if (self.resultType == TNSellerSearchResultTypeProduct || self.resultType == TNSellerSearchResultTypeProductInStore || self.resultType == TNSellerSearchResultTypeAllProductInMall) {
        if (HDIsArrayEmpty(self.viewModel.categoryList)) {
            self.sortFilterBar.hidden = NO;
        } else {
            self.sortFilterBar.hidden = YES;
        }
    } else if (self.resultType == TNSellerSearchResultTypeStore) {
        self.sortFilterBar.hidden = YES;
    }
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    if (self.resultType == TNSellerSearchResultTypeProduct || self.resultType == TNSellerSearchResultTypeProductInStore || self.resultType == TNSellerSearchResultTypeAllProductInMall) {
        self.viewModel.productFailGetNewDataCallback = ^{
            @HDStrongify(self);
            [self.viewModel.productList removeAllObjects];
            [self.collectionView failGetNewData];
        };

        NSString *keyPath = @"refreshFlag";
        if (self.resultType == TNSellerSearchResultTypeProductInStore) {
            keyPath = @"proInstoreRefreshFlag";
        }

        [self.KVOController hd_observe:self.viewModel keyPath:keyPath block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.hadLoadData = YES;
            if (self.viewModel.productsCurrentPage == 1) {
                [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.productsHasNextPage];
            } else {
                [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.productsHasNextPage];
            }
        }];
    } else if (self.resultType == TNSellerSearchResultTypeStore) {
        self.viewModel.storeFailGetNewDataCallback = ^{
            @HDStrongify(self);
            [self.viewModel.storeList removeAllObjects];
            [self.collectionView failGetNewData];
        };

        [self.KVOController hd_observe:self.viewModel keyPath:@"storeRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            //                                     self.isLoadingData = NO;
            if (self.viewModel.storesCurrentPage == 1) {
                [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.storesHasNextPage];
            } else {
                [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.storesHasNextPage];
            }
        }];
    }
}
- (void)updateConstraints {
    if (!self.sortFilterBar.isHidden) {
        [self.sortFilterBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(45);
        }];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(!self.sortFilterBar.isHidden ? self.sortFilterBar.mas_bottom : self.mas_top);
        make.left.right.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel collectionNumberOfSectionByResultType:self.resultType];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel collectionNumberOfItemInSection:section resultType:self.resultType];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel collectionView:collectionView cellForItemAtIndexPath:indexPath resultType:self.resultType];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultType == TNSellerSearchResultTypeStore) {
        id model = self.viewModel.storeList[indexPath.section].list[indexPath.row];
        if ([cell isKindOfClass:TNSellerStoreCell.class]) {
            TNSellerStoreCell *storeCell = (TNSellerStoreCell *)cell;
            storeCell.model = model;
        } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
            SANoDataCollectionViewCell *noDataCell = (SANoDataCollectionViewCell *)cell;
            noDataCell.model = model;
        } else if ([cell isKindOfClass:TNSellerStoreSkeletonCell.class]) {
            [cell hd_beginSkeletonAnimation];
        }
    } else {
        id model = self.viewModel.productList[indexPath.section].list[indexPath.row];
        if ([cell isKindOfClass:TNSellerProductCell.class]) {
            TNSellerProductCell *productCell = (TNSellerProductCell *)cell;
            productCell.model = model;
            @HDWeakify(self);
            productCell.reloadTableViewCallBack = ^{
                @HDStrongify(self);
                [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.productsHasNextPage scrollToTop:NO];
            };
        } else if ([cell isKindOfClass:TNMicroShopProductCell.class]) {
            TNMicroShopProductCell *productCell = (TNMicroShopProductCell *)cell;
            productCell.isFromSearch = YES;
            productCell.model = model;
            @HDWeakify(self);
            productCell.deleteProductCallBack = ^(TNSellerProductModel *_Nonnull curModel) {
                @HDStrongify(self);
                [self.viewModel removeProductFromProductListByModel:curModel collectionView:collectionView];
                [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
            };
            productCell.changeProductPriceCallBack = ^{
                @HDStrongify(self);
                [self.viewModel getNewDataByResultType:TNSellerSearchResultTypeProduct];
                [TNGlobalData shared].seller.isNeedRefreshMicroShop = YES;
            };
            productCell.setProductHotSalesCallBack = ^(BOOL hotSales) {
                @HDStrongify(self);
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            };
        } else if ([cell isKindOfClass:TNCategoryListCell.class]) {
            TNCategoryListCell *categoryCell = (TNCategoryListCell *)cell;
            @HDWeakify(self);
            categoryCell.categorySelectedCallBack = ^(TNCategoryModel *_Nonnull cModel) {
                @HDStrongify(self);
                self.viewModel.searchSortFilterModel.categoryId = cModel.menuId;
                self.viewModel.searchSortFilterModel.categoryName = cModel.name;
                [self.viewModel getNewDataByResultType:TNSellerSearchResultTypeProduct];
            };
            categoryCell.model = model;
        } else if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
            TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
            goodCell.model = model;
        } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
            SANoDataCellModel *noDataModel = model;
            SANoDataCollectionViewCell *noDataCell = (SANoDataCollectionViewCell *)cell;
            noDataCell.model = noDataModel;
        } else if ([cell isKindOfClass:TNMicroShopProductSkeletonCell.class] || [cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
            [cell hd_beginSkeletonAnimation];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.resultType != TNSellerSearchResultTypeStore) {
        id model = self.viewModel.productList[indexPath.section].list[indexPath.row];
        if ([model isKindOfClass:TNSellerProductModel.class]) {
            @HDWeakify(self);
            void (^callBack)(TNSellerProductModel *) = ^(TNSellerProductModel *tempModel) {
                @HDStrongify(self);
                if (self.viewModel.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeSeller) {
                    //搜索的是微店的商品
                    if (tempModel.sale == NO) {
                        //已经在详情移除微店商品了
                        NSMutableArray *array = self.viewModel.productList[indexPath.section].list.mutableCopy;
                        for (TNSellerProductModel *subModel in array) {
                            if ([subModel.productId isEqualToString:tempModel.productId]) {
                                [array removeObject:subModel];
                                if (HDIsArrayEmpty(array)) {
                                    SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
                                    cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
                                    [array addObject:cellModel];
                                }
                                self.viewModel.productList[indexPath.section].list = array;
                                break;
                            }
                        }
                    }
                }
                [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            };
            TNSellerProductModel *pModel = (TNSellerProductModel *)model;
            [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{
                @"productId": pModel.productId,
                @"isFromProductCenter": @"1",
                //                @"sp" : [TNGlobalData shared].seller.supplierId,
                @"sellerProductModel": pModel,
                @"addOrCancelSellerProductCallBack": callBack,
            }];
        } else if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsModel *gModel = (TNGoodsModel *)model;
            [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": gModel.productId}];
            //            @"sp" : self.viewModel.searchSortFilterModel.sp
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel collctionSizeForItemAtIndexPath:indexPath resultType:self.resultType];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!HDIsArrayEmpty(self.viewModel.categoryList)) {
        HDTableViewSectionModel *sectionModel = self.viewModel.productList[section];
        if (sectionModel.headerModel != nil) {
            return CGSizeMake(kScreenWidth, 95);
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!HDIsArrayEmpty(self.viewModel.categoryList)) {
        HDTableViewSectionModel *sectionModel = self.viewModel.productList[indexPath.section];
        if ([kind isEqualToString:UICollectionElementKindSectionHeader] && sectionModel.headerModel != nil) {
            TNGoodsSortFilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                           withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)
                                                                                                  forIndexPath:indexPath];
            if (!headerView) {
                headerView = [[TNGoodsSortFilterReusableView alloc] init];
            }
            headerView.viewModel = self.viewModel;
            if (self.viewModel.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeSeller) {
                //搜索卖家自己商品  就隐藏销量
                [headerView.sortFilterBar hideSaleSortBtn];
            }
            headerView.desText = self.viewModel.searchSortFilterModel.categoryName;
            @HDWeakify(self);
            headerView.sortFilterBar.clickShowFilterViewCallBack = ^(CGFloat updateOffsetY) {
                @HDStrongify(self);
                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + updateOffsetY) animated:NO];
                [self layoutIfNeeded];
            };
            return headerView;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [self.viewModel collectionInsetForSectionAtIndex:section resultType:self.resultType];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return [self.viewModel collectionColumnCountOfSection:section resultType:self.resultType];
}
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.header_suspension = YES;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = YES;
        _collectionView.needShowNoDataView = YES;
        _collectionView.needShowErrorView = YES;
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadMoreDataByResultType:self.resultType];
        };
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getNewDataByResultType:self.resultType];
        };
        [_collectionView registerClass:TNGoodsSortFilterReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)];
    }
    return _collectionView;
}
- (TNSearchSortFilterBar *)sortFilterBar {
    if (!_sortFilterBar) {
        _sortFilterBar = [[TNSearchSortFilterBar alloc] init];
        _sortFilterBar.viewModel = self.viewModel;
        @HDWeakify(self);
        _sortFilterBar.clickFilterConditionCallBack = ^{
            //            @HDStrongify(self);
        };
        if (self.viewModel.searchSortFilterModel.searchType == TNMicroShopProductSearchTypeSeller) {
            //搜索卖家自己商品  就隐藏销量
            [_sortFilterBar hideSaleSortBtn];
        }
    }
    return _sortFilterBar;
}
/** @lazy viewModel */
- (TNSellerSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNSellerSearchViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark - HDCategoryListContentViewDelegate
//- (void)listWillAppear {
//    if (self.isLoadingData) {
//        return;
//    }
//    //页面即将出现  如果记录的keyword不同  就得重新刷新数据
//    if (self.resultType == TNSellerSearchResultTypeProduct) {
//        if (![self.viewModel.productCacheKey isEqualToString:self.viewModel.searchSortFilterModel.keyWord] || (!self.hadLoadData && !HDIsArrayEmpty(self.viewModel.categoryList))) {
//            [self.viewModel getNewDataByResultType:TNSellerSearchResultTypeProduct];
//        }
//    } else if (self.resultType == TNSellerSearchResultTypeStore) {
//        if (![self.viewModel.storeCacheKey isEqualToString:self.viewModel.searchSortFilterModel.keyWord]) {
//            [self.viewModel getNewDataByResultType:TNSellerSearchResultTypeStore];
//        }
//    }
//    self.isLoadingData = YES;
//}
- (UIView *)listView {
    return self;
}

@end
