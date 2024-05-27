//
//  GNHomeArticleListView.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNHomeArticleListView.h"
#import "GNCollectionView.h"
#import "GNHomeArticleCell.h"
#import "GNHomeCustomViewModel.h"
#import "HDCollectionViewVerticalLayout.h"
#import "WMZPageProtocol.h"


@interface GNHomeArticleListView () <WMZPageProtocol, UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// productView
@property (nonatomic, strong) GNCollectionView *collectionView;
/// viewModel
@property (nonatomic, strong) GNHomeCustomViewModel *viewModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray<GNArticleModel *> *dataSource;
/// 分页
@property (nonatomic, assign) NSInteger pageNum;
/// 骨架
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation GNHomeArticleListView

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
}

- (void)pageViewDidAppear {
    if (!self.viewModel.dataSource.count && self.updateMenuList) {
        self.pageNum = 1;
        [self gn_getNewData];
    }
}

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getColumnArticleDataCode:self.columnCode columnType:self.columnType pageNum:self.pageNum completion:^(GNArticlePagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        if (!error) {
            if (self.pageNum > 1) {
                [self.dataSource addObjectsFromArray:rspModel.list ?: @[]];
            } else {
                self.dataSource = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
            }
        }
        if (!error) {
            (self.pageNum == 1) ? [self.collectionView reloadNewData:!rspModel.hasNextPage] : [self.collectionView reloadMoreData:!rspModel.hasNextPage];
        } else {
            (self.pageNum == 1) ? [self.collectionView gnFailGetNewData] : [self.collectionView gnFailLoadMoreData];
        }
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.collectionView];
    @HDWeakify(self);
    self.collectionView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        self.pageNum = 1;
        if (!self.collectionView.hd_hasData) {
            self.collectionView.delegate = self.provider;
            self.collectionView.dataSource = self.provider;
        }
        [self gn_getNewData];
    };
    self.collectionView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        self.pageNum += 1;
        [self gn_getNewData];
    };
}

- (void)updateConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.safeBottom ? -kTabBarH : 0);
    }];
    [super updateConstraints];
}

#pragma mark GNPageProtocol
- (UIScrollView *)getMyScrollView {
    return self.collectionView;
}

#pragma - mark UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNHomeArticleCell *cell = [GNHomeArticleCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    GNArticleModel *model = self.dataSource[indexPath.row];
    [cell setGNModel:model];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor((kScreenWidth - kRealWidth(36)) / 2.0), kRealWidth(270));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(12);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[GNCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = HDAppTheme.color.gn_whiteColor;
        _collectionView.delegate = self.provider;
        _collectionView.dataSource = self.provider;
        _collectionView.needRefreshFooter = YES;
        _collectionView.needShowErrorView = YES;
        _collectionView.needShowNoDataView = YES;
        _collectionView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
            if (!showError) {
                placeholderViewModel.title = GNLocalizedString(@"gn_no_content", @"这里没有内容哦！到别处逛逛？");
                placeholderViewModel.titleFont = [HDAppTheme.font gn_ForSize:12];
                placeholderViewModel.titleColor = HDAppTheme.color.gn_333Color;
                placeholderViewModel.image = @"gn_home_blank_data";
            }
        };
        [_collectionView registerClass:GNHomeArticleCell.class forCellWithReuseIdentifier:@"GNHomeArticleCell"];
        MJRefreshAutoStateFooter *foot = (MJRefreshAutoStateFooter *)_collectionView.mj_footer;
        [foot setTitle:@"——  END LINE  ——" forState:MJRefreshStateNoMoreData];
    }
    return _collectionView;
}

- (NSMutableArray<GNArticleModel *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.new; });
}

- (GNHomeCustomViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNHomeCustomViewModel.new; });
}

- (NSInteger)pageNum {
    return _pageNum ?: ({ _pageNum = 1; });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithCellReuseIdentifier:@"GNHomeArticleCell"];
        _provider.numberOfRowsInSection = 20;
    }
    return _provider;
}

@end
