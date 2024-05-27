//
//  TNNewHomeView.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHomeRecommendView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SANoDataCollectionViewCell.h"
#import "TNActivityCardWrapperCell.h"
#import "TNBargainGoodsCell.h"
#import "TNCarouselViewWrapperCell.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHomeNavView.h"
#import "TNHomeViewModel.h"
#import "TNHomeViewModelProtocol.h"
#import "TNHomeViewScrollLabelCell.h"
#import "TNKingKongAreaViewWrapperCell.h"
#import "TNNewHomeReusableHeaderView.h"
#import "TNScrollContentRspModel.h"


@interface TNHomeRecommendView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// 列表
@property (strong, nonatomic) TNCollectionView *collectionView;
/// VM
@property (nonatomic, strong) TNHomeViewModel *viewModel;
/// 点击到顶按钮
@property (strong, nonatomic) HDUIButton *scrollTopBtn;
@end


@implementation TNHomeRecommendView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollTopBtn];
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
- (void)hd_bindViewModel {
    [self.collectionView successGetNewDataWithNoMoreData:YES];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.currentPageNo == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }];

    //加载缓存数据
    [self.viewModel loadOfflineData];

    //请求最新的广告数据
    [self.viewModel requestAdvertisementCompletion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    [self.viewModel requestKingKongAreaUseCache:YES completion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    //请求滚动文字数据
    [self.viewModel requestScrollTextCompletion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    //请求活动卡片数据
    [self.viewModel requestActivityCardDataCompletion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    //请求精选列表数据
    [self.viewModel requestNewChoicenessDataCompletion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    //请求为你推荐列表数据
    [self.viewModel requestNewRecommendDataCompletion:^{
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    }];

    self.viewModel.failedLoadMoreDataBlock = ^() {
        @HDStrongify(self);
        [self.collectionView failLoadMoreData];
    };
    self.viewModel.networkFailBlock = ^{
        @HDStrongify(self);
        [self.collectionView failGetNewData];
    };
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
    return self.viewModel.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *list = self.viewModel.dataSource[section].list;
    return list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *error = [NSString stringWithFormat:@"越界:section:%zd row:%zd", indexPath.section, indexPath.row];
    NSAssert(indexPath.section < self.viewModel.dataSource.count, error);
    if (indexPath.section >= self.viewModel.dataSource.count)
        return nil;

    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    NSAssert(indexPath.row < sectionModel.list.count, @"越界");
    if (indexPath.row >= sectionModel.list.count)
        return nil;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNCarouselViewWrapperCellModel.class]) {
        TNCarouselViewWrapperCellModel *cellModel = (TNCarouselViewWrapperCellModel *)model;
        NSString *identifier = [NSString stringWithFormat:@"%@+%ld", NSStringFromClass(TNCarouselViewWrapperCell.class), cellModel.type];
        TNCarouselViewWrapperCell *cell = [TNCarouselViewWrapperCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:identifier];
        return cell;
    } else if ([model isKindOfClass:TNKingKongAreaViewWrapperCellModel.class]) {
        TNKingKongAreaViewWrapperCell *cell = [TNKingKongAreaViewWrapperCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                         identifier:NSStringFromClass(TNKingKongAreaViewWrapperCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNScrollContentRspModel.class]) {
        TNHomeViewScrollLabelCell *cell = [TNHomeViewScrollLabelCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNHomeViewScrollLabelCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNActivityCardRspModel.class]) {
        TNActivityCardWrapperCell *cell = [TNActivityCardWrapperCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNActivityCardWrapperCell.class)];
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
        return cell;
    } else if ([model isKindOfClass:TNGoodsModel.class]) {
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
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([cell isKindOfClass:TNCarouselViewWrapperCell.class]) {
        TNCarouselViewWrapperCell *carouseCell = (TNCarouselViewWrapperCell *)cell;
        carouseCell.backgroundColor = HDAppTheme.TinhNowColor.G5;
        carouseCell.model = model;
    } else if ([cell isKindOfClass:TNKingKongAreaViewWrapperCell.class]) {
        TNKingKongAreaViewWrapperCell *kingKongCell = (TNKingKongAreaViewWrapperCell *)cell;
        kingKongCell.canNotOpenRouteHandler = ^(NSString *urlString) {
            [NAT showAlertWithMessage:SALocalizedString(@"coming_soon", @"敬请期待") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        };
        kingKongCell.model = model;
    } else if ([cell isKindOfClass:TNHomeViewScrollLabelCell.class]) {
        TNHomeViewScrollLabelCell *scrollerLabelCell = (TNHomeViewScrollLabelCell *)cell;
        scrollerLabelCell.model = model;
    } else if ([cell isKindOfClass:TNActivityCardWrapperCell.class]) {
        TNActivityCardWrapperCell *cardCell = (TNActivityCardWrapperCell *)cell;
        cardCell.cellModel = model;
    } else if ([cell isKindOfClass:SANoDataCollectionViewCell.class]) {
        SANoDataCollectionViewCell *noDataCell = (SANoDataCollectionViewCell *)cell;
        noDataCell.model = model;
    } else if ([cell isKindOfClass:TNBargainGoodsCell.class]) {
        TNBargainGoodsCell *bargainGoodCell = (TNBargainGoodsCell *)cell;
        bargainGoodCell.model = [TNBargainGoodModel modelWithProductModel:model];
    } else if ([cell isKindOfClass:TNGoodsCollectionViewCell.class]) {
        TNGoodsModel *goodModel = model;
        TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
        goodCell.model = goodModel;
        //只曝光商品
        //        [TNEventTrackingInstance startRecordingExposureByScrollIndexPath:indexPath];
        [TNEventTrackingInstance startRecordingExposureIndexWithProductId:goodModel.productId];
    } else if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (sectionModel.headerModel != nil && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TNNewHomeReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(TNNewHomeReusableHeaderView.class)
                                                                                            forIndexPath:indexPath];
        headerView.sectionTitle = sectionModel.headerModel.title;
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *gModel = [TNBargainGoodModel modelWithProductModel:trueModel];
            [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId}];
        } else {
            [HDMediator.sharedInstance navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId}];
        }
        [SATalkingData trackEvent:@"[电商]精选商品" label:@"" parameters:@{@"商品ID": trueModel.productId}];
    }
}
#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.viewModel.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count) {
        return CGSizeZero;
    }
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNCarouselViewWrapperCellModel.class]) {
        TNCarouselViewWrapperCellModel *cellModel = (TNCarouselViewWrapperCellModel *)model;
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if ([model isKindOfClass:TNKingKongAreaViewWrapperCellModel.class]) {
        TNKingKongAreaViewWrapperCellModel *cellModel = (TNKingKongAreaViewWrapperCellModel *)model;
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if ([model isKindOfClass:TNScrollContentRspModel.class]) {
        TNScrollContentRspModel *cellModel = (TNScrollContentRspModel *)model;
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if ([model isKindOfClass:TNActivityCardRspModel.class]) {
        TNActivityCardRspModel *cellModel = (TNActivityCardRspModel *)model;
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCellModel *cellModel = (SANoDataCellModel *)model;
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    } else if ([model isKindOfClass:TNGoodsModel.class]) {
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *model = self.viewModel.dataSource[section];
    if (model.headerModel != nil) {
        return CGSizeMake(kScreenWidth, kRealHeight(60));
    } else {
        return CGSizeZero;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *model = self.viewModel.dataSource[section];
    if (model.headerModel != nil) {
        return UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(15), kRealWidth(15));
    } else {
        return UIEdgeInsetsMake(kRealWidth(10), 0, 0, 0);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.viewModel.dataSource[section];
    if (model.headerModel != nil) {
        return kRealWidth(10);
    } else {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *model = self.viewModel.dataSource[section];
    if (model.headerModel != nil) {
        return kRealWidth(10);
    } else {
        return 0;
    }
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return 1;
    }
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if (sectionModel.headerModel != nil && [sectionModel.headerModel.tag isEqualToString:TNHomeGoodCellIdentity]) {
        return 2;
    }
    return 1;
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
        _collectionView.needShowNoDataView = YES;
        [_collectionView registerClass:TNNewHomeReusableHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNNewHomeReusableHeaderView.class)];
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        @HDWeakify(self);
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadOfflineData];
            [self.viewModel hd_getNewData];
        };
        _collectionView.placeholderViewModel = placeHolderModel;
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel hd_getNewData];
        };
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadMoreRecommendData];
        };
    }
    return _collectionView;
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
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:nil];
}
@end
