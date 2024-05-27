//
//  TNStoreHomeView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreHomeView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "LKDataRecord.h"
#import "SANoDataCellModel.h"
#import "SANoDataCollectionViewCell.h"
#import "TNBargainGoodsCell.h"
#import "TNCategoryListCell.h"
#import "TNCategoryListSkeletonCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsSortFilterReusableView.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNMicroShopInfoCell.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterModel.h"
#import "TNSearchViewModel.h"
#import "TNSellerProductCell.h"
#import "TNSellerSearchViewModel.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNStoreInfoCollectionViewCell.h"
#import "TNStoreInfoSkeletonCell.h"
#import "TNStoreSceneCell.h"
#import "TNStoreSceneRspModel.h"
#import "TNStoreViewModel.h"


@interface TNStoreHomeView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// storeviewmodel
@property (nonatomic, strong) TNStoreViewModel *storeViewModel;
/// searchViewModel
@property (nonatomic, strong) TNSearchViewModel *searchViewModel;
/// collectionView
@property (nonatomic, strong) TNCollectionView *collectionView;
/// 组头原始 Y 值
@property (nonatomic, assign) CGFloat headerOriginalY;
///  微店搜索viewModel
@property (strong, nonatomic) TNSellerSearchViewModel *sellerSearchViewModel;
@end


@implementation TNStoreHomeView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.storeViewModel = viewModel;
    self.searchViewModel.searchSortFilterModel.storeNo = self.storeViewModel.storeNo;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.collectionView];
}
- (void)hd_bindViewModel {
    [self.collectionView successGetNewDataWithNoMoreData:YES];

    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        // 微店 主页
        [self getMicroShopViewData];
    } else if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
        //供销店主页
        [self getAddSellerStoreViewData];
    } else if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
        [self getNormalStoreViewData];
    }
}

#pragma mark - 获取微店主页数据
- (void)getMicroShopViewData {
    @HDWeakify(self);
    //获取微店信息数据
    [self.storeViewModel requestMircoShopInfoCompletion:^{
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
    }];

    [self.KVOController hd_observe:self.sellerSearchViewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.sellerSearchViewModel.productsSection.list)) {
            self.storeViewModel.goodsListSection.list = self.sellerSearchViewModel.productsSection.list;
        } else {
            SANoDataCellModel *cellModel = SANoDataCellModel.new;
            cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
            self.storeViewModel.goodsListSection.list = @[cellModel];
        }
        //如果分类没有数据的时候  加载一次分类数据
        if (HDIsArrayEmpty(self.storeViewModel.categoryList)) {
            [self.storeViewModel prepareMicroShopCategoryDataByRspModel:self.sellerSearchViewModel.productRspModel];
        }
        if (self.sellerSearchViewModel.productsCurrentPage == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
        }
    }];

    //获取微店商品列表数据
    [self.sellerSearchViewModel getProductsNewData];
}
#pragma mark -获取普通店铺店铺数据
- (void)getNormalStoreViewData {
    @HDWeakify(self);
    //获取店铺数据
    [self.storeViewModel requestStoreInfoCompletion:^{
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
    }];
    //获取分类数据
    [self.storeViewModel requestStoreRecommendCategoryCompletion:^{
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
    }];
    //获取商品列表数据
    [self addSkeleLayerCellModel];
    [self.searchViewModel requestNewData];

    [self.KVOController hd_observe:self.searchViewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.searchViewModel.searchResult)) {
            self.storeViewModel.goodsListSection.list = [NSArray arrayWithArray:self.searchViewModel.searchResult];
        } else {
            SANoDataCellModel *cellModel = SANoDataCellModel.new;
            cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
            self.storeViewModel.goodsListSection.list = @[cellModel];
        }
        if (self.searchViewModel.rspModel.pageNum == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
        }
    }];
    //监听实景数据
    [self.KVOController hd_observe:self.storeViewModel keyPath:@"sceneRefreshTag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.storeViewModel.rspModel.pageNum == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        }
    }];
}
#pragma mark -获取选品店铺数据
- (void)getAddSellerStoreViewData {
    @HDWeakify(self);
    //获取店铺数据
    [self.storeViewModel requestStoreInfoCompletion:^{
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
    }];
    //获取分类数据
    [self.storeViewModel requestStoreRecommendCategoryCompletion:^{
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
    }];

    [self.KVOController hd_observe:self.sellerSearchViewModel keyPath:@"proInstoreRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.sellerSearchViewModel.productsSection.list)) {
            self.storeViewModel.goodsListSection.list = self.sellerSearchViewModel.productsSection.list;
        } else {
            SANoDataCellModel *cellModel = SANoDataCellModel.new;
            cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
            self.storeViewModel.goodsListSection.list = @[cellModel];
        }
        if (self.sellerSearchViewModel.productsCurrentPage == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
        }
    }];
    //监听实景数据
    [self.KVOController hd_observe:self.storeViewModel keyPath:@"sceneRefreshTag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.storeViewModel.rspModel.pageNum == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        }
    }];

    //获取选品店铺数据
    [self.sellerSearchViewModel getProductsNewData];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - 添加商品骨架
