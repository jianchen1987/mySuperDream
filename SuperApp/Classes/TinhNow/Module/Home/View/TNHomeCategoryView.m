//
//  TNHomeCategoryView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHomeCategoryView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SANoDataCollectionViewCell.h"
#import "TNBargainGoodsCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsDTO.h"
#import "TNGoodsModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHomeViewModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterModel.h"


@interface TNHomeCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// 列表
@property (strong, nonatomic) TNCollectionView *collectionView;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<TNGoodsModel *> *dataSource;
/// 搜索参数模型
@property (nonatomic, copy) TNSearchSortFilterModel *filterModel;
/// dto
@property (strong, nonatomic) TNGoodsDTO *goodsDto;
/// 页码
@property (assign, nonatomic) NSInteger page;
/// 点击到顶按钮
@property (strong, nonatomic) HDUIButton *scrollTopBtn;
@end


@implementation TNHomeCategoryView
- (instancetype)initWithCategoryId:(NSString *)categoryId {
    if (self = [super init]) {
        self.filterModel.categoryId = categoryId;
        self.page = 1;
        [self hd_loadData];
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollTopBtn];
}
- (void)hd_loadData {
    //添加骨架屏
    [self addSkeleLayerCellModel];
    [self loadGoodsDataWithPage:self.page];
}
- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.scrollTopBtn sizeToFit];
    [self.scrollTopBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(70));
        make.right.equalTo(self.mas_right);
    }];
    [super updateConstraints];
}
- (void)addSkeleLayerCellModel {
    [self.dataSource removeAllObjects];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [self.dataSource addObject:model];
    }
    [self.collectionView successLoadMoreDataWithNoMoreData:YES];
}
- (void)loadGoodsDataWithPage:(NSInteger)page {
    @HDWeakify(self);
    [self.goodsDto queryGoodsListWithPageNo:page pageSize:20 filterModel:self.filterModel success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.page = rspModel.pageNum;
        if (page == 1) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:rspModel.list];
            [self.collectionView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataSource addObjectsFromArray:rspModel.list];
            [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (page == 1) {
            [self.dataSource removeAllObjects];
            [self.collectionView failGetNewData];
        } else {
            [self.collectionView failLoadMoreData];
        }
    }];
}

#pragma mark - UIScrollViewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > kScreenHeight) {
        self.scrollTopBtn.hidden = NO;
    } else {
        self.scrollTopBtn.hidden = YES;
    }
}

#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *error = [NSString stringWithFormat:@"越界:section:%zd row:%zd", indexPath.section, indexPath.row];
    NSAssert(indexPath.row < self.dataSource.count, error);
    if (indexPath.row >= self.dataSource.count)
        return nil;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodsCell *cell = [TNBargainGoodsCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainGoodsCell.class)];
            return cell;
        } else {
            TNGoodsCollectionViewCell *cell = [TNGoodsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
            trueModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            return cell;
        }
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                       identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    id model = self.dataSource[indexPath.row];
    if ([cell isKindOfClass:TNBargainGoodsCell.class]) {
        TNBargainGoodsCell *bargainGoodCell = (TNBargainGoodsCell *)cell;
        bargainGoodCell.model = [TNBargainGoodModel modelWithProductModel:model];
    } else if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
        TNGoodsModel *goodModel = model;
        TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
        goodCell.model = goodModel;
        //记录曝光商品位置
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:goodModel.productId];
    } else if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *gModel = [TNBargainGoodModel modelWithProductModel:trueModel];
            [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId}];
        } else {
            [HDMediator.sharedInstance navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId, @"funnel": @"[电商]首页_点击分类tab"}];
            [SATalkingData trackEvent:@"[电商]首页_点击分类tab_选购商品"];
        }
    }
}
#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return CGSizeZero;
    }
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *bmodel = [TNBargainGoodModel modelWithProductModel:trueModel];
            bmodel.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, bmodel.cellHeight);
        } else {
            trueModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            trueModel.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, trueModel.cellHeight);
        }
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}

#pragma mark - lazy
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = YES;
        _collectionView.needRefreshFooter = YES;
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.page = 1;
            [self loadGoodsDataWithPage:self.page];
        };
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadGoodsDataWithPage:++self.page];
        };
    }
    return _collectionView;
}
- (TNGoodsDTO *)goodsDto {
    if (!_goodsDto) {
        _goodsDto = [[TNGoodsDTO alloc] init];
    }
    return _goodsDto;
}
- (TNSearchSortFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = [[TNSearchSortFilterModel alloc] init];
        _filterModel.sortType = @""; //模型里面默认销量排序  置空
    }
    return _filterModel;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/** @lazy scrollTopBtn */
- (HDUIButton *)scrollTopBtn {
    if (!_scrollTopBtn) {
        _scrollTopBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_scrollTopBtn setImage:[UIImage imageNamed:@"tn_scroller_top"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_scrollTopBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            //            //置顶
            [self.collectionView setContentOffset:CGPointZero animated:YES];
        }];
        _scrollTopBtn.hidden = YES;
    }
    return _scrollTopBtn;
}
- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / 2;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillDisappear {
    //精选和为你推荐上报
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"categoryId": self.filterModel.categoryId}];
}
@end
