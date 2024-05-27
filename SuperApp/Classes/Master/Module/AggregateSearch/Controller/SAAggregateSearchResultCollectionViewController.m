//
//  SAAggregateSearchResultCollectionViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchResultCollectionViewController.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SAAggregateSearchViewModel.h"
#import "SACollectionView.h"
#import "SACollectionViewWaterFlowLayout.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "SAAddressCacheAdaptor.h"


@interface SAAggregateSearchResultCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>

///< collectionView
@property (nonatomic, strong) SACollectionView *collectionView;
///< dataSource
@property (nonatomic, strong) NSArray *dataSource;
///< currentPageNo
@property (nonatomic, assign) NSUInteger currentPage;
///< keyword
@property (nonatomic, copy) NSString *keyWord;
///< vuewNidek
@property (nonatomic, strong) SAAggregateSearchViewModel *viewModel;

@end


@implementation SAAggregateSearchResultCollectionViewController

- (void)hd_setupViews {
    [self.view addSubview:self.collectionView];

    [self initDataSource];
    
    // 监听位置改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)updateViewConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)userChangedLocationHandler:(NSNotification *)notification {
    self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    //如果有关键词重新刷新数据
    if (HDIsStringNotEmpty(self.keyWord)) {
        [self getDataWithPageNum:1];
    }
}

#pragma mark - Data
- (void)getNewDataWithKeyWord:(NSString *)keyWord {
    if ([keyWord isEqualToString:_keyWord]) {
        return;
    }
    _keyWord = keyWord;
    [self initDataSource];
    [self getDataWithPageNum:1];
}

- (void)initDataSource {
    self.dataSource = @[
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new,
        TNHomeChoicenessSkeletonCellModel.new
    ];
    [self.collectionView successGetNewDataWithNoMoreData:YES];
}

- (void)loadMoreData {
    [self getDataWithPageNum:self.currentPage + 1];
}

- (void)getDataWithPageNum:(NSUInteger)pageNum {
    @HDWeakify(self);
    if(HDIsObjectNil(self.currentlyAddress)) {
        self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    }
    [self.viewModel searchWithKeyWord:self.keyWord businessLine:self.businessLine address:self.currentlyAddress pageNum:pageNum pageSize:10
        success:^(SAAggregateSearchResultRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.currentPage = rspModel.pageNum;
            if (pageNum == 1) {
                self.dataSource = [NSArray arrayWithArray:rspModel.list];
                [self.collectionView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.dataSource];
                [tmp addObjectsFromArray:rspModel.list];
                self.dataSource = [NSArray arrayWithArray:tmp];
                [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            if (pageNum == 1) {
                self.dataSource = @[];
                [self.collectionView failGetNewData];
            } else {
                [self.collectionView failLoadMoreData];
            }
        }];
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        TNGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class) forIndexPath:indexPath];
        trueModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                       identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
        return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{
            @"productId": trueModel.productId,
            @"source": self.viewModel.source,
            @"associatedId": self.viewModel.associatedId}];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    CGFloat itemWidth = (kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding) - kRealWidth(10)) / 2.0;
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        trueModel.cellType = TNGoodsShowCellTypeGoodsAndStore;
        trueModel.preferredWidth = itemWidth;
        return CGSizeMake(itemWidth, trueModel.cellHeight);
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        return CGSizeMake(itemWidth, indexPath.row % 2 ? ChoicenessSkeletonCellHeight : (ChoicenessSkeletonCellHeight + 30));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, HDAppTheme.value.padding.left, 10, HDAppTheme.value.padding.right);
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

#pragma mark - lazy load
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[SACollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor hd_colorWithHexString:@"#F2F2F2"];
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = YES;
        _collectionView.needShowNoDataView = YES;
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadMoreData];
        };
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"wn_placeholder_nodata";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#8F8F8F"];
        placeHolder.needRefreshBtn = NO;
        _collectionView.placeholderViewModel = placeHolder;

        [_collectionView registerClass:[TNGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];

        [_collectionView registerClass:TNHomeChoicenessSkeletonCell.class forCellWithReuseIdentifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
    }
    return _collectionView;
}

- (SAAggregateSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAAggregateSearchViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