- (void)addSkeleLayerCellModel {
    NSMutableArray<TNHomeChoicenessSkeletonCellModel *> *skeletonModelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeletonModelArray addObject:model];
    }
    self.storeViewModel.goodsListSection.list = skeletonModelArray;
    [self.collectionView successLoadMoreDataWithNoMoreData:NO];
}

#pragma mark 菜单栏切换
- (void)changeMenu {
    self.storeViewModel.isShowAllProductList = !self.storeViewModel.isShowAllProductList;
    if (self.storeViewModel.isShowAllProductList) {
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
            if (self.searchViewModel.rspModel.pageNum == 1) {
                [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
            } else {
                [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
            }
        } else {
            if (self.sellerSearchViewModel.productsCurrentPage == 1) {
                [self.collectionView successGetNewDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
            } else {
                [self.collectionView successLoadMoreDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage];
            }
        }

    } else {
        if (!self.storeViewModel.hasLoadSceneData) {
            [self.storeViewModel requestNewStoreSceneData];
        }
        if (self.storeViewModel.rspModel.pageNum == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.storeViewModel.rspModel.hasNextPage];
        }
    }
}
#pragma mark - 设置collectionView偏移位置
- (void)updateCollectionViewOffset {
    if (self.searchViewModel.isNeedUpdateContentOffset && self.collectionView.contentOffset.y > self.headerOriginalY) {
        [self.collectionView setContentOffset:CGPointMake(0, self.headerOriginalY) animated:NO];
    }
    self.searchViewModel.isNeedUpdateContentOffset = NO; //设置过一次就重置状态
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HDCollectionViewVerticalLayout *flowLayout = (HDCollectionViewVerticalLayout *)self.collectionView.collectionViewLayout;
    if (flowLayout.headerAttributesArray.count > 0) { //只有一个组头
        if (self.headerOriginalY <= 0) {              //只取一次原始位置的高度
            UICollectionViewLayoutAttributes *attriture = flowLayout.headerAttributesArray.firstObject;
            self.headerOriginalY = attriture.frame.origin.y;
        }
    }
    [[TNShoppingCartEntryWindow sharedInstance] shrink];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[TNShoppingCartEntryWindow sharedInstance] performSelector:@selector(expand) withObject:nil afterDelay:1];
}
#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.storeViewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storeViewModel.dataSource[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    if (indexPath.section >= self.storeViewModel.dataSource.count) {
        return tmp;
    }
    HDTableViewSectionModel *sectionModel = self.storeViewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count) {
        return tmp;
    }
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNStoreInfoRspModel.class]) {
        TNStoreInfoCollectionViewCell *cell = [TNStoreInfoCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                         identifier:NSStringFromClass(TNStoreInfoCollectionViewCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodsCell *cell = [TNBargainGoodsCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainGoodsCell.class)];
            return cell;
        } else {
            TNGoodsCollectionViewCell *cell = [TNGoodsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
            trueModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            trueModel.isNeedShowSmallShopCar = trueModel.isOutOfStock ? NO : self.storeViewModel.storeInfo.isQuicklyAddToCart;
            return cell;
        }
    } else if ([model isKindOfClass:TNCategoryListCellModel.class]) {
        TNCategoryListCell *cell = [TNCategoryListCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNCategoryListCell.class)];
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNStoreSceneModel.class]) {
        TNStoreSceneCell *cell = [TNStoreSceneCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNStoreSceneCell.class)];
        return cell;
    } else if ([model isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
        TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                       identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
        return cell;
    } else if ([model isKindOfClass:[TNStoreInfoSkeletonCellModel class]]) {
        TNStoreInfoSkeletonCell *cell = [TNStoreInfoSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNStoreInfoSkeletonCell.class)];
        return cell;
    } else if ([model isKindOfClass:[TNCategoryListSkeletonCellModel class]]) {
        TNCategoryListSkeletonCell *cell = [TNCategoryListSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNCategoryListSkeletonCell.class)];
        return cell;
    } else if ([model isKindOfClass:[TNSellerProductModel class]]) {
        TNSellerProductCell *cell = [TNSellerProductCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNSellerProductCell.class)];
        return cell;
    } else if ([model isKindOfClass:[TNMicroShopDetailInfoModel class]]) {
        TNMicroShopInfoCell *cell = [TNMicroShopInfoCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNMicroShopInfoCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNMicroShopProductSkeletonCellModel.class]) {
        TNMicroShopProductSkeletonCell *cell = [TNMicroShopProductSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNMicroShopProductSkeletonCell.class)];
        return cell;
    } else {
        return [[UICollectionViewCell alloc] init];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.storeViewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([cell isKindOfClass:TNStoreInfoCollectionViewCell.class]) {
        TNStoreInfoCollectionViewCell *storeInfoCell = (TNStoreInfoCollectionViewCell *)cell;
        @HDWeakify(self);
        storeInfoCell.changeMenuCallBack = ^(BOOL showAllProduct) {
            @HDStrongify(self);
            [self changeMenu];
        };
        storeInfoCell.model = model;
    } else if ([cell isKindOfClass:TNBargainGoodsCell.class]) {
        TNBargainGoodsCell *bargainGoodCell = (TNBargainGoodsCell *)cell;
        bargainGoodCell.model = [TNBargainGoodModel modelWithProductModel:model];
    } else if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
        TNGoodsModel *goodModel = model;
        TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
        goodCell.model = goodModel;
        if (self.storeViewModel.storeViewShowType != TNStoreViewShowTypeMicroShop) {
            goodCell.addShopCartTrackEventCallBack = ^(NSString *_Nonnull productId) {
                [SATalkingData trackEvent:[self.storeViewModel.trackPrefixName stringByAppendingString:@"店铺主页_加入购物车"] label:@"" parameters:@{@"商品ID": productId}];

                //店铺加购
                [TNEventTrackingInstance trackEvent:@"store_add_cart" properties:@{@"storeId": self.storeViewModel.storeNo, @"productId": productId}];

                // 首页转化漏斗
                NSString *homeSource = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_source"];
                NSString *homeAssociateId = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_associatedId"];

                [LKDataRecord.shared
                    traceEvent:@"add_shopcart"
                          name:[NSString stringWithFormat:@"电商_购物车_加购_%@",
                                                          HDIsStringNotEmpty(self.storeViewModel.source) ? self.storeViewModel.source : (HDIsStringNotEmpty(homeSource) ? homeSource : @"other")]
                    parameters:@{
                        @"associatedId": HDIsStringNotEmpty(self.storeViewModel.associatedId) ? self.storeViewModel.associatedId : (HDIsStringNotEmpty(homeAssociateId) ? homeAssociateId : @""),
                        @"goodsId": productId
                    }
                           SPM:[LKSPM SPMWithPage:@"TNStoreInfoViewController" area:@"" node:@""]];
                // end
            };
        }
        //记录曝光
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:goodModel.productId];

    } else if ([cell isKindOfClass:TNCategoryListCell.class]) {
        TNCategoryListCell *categoryCell = (TNCategoryListCell *)cell;
        categoryCell.model = (TNCategoryListCellModel *)model;
        @HDWeakify(self);
        categoryCell.categorySelectedCallBack = ^(TNCategoryModel *_Nonnull cModel) {
            @HDStrongify(self);
            //切换分类后 先上送滚动浏览的埋点数据
            [self.storeViewModel trackScrollProductsExposure];

            if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
                self.searchViewModel.searchSortFilterModel.categoryId = cModel.menuId;
                [self addSkeleLayerCellModel];
                [self.searchViewModel requestNewData];
            } else {
                self.sellerSearchViewModel.searchSortFilterModel.categoryId = cModel.menuId;
                [self.sellerSearchViewModel getProductsNewData];
            }
            //新加需求   点击全部按钮 进入分类列表页
            if (HDIsStringEmpty(cModel.menuId)) { //没有分类id的就是全部
                ///更多分类页就是进入分类列表页
                if (self.moreCategoryClickCallback) {
                    self.moreCategoryClickCallback();
                }
            } else {
                //切换分类
                [TNEventTrackingInstance trackEvent:@"switch_category" properties:@{@"storeId": self.storeViewModel.storeNo, @"categoryId": cModel.menuId, @"type": @"3"}];
            }
        };
        categoryCell.moreCategoryClickCallBack = ^{
            @HDStrongify(self);
            if (self.moreCategoryClickCallback) {
                self.moreCategoryClickCallback();
            }
        };
    } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
        SANoDataCollectionViewCell *nodataCell = (SANoDataCollectionViewCell *)cell;
        nodataCell.model = model;
    } else if ([cell isKindOfClass:TNStoreSceneCell.class]) {
        TNStoreSceneCell *sceneCell = (TNStoreSceneCell *)cell;
        sceneCell.model = (TNStoreSceneModel *)model;
        @HDWeakify(self);
        sceneCell.moreClickCallBack = ^(BOOL isShowMore) {
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        };
        sceneCell.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        };
    } else if ([cell isKindOfClass:TNMicroShopInfoCell.class]) {
        TNMicroShopInfoCell *infoCell = (TNMicroShopInfoCell *)cell;
        infoCell.model = model;
    } else if ([cell isKindOfClass:TNSellerProductCell.class]) {
        TNSellerProductCell *sCell = (TNSellerProductCell *)cell;
        sCell.hiddeStoreInfo = YES;
        sCell.model = model;
        @HDWeakify(self);
        sCell.reloadTableViewCallBack = ^{
            @HDStrongify(self);
            [self.collectionView successGetNewDataWithNoMoreData:!self.sellerSearchViewModel.productsHasNextPage scrollToTop:NO];
        };
    } else if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class] || [cell isKindOfClass:TNStoreInfoSkeletonCell.class] || [cell isKindOfClass:TNCategoryListSkeletonCell.class] ||
               [cell isKindOfClass:TNMicroShopProductSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.storeViewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *gModel = [TNBargainGoodModel modelWithProductModel:trueModel];
            [[HDMediator sharedInstance]
                navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId, @"source": self.storeViewModel.source, @"associatedId": self.storeViewModel.associatedId}];
        } else {
            if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
                [[HDMediator sharedInstance]
                    navigaveTinhNowProductDetailViewController:
                        @{@"productId": trueModel.productId, @"sp": self.storeViewModel.sp, @"source": self.storeViewModel.source, @"associatedId": self.storeViewModel.associatedId}];
            } else {
                [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{
                    @"productId": trueModel.productId,
                    @"funnel": HDIsStringNotEmpty(self.storeViewModel.funnel) ? self.storeViewModel.funnel : @"",
                    @"source": self.storeViewModel.source,
                    @"associatedId": self.storeViewModel.associatedId
                }];
                if (HDIsStringNotEmpty(self.storeViewModel.funnel)) {
                    [SATalkingData trackEvent:[NSString stringWithFormat:@"%@_选购商品", self.storeViewModel.funnel]];
                }
            }
        }
    } else if ([model isKindOfClass:TNSellerProductModel.class]) {
        @HDWeakify(self);
        void (^callBack)(TNSellerProductModel *) = ^(TNSellerProductModel *tempModel) {
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        };
        TNSellerProductModel *pModel = model;
        [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{
            @"productId": pModel.productId,
            @"isFromProductCenter": @"1",
            @"sellerProductModel": pModel,
            @"addOrCancelSellerProductCallBack": callBack,
            @"source": self.storeViewModel.source,
            @"associatedId": self.storeViewModel.associatedId
        }];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.storeViewModel.dataSource.count) {
        return nil;
    }
    HDTableViewSectionModel *model = self.storeViewModel.dataSource[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && model.headerModel != nil) {
        TNGoodsSortFilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)
                                                                                              forIndexPath:indexPath];
        if (!headerView) {
            headerView = [[TNGoodsSortFilterReusableView alloc] init];
        }

        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
            headerView.viewModel = self.searchViewModel;
        } else {
            headerView.viewModel = self.sellerSearchViewModel;
        }

        @HDWeakify(self);
        headerView.sortFilterBar.clickShowFilterViewCallBack = ^(CGFloat updateOffsetY) {
            @HDStrongify(self);
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + updateOffsetY) animated:NO];
            [self layoutIfNeeded];
        };
        headerView.sortFilterBar.clickFilterConditionCallBack = ^{
            @HDStrongify(self);
            [self addSkeleLayerCellModel];
            [self updateCollectionViewOffset];
        };
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.storeViewModel.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.storeViewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count) {
        return CGSizeZero;
    }
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNStoreInfoRspModel.class]) {
        TNStoreInfoRspModel *sModel = (TNStoreInfoRspModel *)model;
        return CGSizeMake(kScreenWidth, sModel.cellHeight);
    } else if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *gModel = (TNGoodsModel *)model;
        if (gModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *model = [TNBargainGoodModel modelWithProductModel:gModel];
            model.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, model.cellHeight);
        } else {
            gModel.preferredWidth = self.itemWidth;
            gModel.isNeedShowSmallShopCar = gModel.isOutOfStock ? NO : self.storeViewModel.storeInfo.isQuicklyAddToCart;
            return CGSizeMake(self.itemWidth, gModel.cellHeight);
        }
    } else if ([model isKindOfClass:TNCategoryListCellModel.class]) {
        TNCategoryListCellModel *cModel = (TNCategoryListCellModel *)model;
        return CGSizeMake(kScreenWidth, cModel.cellHeight);
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCellModel *nModel = (SANoDataCellModel *)model;
        return CGSizeMake(kScreenWidth, nModel.cellHeight);
    } else if ([model isKindOfClass:TNStoreSceneModel.class]) {
        TNStoreSceneModel *smodel = (TNStoreSceneModel *)model;
        return CGSizeMake(kScreenWidth, smodel.cellHeight);
    } else if ([model isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
        return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
    } else if ([model isKindOfClass:[TNStoreInfoSkeletonCellModel class]]) {
        TNStoreInfoSkeletonCellModel *smodel = (TNStoreInfoSkeletonCellModel *)model;
        return CGSizeMake(kScreenWidth, smodel.cellHeight);
    } else if ([model isKindOfClass:[TNCategoryListSkeletonCellModel class]]) {
        TNCategoryListSkeletonCellModel *smodel = (TNCategoryListSkeletonCellModel *)model;
        return CGSizeMake(kScreenWidth, smodel.cellHeight);
    } else if ([model isKindOfClass:[TNMicroShopDetailInfoModel class]]) {
        return CGSizeMake(kScreenWidth, kRealWidth(100));
    } else if ([model isKindOfClass:[TNSellerProductModel class]]) {
        TNSellerProductModel *sModel = model;
        return CGSizeMake(kScreenWidth, sModel.cellHeight);
    } else if ([model isKindOfClass:[TNMicroShopProductSkeletonCellModel class]]) {
        TNMicroShopProductSkeletonCellModel *smodel = (TNMicroShopProductSkeletonCellModel *)model;
        return CGSizeMake(kScreenWidth, smodel.cellHeight);
    } else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.storeViewModel.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *model = self.storeViewModel.dataSource[section];
    if (model.headerModel != nil) {
        return CGSizeMake(kScreenWidth, 45);
    } else {
        return CGSizeMake(0, 0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.storeViewModel.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *model = self.storeViewModel.dataSource[section];
    if (model.headerModel != nil) {
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
            return UIEdgeInsetsMake(kRealWidth(10), 0, kRealWidth(10), 0);
        } else {
            return UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.storeViewModel.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.storeViewModel.dataSource[section];
    if (model.headerModel != nil) {
        return kRealWidth(10);
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.storeViewModel.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.storeViewModel.dataSource[section];
    if (model.headerModel != nil) {
        return kRealWidth(10);
    }
    return 0;
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.storeViewModel.dataSource[section];
    if (sectionModel.headerModel != nil) {
        if (!HDIsArrayEmpty(sectionModel.list)) {
            id model = sectionModel.list.firstObject;
            if ([model isKindOfClass:TNGoodsModel.class] || [model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
                return 2;
            }
        }
    }
    return 1;
}

#pragma mark - lazy load
static NSUInteger const kCollectionViewCellColumn = 2;
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
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
                if (self.storeViewModel.isShowAllProductList) {
                    [self.searchViewModel loadMoreData];
                } else {
                    [self.storeViewModel requestMoreStoreSceneData];
                }
            } else {
                [self.sellerSearchViewModel loadProductsMoreData];
            }
        };
        [_collectionView registerClass:TNGoodsSortFilterReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    }
    return _collectionView;
}

/** @lazy viewmodel */
- (TNStoreViewModel *)storeViewModel {
    if (!_storeViewModel) {
        _storeViewModel = [[TNStoreViewModel alloc] init];
    }
    return _storeViewModel;
}
/** @lazy searchView */
- (TNSearchViewModel *)searchViewModel {
    if (!_searchViewModel) {
        _searchViewModel = [[TNSearchViewModel alloc] init];
    }
    return _searchViewModel;
}

/** @lazy sellSearchViewModel */
- (TNSellerSearchViewModel *)sellerSearchViewModel {
    if (!_sellerSearchViewModel) {
        _sellerSearchViewModel = [[TNSellerSearchViewModel alloc] init];
        _sellerSearchViewModel.searchSortFilterModel.sp = self.storeViewModel.sp;
        _sellerSearchViewModel.searchSortFilterModel.storeNo = self.storeViewModel.storeNo;
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
            _sellerSearchViewModel.searchSortFilterModel.searchType = TNMicroShopProductSearchTypeNone;
        } else if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
            _sellerSearchViewModel.searchSortFilterModel.searchType = TNMicroShopProductSearchTypeUser;
        }
        if ([TNGlobalData shared].seller.isSeller && HDIsStringEmpty(self.storeViewModel.sp)) {
            _sellerSearchViewModel.searchSortFilterModel.sp = [TNGlobalData shared].seller.supplierId;
        }
    }
    return _sellerSearchViewModel;
}
- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / kCollectionViewCellColumn;
}

@end
