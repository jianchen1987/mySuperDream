//
//  TNSpecialActivityContentView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSpecialActivityContentView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SANoDataCollectionViewCell.h"
#import "TNActivityCardRspModel.h"
#import "TNActivityCardWrapperCell.h"
#import "TNActivityHotSaleCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNGoodsSortFilterReusableView.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNNotificationConst.h"
#import "TNSearchSortFilterModel.h"
#import "TNSearchViewModel.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNSpecialProductTagReusableView.h"


@interface TNSpecialActivityContentView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// viewModel
@property (strong, nonatomic) TNSpeciaActivityViewModel *viewModel;
///
@property (strong, nonatomic) TNCollectionView *collectionView;
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 商品数据源
@property (strong, nonatomic) HDTableViewSectionModel *goodsSectionModel;
/// 商品数据源
@property (strong, nonatomic) HDTableViewSectionModel *hotSectionModel;
/// 广告数据源
@property (strong, nonatomic) HDTableViewSectionModel *adsSectionModel;
/// 组头原始 Y 值
//@property (nonatomic, assign) CGFloat headerOriginalY;

@property (strong, nonatomic) TNSearchViewModel *searchViewModel;
/// 热销标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *hotTagsArr;
/// 普通列表标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *normalTagsArr;
/// 热卖标签高度高度
@property (nonatomic, assign) CGFloat hotTagHeaderHeight;
/// 普通标签高度高度
@property (nonatomic, assign) CGFloat normalTagHeaderHeight;
@property (nonatomic, assign) CGFloat hotHeaderOriginalY;
@property (nonatomic, assign) CGFloat recommondHeaderOriginalY;

///
@property (strong, nonatomic) TNActivityHotSaleCell *hotSaleCell;
/// 滚动回调
@property (nonatomic, copy) void (^scrollViewDidScrollBlock)(UICollectionView *collectionView);
@end


