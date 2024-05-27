//
//  TNVerticalRightProductView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNVerticalRightProductView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SANoDataCollectionViewCell.h"
#import "TNActivityCardRspModel.h"
#import "TNActivityCardWrapperCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNGoodsSortFilterReusableView.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNNotificationConst.h"
#import "TNSearchViewModel.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNSpecialProductTagReusableView.h"
#import "TNVerticalTooBarView.h"
#import "TNVertocalStyleTextCell.h"


@interface TNVerticalRightProductView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
@property (nonatomic, strong) TNSpeciaActivityViewModel *viewModel;
@property (strong, nonatomic) TNSearchViewModel *searchViewModel;
@property (strong, nonatomic) TNCollectionView *collectionView;
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 商品数据源
@property (strong, nonatomic) HDTableViewSectionModel *goodsSectionModel;
/// 商品数据源
@property (strong, nonatomic) HDTableViewSectionModel *hotSectionModel;
/// 广告数据源
@property (strong, nonatomic) HDTableViewSectionModel *adsSectionModel;
/// 热卖文本
@property (strong, nonatomic) HDTableViewSectionModel *hotSaleTextSectionModel;
/// 推荐文本
@property (strong, nonatomic) HDTableViewSectionModel *recommendTextSectionModel;
/// 头部视图
@property (strong, nonatomic) TNVerticalTooBarView *toolBarView;
/// 是否有热销数据
@property (nonatomic, assign) BOOL hasHotSalesData;
/// 滑动到了推荐
@property (nonatomic, assign) BOOL isScrollToRecommend;
/// 最后一次滑动的 列表位置  用于与父视图滚动的时候保留位置
@property (nonatomic, assign) CGFloat lastContentOffetY;
/// 推荐类目位置
@property (assign, nonatomic) CGFloat recommedTextSectionOffsetY;
/// 是否是手动点击到推荐列表
@property (nonatomic, assign) BOOL isManualClickRecommd;
/// 热销标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *hotTagsArr;
/// 普通列表标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *normalTagsArr;
/// 热卖标签高度高度
@property (nonatomic, assign) CGFloat hotTagHeaderHeight;
/// 普通标签高度高度
@property (nonatomic, assign) CGFloat normalTagHeaderHeight;
@end


