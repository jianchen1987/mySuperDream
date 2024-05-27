//
//  TNSearchResultView.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchResultView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SACollectionViewWaterFlowLayout.h"
#import "SANoDataCellModel.h"
#import "SANoDataCollectionViewCell.h"
#import "TNBargainGoodsCell.h"
#import "TNCategoryListCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNGoodsSortFilterReusableView.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHotSalesListCell.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterBar.h"
#import "TNSearchSortFilterModel.h"
#import "TNSearchViewModel.h"
#import "UICollectionViewLeftAlignLayout.h"
#import <HDUIKit/HDUIKit.h>


@interface TNSearchResultView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// collection
@property (nonatomic, strong) TNCollectionView *collectionView;
/// viewmodel
@property (nonatomic, strong) TNSearchViewModel *viewModel;
/// dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 组头原始 Y 值
@property (nonatomic, assign) CGFloat headerOriginalY;
/// 筛选栏  这个筛选栏  用于直接从搜索进来的情况
@property (nonatomic, strong) TNSearchSortFilterBar *sortFilterBar;
/// 分类数据源
@property (nonatomic, strong) HDTableViewSectionModel *categorySection;
/// 热卖数据源
@property (nonatomic, strong) HDTableViewSectionModel *hotSalesSection;
/// 商品数据源
@property (nonatomic, strong) HDTableViewSectionModel *goodsSection;
/// 是否显示置顶的筛选栏
@property (nonatomic, assign) BOOL isShowFilterBar;
/// 搜索范围  默认全部商城
@property (nonatomic, assign) TNSearchScopeType scopeType;
@end


@implementation TNSearchResultView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel scopeType:(TNSearchScopeType)scopeType {
    self.viewModel = viewModel;
    self.scopeType = scopeType;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.isShowFilterBar = HDIsArrayEmpty(self.viewModel.categoryList);
    //如果没有分类数据 直接将搜索栏目固定在上方
    if (self.isShowFilterBar) {
        [self addSubview:self.sortFilterBar];
        // 只显示商品数据
        self.dataSource = @[self.goodsSection];
        if (HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.brandId)) {
            [self.sortFilterBar hideRightFilterBtn]; //品牌搜索  隐藏右边筛选按钮
        }
    } else {
        // 点击分类来的  需要显示分类 热卖
        TNCategoryListCellModel *cellModel = [[TNCategoryListCellModel alloc] init];
        cellModel.list = self.viewModel.categoryList;
        //上层带过来的数据  有默认选中的
        for (NSInteger i = 0; i < cellModel.list.count; i++) {
            TNCategoryModel *oModel = cellModel.list[i];
            if ([oModel.menuId isEqualToString:self.viewModel.searchSortFilterModel.categoryId]) {
                oModel.isSelected = true;
                //滚动到选中位置
                cellModel.isNeedScrollerToSelected = true;
                cellModel.scrollerToIndex = i;
                break;
            }
        }
        self.categorySection.list = @[cellModel];
        self.dataSource = @[self.categorySection, self.hotSalesSection, self.goodsSection];
    }
    [self addSubview:self.collectionView];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    if (self.scopeType == TNSearchScopeTypeAllMall) {
        [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            [self updateGoodSectionData];
        }];
    } else {
        //刷新专题 店铺等数据
        [self.KVOController hd_observe:self.viewModel keyPath:@"specificRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            [self updateGoodSectionData];
        }];
    }

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"hotGoodsList" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                               @HDStrongify(self);
                               TNHotSalesListCellModel *cellModel = [[TNHotSalesListCellModel alloc] init];
                               cellModel.list = [NSArray arrayWithArray:self.viewModel.hotGoodsList];
                               self.hotSalesSection.list = @[cellModel];
                               if (self.viewModel.rspModel.pageNum == 1) {
                                   [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.rspModel.hasNextPage];
                               } else {
                                   [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.rspModel.hasNextPage];
                               }
                           }];
}
/// 更新商品列表数据
- (void)updateGoodSectionData {
    if (!HDIsArrayEmpty(self.viewModel.searchResult)) {
        self.goodsSection.list = [NSArray arrayWithArray:self.viewModel.searchResult];
    } else {
        SANoDataCellModel *cellModel = SANoDataCellModel.new;
        if (self.scopeType == TNSearchScopeTypeAllMall) {
            cellModel.descText = TNLocalizedString(@"YE60b1rg", @"未搜到相关商品，请换个关键字搜索");
        } else {
            cellModel.descText = TNLocalizedString(@"2IEOpBIr", @"未搜到相关商品，可查看商城商品");
        }
        //        cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
        self.goodsSection.list = @[cellModel];
    }
    if (self.viewModel.rspModel.pageNum == 1) {
        if (!self.isShowFilterBar && self.viewModel.isNeedUpdateContentOffset) {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.rspModel.hasNextPage];
            [self updateCollectionViewOffset];
            self.viewModel.isNeedUpdateContentOffset = NO;
        } else {
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.rspModel.hasNextPage];
        }
    } else {
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.rspModel.hasNextPage];
    }
}
- (void)updateConstraints {
    if (self.isShowFilterBar) {
        [self.sortFilterBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(45);
        }];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        if (self.isShowFilterBar) {
            make.top.equalTo(self.sortFilterBar.mas_bottom);
        } else {
            make.top.equalTo(self);
        }
    }];
    [super updateConstraints];
}
//设置偏移量
- (void)updateCollectionViewOffset {
    if (self.collectionView.contentOffset.y > self.headerOriginalY) {
        [self.collectionView setContentOffset:CGPointMake(0, self.headerOriginalY) animated:NO];
    }
}
#pragma mark - Data
- (void)requestNewData {
    [self requestHotSalesData];
    [self requestGoodListData];
}
///搜索商品列表数据
- (void)requestGoodListData {
    [self addGoodListSkeleLayerCellModel];
    [self.viewModel requestNewData];
}
- (void)requestHotSalesData {
    if (!HDIsArrayEmpty(self.viewModel.categoryList) && HDIsStringEmpty(self.viewModel.searchSortFilterModel.storeNo)) { //店铺分类结果页不展示热销数据
        [self.viewModel queryHotGoodsList];                                                                              //分类列表搜索的要先请求热销商品数据
    }
}