@implementation TNSpecialActivityContentView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSUserDefaultsKeyShowHorizontalProductsStyle object:nil];
}
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel categoryId:(NSString *)categoryId {
    self.categoryId = categoryId;
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productDispalyStyleChangeNoti) name:kTNNotificationNameChangedSpecialProductsListDispalyStyle object:nil];
}
- (void)getNewData {
    if (HDIsStringEmpty(self.categoryId) || [self.categoryId isEqualToString:kCategotyRecommondItemName]) {
        self.dataSource = @[self.hotSectionModel, self.adsSectionModel, self.goodsSectionModel];
        if (!HDIsArrayEmpty(self.viewModel.recommedHotSalesProductsArr)) {
            // 热卖标签赋值
            self.hotTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.hotLableId inTagArr:self.viewModel.recommendHotTagsArr];

            TNActivityHotSaleCellModel *cellModel = [[TNActivityHotSaleCellModel alloc] init];
            cellModel.list = self.viewModel.recommedHotSalesProductsArr;
            cellModel.isQuicklyAddToCart = self.viewModel.configModel.isQuicklyAddToCart;
            self.hotSectionModel.list = @[cellModel];
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self loadHotSaleData];
        }
        if (!HDIsArrayEmpty(self.viewModel.recommedProductsArr)) {
            self.normalTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.labelId inTagArr:self.viewModel.recommendNormalTagsArr];

            [self.searchViewModel.searchResult removeAllObjects];
            [self.searchViewModel.searchResult addObjectsFromArray:self.viewModel.recommedProductsArr];
            self.goodsSectionModel.list = self.viewModel.recommedProductsArr;
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self loadListDataIsLoadMore:NO];
        }

    } else {
        [self loadHotSaleData];
        self.normalTagsArr = @[];
        [self loadListDataIsLoadMore:NO];
    }
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    self.searchViewModel.failGetNewDataCallback = ^{
        @HDStrongify(self);
        self.dataSource = @[];
        [self.collectionView failGetNewData];
    };
    self.collectionView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        [self loadListDataIsLoadMore:NO];
    };
    [self.KVOController hd_observe:self.searchViewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        if (HDIsArrayEmpty(self.searchViewModel.searchResult)) {
            SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
            self.goodsSectionModel.list = @[cellModel];
        } else {
            // 添加标签数据
            if (!HDIsArrayEmpty(self.searchViewModel.rspModel.aggs.productLabel)) {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.searchViewModel.rspModel.aggs.productLabel];
                [temp insertObject:[self.viewModel getDefaultTagModel] atIndex:0];
                if (HDIsArrayEmpty(self.normalTagsArr)) {
                    self.normalTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.labelId inTagArr:temp];
                }
            }
            self.goodsSectionModel.list = self.searchViewModel.searchResult;
        }

        if (self.searchViewModel.rspModel.pageNum == 1) {
            // 存储第一页推荐列表下的列表数据
            if ((HDIsStringEmpty(self.categoryId) || [self.categoryId isEqualToString:kCategotyRecommondItemName]) && !HDIsArrayEmpty(self.searchViewModel.searchResult)
                && HDIsArrayEmpty(self.viewModel.recommedProductsArr)) {
                self.viewModel.recommedProductsArr = self.searchViewModel.searchResult;
                // 只记录一次
                if (HDIsArrayEmpty(self.viewModel.recommendNormalTagsArr)) {
                    self.viewModel.recommendNormalTagsArr = self.normalTagsArr.copy;
                }
                // 只记录第一页的情况
                self.viewModel.hasNextPage = self.searchViewModel.rspModel.hasNextPage;
            }
            [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage scrollToTop:NO];

        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
        }
        self.searchViewModel.isNeedUpdateContentOffset = NO; // 重置筛选条件
    }];
}
- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark -商品展示样式更改通知事件
- (void)productDispalyStyleChangeNoti {
    [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage scrollToTop:NO];
}
#pragma mark - public method  重新加载数据
- (void)refreshData {
    [self scrollerToTop];
    self.searchViewModel.searchSortFilterModel.specialId = self.viewModel.activityId;
    self.searchViewModel.searchSortFilterModel.categoryId = self.categoryId;
    self.dataSource = @[];
    [self loadHotSaleData];
    self.normalTagsArr = @[];
    [self loadListDataIsLoadMore:NO];
}
#pragma mark - setter
- (void)setHotTagsArr:(NSArray<TNGoodsTagModel *> *)hotTagsArr {
    _hotTagsArr = hotTagsArr;
    self.hotTagHeaderHeight = [self.viewModel getSpecialTagsHeightByTagsArr:hotTagsArr];
}
- (void)setNormalTagsArr:(NSArray<TNGoodsTagModel *> *)normalTagsArr {
    _normalTagsArr = normalTagsArr;
    self.normalTagHeaderHeight = [self.viewModel getSpecialTagsHeightByTagsArr:normalTagsArr];
}
#pragma mark - 刷新广告位
- (void)reloadAdsData:(TNActivityCardRspModel *)rspModel {
    if (!HDIsArrayEmpty(rspModel.list)) {
        self.adsSectionModel.list = @[rspModel];
    }
    [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
}
#pragma mark - 加载热销数据
- (void)loadHotSaleData {
    if (HDIsStringEmpty(self.searchViewModel.searchSortFilterModel.specialId)) {
        return;
    }
    @HDWeakify(self);
    [self.searchViewModel querySpecialActivityHotListDataSuccess:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        // 添加标签数据
        if (!HDIsArrayEmpty(rspModel.aggs.productLabel)) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:rspModel.aggs.productLabel];
            [temp insertObject:[self.viewModel getDefaultTagModel] atIndex:0];
            // 标签数据只取一次
            if (HDIsArrayEmpty(self.hotTagsArr)) {
                self.hotTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.hotLableId inTagArr:temp];
            }
        }
        if (!HDIsArrayEmpty(rspModel.list)) {
            TNActivityHotSaleCellModel *cellModel = [[TNActivityHotSaleCellModel alloc] init];
            cellModel.list = rspModel.list;
            cellModel.isQuicklyAddToCart = self.viewModel.configModel.isQuicklyAddToCart;
            self.hotSectionModel.list = @[cellModel];
        }

        // 存储推荐热销数据  供其它样式切换使用
        if (HDIsStringEmpty(self.categoryId)) {
            self.viewModel.recommedHotSalesProductsArr = rspModel.list;
            if (HDIsArrayEmpty(self.viewModel.recommendHotTagsArr)) {
                self.viewModel.recommendHotTagsArr = self.hotTagsArr.copy;
            }
        }
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
    } failure:nil];
}
#pragma mark - 加载列表数据
- (void)loadListDataIsLoadMore:(BOOL)isLoadMore {
    if (HDIsStringEmpty(self.categoryId) || [self.categoryId isEqualToString:kCategotyRecommondItemName]) {
        self.searchViewModel.specificActivityHotType = 2;
    } else {
        self.searchViewModel.specificActivityHotType = 0;
    }
    if (!isLoadMore) {
        [self addSkeleLayerCellModel];
    }
    if (HDIsStringEmpty(self.searchViewModel.searchSortFilterModel.specialId)) {
        return;
    }
    if (!isLoadMore) {
        [self.searchViewModel requestNewData];
    } else {
        [self.searchViewModel loadMoreData];
    }
}
#pragma mark - 添加骨架数据
- (void)addSkeleLayerCellModel {
    NSMutableArray<TNHomeChoicenessSkeletonCellModel *> *skeletonModelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeletonModelArray addObject:model];
    }
    self.goodsSectionModel.list = skeletonModelArray;
    self.dataSource = @[self.hotSectionModel, self.adsSectionModel, self.goodsSectionModel];
    [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
}
#pragma mark - 检测当前的偏移量 是否需要显示置顶按钮
- (void)checkShowScollTopBtn {
    CGFloat maxY = kScreenHeight - kRealWidth(236) - kRealWidth(40);
    BOOL isShow = NO;
    if (self.collectionView.contentOffset.y > maxY) {
        isShow = YES;
    }
    if (self.scrollerShowTopBtnCallBack) {
        self.scrollerShowTopBtnCallBack(isShow);
    }
}
#pragma mark 是否可以滚动
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        [self scrollerToTop];
    }
}
#pragma mark 设置偏移量到顶部
- (void)scrollerToTop {
    [self.collectionView setContentOffset:CGPointZero];
}
#pragma mark - 设置collectionView偏移位置
//- (void)updateCollectionViewOffset {
//    [self setHeaderOriginalY];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.collectionView setContentOffset:CGPointMake(0, self.headerOriginalY) animated:YES];
//    });
//}
- (void)setHeaderOriginalY {
    HDCollectionViewVerticalLayout *flowLayout = (HDCollectionViewVerticalLayout *)self.collectionView.collectionViewLayout;
    if (flowLayout.headerAttributesArray.count > 0) {                                                              // 只有一个组头
        if (!HDIsArrayEmpty(self.hotSectionModel.list) && [self.dataSource containsObject:self.hotSectionModel]) { // 只取一次原始位置的高度  组头的位置可能为0
            if (self.hotHeaderOriginalY <= 0) {
                UICollectionViewLayoutAttributes *attriture = flowLayout.headerAttributesArray.firstObject;
                self.hotHeaderOriginalY = attriture.frame.origin.y;
            }
        }
        if (!HDIsArrayEmpty(self.goodsSectionModel.list) && [self.dataSource containsObject:self.goodsSectionModel]) { // 只取一次原始位置的高度  组头的位置可能为0
            if (self.recommondHeaderOriginalY <= 0) {
                UICollectionViewLayoutAttributes *attriture = flowLayout.headerAttributesArray.lastObject;
                self.recommondHeaderOriginalY = attriture.frame.origin.y;
            }
        }
    }
}
/// 设置偏移量位置到头部
- (void)scrollerToIndexPath:(NSInteger)section {
    HDCollectionViewVerticalLayout *flowLayout = (HDCollectionViewVerticalLayout *)self.collectionView.collectionViewLayout;
    if (flowLayout.headerAttributesArray.count > section) {
        UICollectionViewLayoutAttributes *attributes = flowLayout.headerAttributesArray[section];
        CGFloat headerY = attributes.frame.origin.y;
        if (self.collectionView.contentOffset.y < headerY) {
            [self.collectionView setContentOffset:CGPointMake(0, headerY)];
        }
    }
}
/// 条件筛选的时候 按热卖和推荐吸顶
- (void)setCollectionViewSectionContentOffsetByRecommond:(BOOL)isRecommond {
    if (isRecommond) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(0, self.recommondHeaderOriginalY) animated:YES];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(0, self.hotHeaderOriginalY) animated:YES];
        });
    }
}
#pragma mark - CollectionDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setHeaderOriginalY];
    if (self.canScroll) {
        [self checkShowScollTopBtn];
        if (scrollView.contentOffset.y <= 0) {
            self.canScroll = NO;
            [self scrollerToTop];
            if (self.scrollerViewScrollerToTopCallBack) {
                self.scrollerViewScrollerToTopCallBack();
            }
        }
    } else {
        self.canScroll = NO;
    }

    !self.hotSaleCell.scrollViewDidScrollBlock ?: self.hotSaleCell.scrollViewDidScrollBlock(self.collectionView);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollerViewWillBegainDraggingCallBack) {
        self.scrollerViewWillBegainDraggingCallBack();
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollerViewDidEndDragCallBack) {
        self.scrollerViewDidEndDragCallBack();
    }
}

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
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (indexPath.row >= model.list.count) {
        return tmp;
    }
    id rowModel = model.list[indexPath.row];
    if (model == self.goodsSectionModel) {
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            TNGoodsCollectionViewCell *cell = [TNGoodsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
            cell.displayStyle = self.viewModel.showHorizontalStyle ? TNGoodsDisplayStyleHorizontal : TNGoodsDisplayStyleWaterFallsFlow;
            cell.isFromSpecialActivityController = true;
            return cell;
        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
            return cell;
        } else if ([rowModel isKindOfClass:[SANoDataCellModel class]]) {
            SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
            return cell;
        }
    } else if (model == self.hotSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityHotSaleCellModel class]]) {
            TNActivityHotSaleCell *cell = [TNActivityHotSaleCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNActivityHotSaleCell.class)];
            return cell;
        }
    } else if (model == self.adsSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityCardRspModel class]]) {
            TNActivityCardWrapperCell *cell = [TNActivityCardWrapperCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNActivityCardWrapperCell.class)];
            return cell;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return;
    }
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (indexPath.row >= model.list.count) {
        return;
    }
    id rowModel = model.list[indexPath.row];
    if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
        TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
        TNGoodsModel *trueModel = (TNGoodsModel *)rowModel;
        trueModel.isNeedShowSmallShopCar = trueModel.isOutOfStock ? NO : self.viewModel.configModel.isQuicklyAddToCart;
        trueModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
        goodCell.model = trueModel;
        @HDWeakify(self);
        goodCell.clickStoreTrackEventCallBack = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击商品店铺入口"]];
        };
        goodCell.addShopCartTrackEventCallBack = ^(NSString *_Nonnull productId) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_加入购物车"] label:@"" parameters:@{@"商品ID": productId}];
        };
        // 记录曝光
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:trueModel.productId];

    } else if ([cell isKindOfClass:TNActivityHotSaleCell.class]) {
        TNActivityHotSaleCell *hotSaleCell = (TNActivityHotSaleCell *)cell;
        hotSaleCell.cellModel = (TNActivityHotSaleCellModel *)rowModel;
        if (!self.hotSaleCell) {
            self.hotSaleCell = hotSaleCell;
        }
    } else if ([cell isKindOfClass:TNActivityCardWrapperCell.class]) {
        TNActivityCardWrapperCell *cardCell = (TNActivityCardWrapperCell *)cell;
        cardCell.cellModel = (TNActivityCardRspModel *)rowModel;
    } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
        SANoDataCollectionViewCell *noDataCell = (SANoDataCollectionViewCell *)cell;
        noDataCell.model = (SANoDataCellModel *)rowModel;
    } else if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = model;
        [[HDMediator sharedInstance]
            navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId, @"funnel": HDIsStringNotEmpty(self.viewModel.funnel) ? self.viewModel.funnel : @""}];
        if (HDIsStringNotEmpty(self.viewModel.funnel)) {
            [SATalkingData trackEvent:[NSString stringWithFormat:@"%@_选购商品", self.viewModel.funnel]];
        }

        [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击商品_区分商品ID"] label:@"" parameters:@{@"商品ID": trueModel.productId}];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (indexPath.row >= model.list.count) {
        return CGSizeZero;
    }
    id rowModel = model.list[indexPath.row];
    if (model == self.goodsSectionModel) {
        CGFloat itemWidth = (kScreenWidth - kRealWidth(40)) / 2;
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            if (self.viewModel.showHorizontalStyle) {
                return CGSizeMake(kScreenWidth, kRealWidth(160));
            } else {
                TNGoodsModel *gModel = (TNGoodsModel *)rowModel;
                gModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
                gModel.isNeedShowSmallShopCar = gModel.isOutOfStock ? NO : self.viewModel.configModel.isQuicklyAddToCart;
                gModel.preferredWidth = itemWidth;
                return CGSizeMake(itemWidth, gModel.cellHeight);
            }

        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            return CGSizeMake(itemWidth, ChoicenessSkeletonCellHeight);
        } else if ([rowModel isKindOfClass:[SANoDataCellModel class]]) {
            SANoDataCellModel *model = (SANoDataCellModel *)rowModel;
            return CGSizeMake(kScreenWidth, model.cellHeight);
        }
    } else if (model == self.hotSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityHotSaleCellModel class]]) {
            TNActivityHotSaleCellModel *cellModel = (TNActivityHotSaleCellModel *)rowModel;
            return CGSizeMake(kScreenWidth, cellModel.cellHeight);
        }
    } else if (model == self.adsSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityCardRspModel class]]) {
            TNActivityCardRspModel *cellModel = (TNActivityCardRspModel *)rowModel;
            return CGSizeMake(kScreenWidth, cellModel.cellHeight);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSectionModel) {
        CGFloat height = kRealWidth(45);
        if (!HDIsArrayEmpty(self.normalTagsArr)) {
            height += self.normalTagHeaderHeight;
        }
        return CGSizeMake(kScreenWidth, height);
    }
    if (sectionModel == self.hotSectionModel && !HDIsArrayEmpty(self.hotSectionModel.list)) {
        CGFloat height = 0;
        if (!HDIsArrayEmpty(self.hotTagsArr)) {
            height += self.hotTagHeaderHeight;
        }
        return CGSizeMake(kScreenWidth, height);
    } else {
        return CGSizeZero;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return nil;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (sectionModel == self.goodsSectionModel) {
            TNGoodsSortFilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                           withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)
                                                                                                  forIndexPath:indexPath];
            if (!headerView) {
                headerView = [[TNGoodsSortFilterReusableView alloc] init];
            }
            headerView.viewModel = self.searchViewModel;
            headerView.contentWidth = kScreenWidth;
            headerView.tagArr = self.normalTagsArr;
            headerView.showChangeProductDisplayStyleBtn = YES;
            [headerView.sortFilterBar hideRightFilterBtn];
            @HDWeakify(self);
            headerView.sortFilterBar.clickFilterConditionCallBack = ^{
                @HDStrongify(self);
                [self addSkeleLayerCellModel];
                [self setCollectionViewSectionContentOffsetByRecommond:YES];
            };
            headerView.changeProductDisplayStyleCallBack = ^{
                @HDStrongify(self);
                [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击商品样式切换按钮"]];
            };
            headerView.tagClickCallBack = ^(TNGoodsTagModel *_Nonnull model) {
                @HDStrongify(self);
                self.searchViewModel.searchSortFilterModel.labelId = model.tagId;
                self.normalTagsArr = [self.viewModel processSelectedTagByTagId:model.tagId inTagArr:self.normalTagsArr];
                [self loadListDataIsLoadMore:NO];
                [self setCollectionViewSectionContentOffsetByRecommond:YES];
            };
            headerView.dropSpecialProductTagClickCallBack = ^{
                @HDStrongify(self);
                [self scrollerToIndexPath:1];
            };
            return headerView;
        } else if (sectionModel == self.hotSectionModel && !HDIsArrayEmpty(self.hotTagsArr) && !HDIsArrayEmpty(self.hotSectionModel.list)) {
            TNSpecialProductTagReusableView *headerView = [TNSpecialProductTagReusableView headerWithCollectionView:collectionView forIndexPath:indexPath];
            headerView.contentWidth = kScreenWidth;
            headerView.tagArr = self.hotTagsArr;
            @HDWeakify(self);
            headerView.tagClickCallBack = ^(TNGoodsTagModel *_Nonnull model) {
                @HDStrongify(self);
                self.searchViewModel.searchSortFilterModel.hotLableId = model.tagId;
                self.hotTagsArr = [self.viewModel processSelectedTagByTagId:model.tagId inTagArr:self.hotTagsArr];
                [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage scrollToTop:NO];
                [self loadHotSaleData];
                [self setCollectionViewSectionContentOffsetByRecommond:NO];
            };
            headerView.dropSpecialProductTagClickCallBack = ^{
                @HDStrongify(self);
                [self scrollerToIndexPath:0];
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
    if (section >= self.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        if (!HDIsArrayEmpty(model.list)) {
            id rowModel = model.list.firstObject;
            if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
                return self.viewModel.showHorizontalStyle ? UIEdgeInsetsZero : UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(20), kRealWidth(15));
            } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
                return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(20), kRealWidth(15));
            }
        }
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        id rowModel = model.list.firstObject;
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            return self.viewModel.showHorizontalStyle ? 0 : kRealWidth(10);
        }
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        id rowModel = model.list.firstObject;
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            return self.viewModel.showHorizontalStyle ? 0 : kRealWidth(10);
        }
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
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        if (!HDIsArrayEmpty(model.list)) {
            id rowModel = model.list.firstObject;
            if ([rowModel isKindOfClass:[SANoDataCellModel class]]) {
                return 1;
            } else if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
                return self.viewModel.showHorizontalStyle ? 1 : 2;
            } else {
                return 2;
            }
        }
    }
    return 1;
}
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.header_suspension = YES;
        flowLayout.delegate = self;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = false;
        _collectionView.needRefreshFooter = true;
        _collectionView.needShowErrorView = true;
        _collectionView.needShowNoDataView = false;
        _collectionView.needRecognizeSimultaneously = NO;
        _collectionView.mj_footer.hidden = YES;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"placeholder_network_error";
        model.title = SALocalizedString(@"network_error", @"网络开小差啦");
        model.needRefreshBtn = YES;
        _collectionView.placeholderViewModel = model;
        @HDWeakify(self);
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self loadListDataIsLoadMore:NO];
        };
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadListDataIsLoadMore:YES];
        };
        [_collectionView registerClass:TNGoodsSortFilterReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNGoodsSortFilterReusableView.class)];
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerClass:TNSpecialProductTagReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNSpecialProductTagReusableView.class)];
    }
    return _collectionView;
}
/** @lazy goodsSectionModel */
- (HDTableViewSectionModel *)goodsSectionModel {
    if (!_goodsSectionModel) {
        _goodsSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _goodsSectionModel;
}
/** @lazy hotSectionModel */
- (HDTableViewSectionModel *)hotSectionModel {
    if (!_hotSectionModel) {
        _hotSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _hotSectionModel;
}
/** @lazy adsSectionModel */
- (HDTableViewSectionModel *)adsSectionModel {
    if (!_adsSectionModel) {
        _adsSectionModel = [[HDTableViewSectionModel alloc] init];
        if (!HDIsArrayEmpty(self.viewModel.activityCardRspModel.list)) {
            _adsSectionModel.list = @[self.viewModel.activityCardRspModel];
        }
    }
    return _adsSectionModel;
}

/** @lazy searchViewModel */
- (TNSearchViewModel *)searchViewModel {
    if (!_searchViewModel) {
        _searchViewModel = [[TNSearchViewModel alloc] init];
        _searchViewModel.searchSortFilterModel.specialId = self.viewModel.activityId;
        _searchViewModel.searchSortFilterModel.categoryId = self.categoryId;
        _searchViewModel.searchSortFilterModel.rtnLabel = YES;
    }
    return _searchViewModel;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillAppear {
    [self checkShowScollTopBtn];
}

@end