@implementation TNVerticalRightProductView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.toolBarView];
    [self addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productDispalyStyleChangeNoti) name:kTNNotificationNameChangedSpecialProductsListDispalyStyle object:nil];
    self.recommedTextSectionOffsetY = kScreenWidth * 10;
}
- (void)getNewData {
    _searchViewModel.searchSortFilterModel.specialId = self.viewModel.activityId;
    _searchViewModel.searchSortFilterModel.categoryId = [self.categoryId isEqualToString:kCategotyRecommondItemName] ? @"" : self.categoryId;
    if ([self.categoryId isEqualToString:kCategotyRecommondItemName] || HDIsStringEmpty(self.categoryId)) {
        // 推荐分类
        self.searchViewModel.searchSortFilterModel.categoryId = @""; // 置空
        self.dataSource = @[self.hotSectionModel, self.goodsSectionModel];
        // 热卖数据
        if (!HDIsArrayEmpty(self.viewModel.recommedHotSalesProductsArr)) {
            self.dataSource = @[self.hotSaleTextSectionModel, self.hotSectionModel, self.recommendTextSectionModel, self.goodsSectionModel];
            self.hotSectionModel.list = self.viewModel.recommedHotSalesProductsArr;
            self.hotTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.hotLableId inTagArr:self.viewModel.recommendHotTagsArr];
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
            [self updateHotSalesUI];
        } else {
            [self loadHotSaleData];
        }
        // 拉取列表数据
        if (!HDIsArrayEmpty(self.viewModel.recommedProductsArr)) {
            [self.searchViewModel.searchResult removeAllObjects];
            [self.searchViewModel.searchResult addObjectsFromArray:self.viewModel.recommedProductsArr];
            self.goodsSectionModel.list = self.viewModel.recommedProductsArr;
            self.normalTagsArr = [self.viewModel processSelectedTagByTagId:self.searchViewModel.searchSortFilterModel.labelId inTagArr:self.viewModel.recommendNormalTagsArr];
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self loadListDataIsLoadMore:NO];
        }

    } else if ([self.categoryId isEqualToString:kCategotyThemeVenueItemName]) {
        // 设置
        self.dataSource = @[self.adsSectionModel];
        if (HDIsArrayEmpty(self.adsSectionModel.list)) {
            self.adsSectionModel.list = @[self.viewModel.activityCardRspModel];
        }
        [self updateHotSalesUI];
        [self.collectionView successGetNewDataWithNoMoreData:YES];
    } else {
        self.searchViewModel.searchSortFilterModel.categoryId = self.categoryId;
        self.dataSource = @[self.goodsSectionModel];
        [self updateHotSalesUI];
        // 重置标签数据
        self.normalTagsArr = @[];
        // 拉取列表数据
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

    [self.KVOController hd_observe:self.viewModel keyPath:@"adsAndCategoryRefrehFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsObjectNil(self.viewModel.activityCardRspModel)) {
            self.adsSectionModel.list = @[self.viewModel.activityCardRspModel];
        }
    }];

    [self.KVOController hd_observe:self.searchViewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        if (HDIsArrayEmpty(self.searchViewModel.searchResult)) {
            SANoDataCellModel *cellModel = [[SANoDataCellModel alloc] init];
            self.goodsSectionModel.list = @[cellModel];
        } else {
            if (self.hasHotSalesData) {
                self.dataSource = @[self.hotSaleTextSectionModel, self.hotSectionModel, self.recommendTextSectionModel, self.goodsSectionModel];
            } else {
                self.dataSource = @[self.goodsSectionModel];
            }
            // 添加标签数据
            if (!HDIsArrayEmpty(self.searchViewModel.rspModel.aggs.productLabel)) {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.searchViewModel.rspModel.aggs.productLabel];
                [temp insertObject:[self.viewModel getDefaultTagModel] atIndex:0];
                // 只取一次
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
            }
            // 只记录第一页的情况
            self.viewModel.hasNextPage = self.searchViewModel.rspModel.hasNextPage;
            [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage scrollToTop:NO];

        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage];
        }
        self.searchViewModel.isNeedUpdateContentOffset = NO; // 重置筛选条件
    }];
}
#pragma mark -更新热销的UI布局
- (void)updateHotSalesUI {
    if (self.hasHotSalesData) {
        self.toolBarView.hidden = NO;
    } else {
        self.toolBarView.hidden = YES;
    }
    [self.collectionView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}
#pragma mark -分类切换
- (void)setCategoryId:(NSString *)categoryId {
    _categoryId = categoryId;
}
#pragma mark -商品展示样式更改通知事件
- (void)productDispalyStyleChangeNoti {
    [self.collectionView successGetNewDataWithNoMoreData:!self.searchViewModel.rspModel.hasNextPage scrollToTop:NO];
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

        if (!HDIsArrayEmpty(rspModel.list)) {
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
                self.dataSource = @[self.hotSaleTextSectionModel, self.hotSectionModel, self.recommendTextSectionModel, self.goodsSectionModel];
            }

            self.hotSectionModel.list = rspModel.list;
            [self updateHotSalesUI];
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
        }

        // 存储推荐热销数据  供其它样式切换使用
        if (HDIsStringEmpty(self.categoryId)) {
            self.viewModel.recommedHotSalesProductsArr = rspModel.list;
            if (HDIsArrayEmpty(self.viewModel.recommendHotTagsArr)) {
                self.viewModel.recommendHotTagsArr = self.hotTagsArr.copy;
            }
        }
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
    if (self.hasHotSalesData) {
        [self.collectionView successLoadMoreDataWithNoMoreData:YES];
    } else {
        [self.collectionView successGetNewDataWithNoMoreData:YES];
    }
}
#pragma mark - 检测当前的偏移量 是否需要显示置顶按钮
- (void)checkShowScollTopBtn {
    CGFloat maxY = kScreenHeight - kRealWidth(236) - kRealWidth(60);
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
        if ([self hasHotSalesData]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView setContentOffset:CGPointMake(0, self.recommedTextSectionOffsetY + kRealWidth(30)) animated:YES];
            });
        } else {
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
/// 保存住偏移量
- (void)keepScollerContentOffset {
    [self.collectionView setContentOffset:CGPointMake(0, self.lastContentOffetY)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        [self checkShowScollTopBtn];
        if (scrollView.contentOffset.y <= 0) {
            self.canScroll = NO;
            [self keepScollerContentOffset];
            if (self.scrollerViewScrollerToTopCallBack) {
                self.scrollerViewScrollerToTopCallBack();
            }
        }
    } else {
        self.canScroll = NO;
    }

    // 监听移动
    if (self.hasHotSalesData) {
        if (!self.isManualClickRecommd) {
            if (scrollView.contentOffset.y >= self.recommedTextSectionOffsetY) {
                if (self.isManualClickRecommd && scrollView.contentOffset.y >= self.recommedTextSectionOffsetY) {
                    // 是手动点击了推荐按钮  这里因为可能推荐的列表没创建
                    [self.collectionView setContentOffset:CGPointMake(0, self.recommedTextSectionOffsetY) animated:NO];
                    self.lastContentOffetY = self.recommedTextSectionOffsetY;
                    self.isManualClickRecommd = NO;
                }
                [self.toolBarView scrollerToRecommdProducts:YES];
                self.isScrollToRecommend = YES;

            } else {
                [self.toolBarView scrollerToRecommdProducts:NO];
                self.isScrollToRecommend = NO;
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isManualClickRecommd = NO;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataSource[section].list.count;
    return count;
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
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
    } else if (model == self.adsSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityCardRspModel class]]) {
            TNActivityCardWrapperCell *cell = [TNActivityCardWrapperCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNActivityCardWrapperCell.class)];
            return cell;
        }
    } else if (model == self.hotSaleTextSectionModel || model == self.recommendTextSectionModel) {
        TNVertocalStyleTextCell *cell = [TNVertocalStyleTextCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNVertocalStyleTextCell.class)];
        return cell;
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
        if (model == self.hotSectionModel) {
            goodCell.isNeedShowHotSale = YES;
        } else if (model == self.goodsSectionModel) {
            goodCell.isNeedShowHotSale = NO;
        }
        goodCell.isFromSpecialVercialStyle = YES;

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
        // 开始记录曝光商品
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:trueModel.productId];

    } else if ([cell isKindOfClass:TNActivityCardWrapperCell.class]) {
        TNActivityCardWrapperCell *cardCell = (TNActivityCardWrapperCell *)cell;
        cardCell.cellModel = (TNActivityCardRspModel *)rowModel;
    } else if ([cell isKindOfClass:TNVertocalStyleTextCell.class]) {
        TNVertocalStyleTextCell *textCell = (TNVertocalStyleTextCell *)cell;
        textCell.model = (TNVertocalStyleTextCellModel *)rowModel;
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            if (self.viewModel.showHorizontalStyle) {
                return CGSizeMake(kScreenWidth - kRealWidth(75), kRealWidth(160));
            } else {
                TNGoodsModel *gModel = (TNGoodsModel *)rowModel;
                gModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
                gModel.isNeedShowSmallShopCar = gModel.isOutOfStock ? NO : self.viewModel.configModel.isQuicklyAddToCart;
                gModel.preferredWidth = self.itemWidth;
                return CGSizeMake(self.itemWidth, gModel.cellHeight);
            }

        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
        } else if ([rowModel isKindOfClass:[SANoDataCellModel class]]) {
            SANoDataCellModel *model = (SANoDataCellModel *)rowModel;
            return CGSizeMake(kScreenWidth - kRealWidth(75), model.cellHeight);
        }
    } else if (model == self.adsSectionModel) {
        if ([rowModel isKindOfClass:[TNActivityCardRspModel class]]) {
            TNActivityCardRspModel *cellModel = (TNActivityCardRspModel *)rowModel;
            return CGSizeMake(kScreenWidth - kRealWidth(75), cellModel.cellHeight);
        }
    } else if (model == self.hotSaleTextSectionModel || model == self.recommendTextSectionModel) {
        return CGSizeMake(kScreenWidth - kRealWidth(75), kRealWidth(30));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel == self.goodsSectionModel) {
        CGFloat height = kRealWidth(60);
        if (self.hasHotSalesData) {
            height = kRealWidth(45);
        }
        if (!HDIsArrayEmpty(self.normalTagsArr)) {
            height = kRealWidth(45) + self.normalTagHeaderHeight;
        }
        return CGSizeMake(kScreenWidth - kSpecialLeftCategoryWidth, height);
    } else if (sectionModel == self.hotSectionModel && !HDIsArrayEmpty(self.hotSectionModel.list)) {
        CGFloat height = 0;
        if (!HDIsArrayEmpty(self.hotTagsArr)) {
            height += self.hotTagHeaderHeight;
        }
        return CGSizeMake(kScreenWidth - kSpecialLeftCategoryWidth, height);
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
            if (self.hasHotSalesData) {
                headerView.showChangeProductDisplayStyleBtn = NO;
            } else {
                headerView.showChangeProductDisplayStyleBtn = YES;
            }
            headerView.contentWidth = kScreenWidth - kSpecialLeftCategoryWidth;
            headerView.tagArr = self.normalTagsArr;
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
                self.recommedTextSectionOffsetY = kScreenWidth * 10;
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
            headerView.contentWidth = kScreenWidth - kSpecialLeftCategoryWidth;
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
        if (!HDIsArrayEmpty(model.list)) {
            id rowModel = model.list.firstObject;
            if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
                return self.viewModel.showHorizontalStyle ? UIEdgeInsetsZero : UIEdgeInsetsMake(kRealWidth(10), kRealWidth(5), kRealWidth(20), kRealWidth(5));
            } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
                return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(5), kRealWidth(20), kRealWidth(5));
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
        id rowModel = model.list.firstObject;
        if ([rowModel isKindOfClass:[TNGoodsModel class]]) {
            return self.viewModel.showHorizontalStyle ? 0 : kRealWidth(5);
        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            return kRealWidth(5);
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
    if (model == self.goodsSectionModel || model == self.hotSectionModel) {
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

- (void)updateConstraints {
    if (!self.toolBarView.isHidden) {
        [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(kRealWidth(60));
        }];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        if (!self.toolBarView.isHidden) {
            make.top.equalTo(self.toolBarView.mas_bottom);
        } else {
            make.top.equalTo(self);
        }
    }];
    [super updateConstraints];
}
- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(75) - kRealWidth(15)) / 2;
}
/** @lazy  hotSaleTextSectionModel*/
- (HDTableViewSectionModel *)hotSaleTextSectionModel {
    if (!_hotSaleTextSectionModel) {
        _hotSaleTextSectionModel = [[HDTableViewSectionModel alloc] init];
        TNVertocalStyleTextCellModel *model = [[TNVertocalStyleTextCellModel alloc] init];
        model.title = TNLocalizedString(@"tn_special_offer", @"特价");
        _hotSaleTextSectionModel.list = @[model];
    }
    return _hotSaleTextSectionModel;
}
/** @lazy recommendTextSectionModel */
- (HDTableViewSectionModel *)recommendTextSectionModel {
    if (!_recommendTextSectionModel) {
        _recommendTextSectionModel = [[HDTableViewSectionModel alloc] init];
        TNVertocalStyleTextCellModel *model = [[TNVertocalStyleTextCellModel alloc] init];
        model.title = TNLocalizedString(@"tn_recommend", @"推荐");
        _recommendTextSectionModel.list = @[model];
    }
    return _recommendTextSectionModel;
}
/** @lazy searchViewModel */
- (TNSearchViewModel *)searchViewModel {
    if (!_searchViewModel) {
        _searchViewModel = [[TNSearchViewModel alloc] init];
        _searchViewModel.searchSortFilterModel.rtnLabel = YES;
    }
    return _searchViewModel;
}
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.header_suspension = YES;
        flowLayout.delegate = self;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //        HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = false;
        _collectionView.needRefreshFooter = true;
        _collectionView.needShowErrorView = true;
        _collectionView.needShowNoDataView = false;
        _collectionView.needRecognizeSimultaneously = NO;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"placeholder_network_error";
        model.title = SALocalizedString(@"network_error", @"网络开小差啦");
        model.needRefreshBtn = YES;
        _collectionView.placeholderViewModel = model;

        @HDWeakify(self);
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
/** @lazy toolBarView */
- (TNVerticalTooBarView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[TNVerticalTooBarView alloc] init];
        @HDWeakify(self);
        _toolBarView.hotSaleClickCallBack = ^{
            @HDStrongify(self);
            if (self.isScrollToRecommend) {
                self.isManualClickRecommd = NO;
                [self.collectionView setContentOffset:CGPointZero animated:YES];
                self.isScrollToRecommend = NO;
                self.lastContentOffetY = 0;
            }
        };
        _toolBarView.recommendClickCallBack = ^{
            @HDStrongify(self);
            if (!self.isScrollToRecommend && self.hasHotSalesData) {
                self.isManualClickRecommd = YES;
                self.isScrollToRecommend = YES;
                [self.collectionView setContentOffset:CGPointMake(0, self.recommedTextSectionOffsetY) animated:YES];
                self.lastContentOffetY = self.recommedTextSectionOffsetY;
                self.canScroll = YES;
                [self.toolBarView scrollerToRecommdProducts:YES];
            }
        };
        _toolBarView.changeProductDisplayStyleCallBack = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击商品样式切换按钮"]];
        };
        _toolBarView.hidden = YES;
        [_toolBarView scrollerToRecommdProducts:NO];
    }
    return _toolBarView;
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
- (BOOL)hasHotSalesData {
    BOOL bingo = !HDIsArrayEmpty(self.hotSectionModel.list) && [self.dataSource containsObject:self.hotSectionModel];
    if (bingo && [self.dataSource containsObject:self.recommendTextSectionModel]) {
        NSInteger section = [self.dataSource indexOfObject:self.recommendTextSectionModel];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        if (cell != nil && cell.frame.origin.y > kRealWidth(30)) {
            self.recommedTextSectionOffsetY = cell.frame.origin.y;
        }
    }
    return bingo;
}
@end