#pragma mark - 重置页面
- (void)resetData {
    [self.viewModel.searchResult removeAllObjects];
}

///上送搜索页滚动商品埋点
- (void)trackScrollProductsExposure {
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:self.viewModel.eventProperty];
}

#pragma mark - 添加骨架屏
- (void)addGoodListSkeleLayerCellModel {
    NSMutableArray *skeleArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeleArray addObject:model];
    }
    self.goodsSection.list = [NSArray arrayWithArray:skeleArray];
    [self.collectionView successLoadMoreDataWithNoMoreData:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isShowFilterBar) {
        HDCollectionViewVerticalLayout *flowLayout = (HDCollectionViewVerticalLayout *)self.collectionView.collectionViewLayout;
        if (flowLayout.headerAttributesArray.count > 0) { //只有一个组头
            if (self.headerOriginalY <= 0) {              //只取一次原始位置的高度
                UICollectionViewLayoutAttributes *attriture = flowLayout.headerAttributesArray.firstObject;
                self.headerOriginalY = attriture.frame.origin.y;
            }
        }
    }
}
#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    if (indexPath.section >= self.dataSource.count) {
        return tmp;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.categorySection) {
        TNCategoryListCell *cell = [TNCategoryListCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNCategoryListCell.class)];
        return cell;
    } else if (sectionModel == self.hotSalesSection) {
        TNHotSalesListCell *cell = [TNHotSalesListCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNHotSalesListCell.class)];
        return cell;
    } else if (sectionModel == self.goodsSection) {
        if (indexPath.row >= sectionModel.list.count) {
            return tmp;
        }
        id model = sectionModel.list[indexPath.row];
        if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsModel *gModel = (TNGoodsModel *)model;
            if (gModel.productType == TNProductTypeBargain) {
                TNBargainGoodsCell *cell = [TNBargainGoodsCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainGoodsCell.class)];
                return cell;
            } else {
                TNGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class) forIndexPath:indexPath];
                gModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
                return cell;
            }
        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
            return cell;
        } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
            TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
            return cell;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count) {
        return;
    }
    id model = sectionModel.list[indexPath.row];

    if ([cell isKindOfClass:TNCategoryListCell.class]) {
        TNCategoryListCell *categoryCell = (TNCategoryListCell *)cell;
        @HDWeakify(self);
        categoryCell.categorySelectedCallBack = ^(TNCategoryModel *_Nonnull cModel) {
            @HDStrongify(self);
            self.viewModel.searchSortFilterModel.categoryId = cModel.menuId;
            [self requestNewData];
        };
        categoryCell.model = model;
    } else if ([cell isKindOfClass:TNHotSalesListCell.class]) {
        TNHotSalesListCell *hotSaleCell = (TNHotSalesListCell *)cell;
        hotSaleCell.model = model;
    } else if ([cell isKindOfClass:TNBargainGoodsCell.class]) {
        TNBargainGoodsCell *bargainGoodCell = (TNBargainGoodsCell *)cell;
        bargainGoodCell.model = [TNBargainGoodModel modelWithProductModel:model];
    } else if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
        TNGoodsModel *goodModel = model;
        TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
        goodCell.model = goodModel;
        //记录曝光
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:goodModel.productId];
    } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
        SANoDataCollectionViewCell *noDataCell = (SANoDataCollectionViewCell *)cell;
        noDataCell.model = model;
    } else if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.goodsSection) {
        id model = sectionModel.list[indexPath.row];
        if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsModel *trueModel = (TNGoodsModel *)model;
            if (trueModel.productType == TNProductTypeBargain) {
                TNBargainGoodModel *gModel = [TNBargainGoodModel modelWithProductModel:trueModel];
                [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId}];
            } else {
                [[HDMediator sharedInstance]
                    navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId, @"funnel": HDIsStringNotEmpty(self.viewModel.funnel) ? self.viewModel.funnel : @""}];
            }
            if (HDIsStringNotEmpty(self.viewModel.funnel)) {
                [SATalkingData trackEvent:[NSString stringWithFormat:@"%@_选购商品", self.viewModel.funnel]];
            }
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.categorySection) {
        TNCategoryListCellModel *cellModel = sectionModel.list[indexPath.row];
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if (sectionModel == self.hotSalesSection) {
        TNHotSalesListCellModel *cellModel = sectionModel.list[indexPath.row];
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if (sectionModel == self.goodsSection) {
        if (indexPath.row >= sectionModel.list.count) {
            return CGSizeZero;
        }
        id model = sectionModel.list[indexPath.row];
        if ([model isKindOfClass:TNGoodsModel.class]) {
            TNGoodsModel *gModel = (TNGoodsModel *)model;
            if (gModel.productType == TNProductTypeBargain) {
                TNBargainGoodModel *bModel = [TNBargainGoodModel modelWithProductModel:gModel];
                bModel.preferredWidth = self.itemWidth;
                return CGSizeMake(self.itemWidth, bModel.cellHeight);
            } else {
                gModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
                gModel.preferredWidth = self.itemWidth;
                return CGSizeMake(self.itemWidth, gModel.cellHeight);
            }

        } else if ([model isKindOfClass:SANoDataCellModel.class]) {
            SANoDataCellModel *nModel = (SANoDataCellModel *)model;
            return CGSizeMake(kScreenWidth, nModel.cellHeight);
        } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
            return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSection && self.isShowFilterBar == false) {
        return CGSizeMake(kScreenWidth, 45);
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return nil;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && sectionModel == self.goodsSection) {
        TNGoodsSortFilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)
                                                                                              forIndexPath:indexPath];
        if (!headerView) {
            headerView = [[TNGoodsSortFilterReusableView alloc] init];
        }
        headerView.viewModel = self.viewModel;
        @HDWeakify(self);
        headerView.sortFilterBar.clickShowFilterViewCallBack = ^(CGFloat updateOffsetY) {
            @HDStrongify(self);
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + updateOffsetY) animated:NO];
            [self layoutIfNeeded];
        };
        headerView.sortFilterBar.clickFilterConditionCallBack = ^{
            @HDStrongify(self);
            [self addGoodListSkeleLayerCellModel];
            [self updateCollectionViewOffset];
        };
        return headerView;
    } else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.hotSalesSection && sectionModel.list.count > 0) {
        TNHotSalesListCellModel *cellModel = sectionModel.list.firstObject;
        if (!HDIsArrayEmpty(cellModel.list)) {
            return UIEdgeInsetsMake(kRealWidth(10), 0, 0, 0);
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    } else if (sectionModel == self.goodsSection) {
        return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(10), kRealWidth(15));
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSection) {
        return kRealWidth(10);
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSection) {
        return kRealWidth(10);
    }
    return 0;
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 1;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSection) {
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
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadMoreData];
        };
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.title = TNLocalizedString(@"tn_page_nodata_title", @"No more results");
        placeHolder.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolder.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolder.image = @"tinhnow-ic-search-empty";
        placeHolder.imageSize = CGSizeMake(218, 131);
        _collectionView.placeholderViewModel = placeHolder;
        [_collectionView registerClass:TNGoodsSortFilterReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)];
        [_collectionView registerClass:[TNGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    }
    return _collectionView;
}

- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / kCollectionViewCellColumn;
}
- (TNSearchSortFilterBar *)sortFilterBar {
    if (!_sortFilterBar) {
        _sortFilterBar = [[TNSearchSortFilterBar alloc] init];
        _sortFilterBar.viewModel = self.viewModel;
        @HDWeakify(self);
        _sortFilterBar.clickFilterConditionCallBack = ^{
            @HDStrongify(self);
            [self addGoodListSkeleLayerCellModel];
            [self updateCollectionViewOffset];
        };
    }
    return _sortFilterBar;
}
- (HDTableViewSectionModel *)categorySection {
    if (!_categorySection) {
        _categorySection = [[HDTableViewSectionModel alloc] init];
        _categorySection.list = @[];
    }
    return _categorySection;
}
- (HDTableViewSectionModel *)hotSalesSection {
    if (!_hotSalesSection) {
        _hotSalesSection = [[HDTableViewSectionModel alloc] init];
        _hotSalesSection.list = @[];
    }
    return _hotSalesSection;
}
- (HDTableViewSectionModel *)goodsSection {
    if (!_goodsSection) {
        _goodsSection = [[HDTableViewSectionModel alloc] init];
        _goodsSection.list = @[];
    }
    return _goodsSection;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillDisappear {
    //上送滚动商品埋点
    [self trackScrollProductsExposure];
}
@end
