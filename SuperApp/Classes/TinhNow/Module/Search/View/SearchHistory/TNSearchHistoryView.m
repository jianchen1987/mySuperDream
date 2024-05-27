//
//  TNSearchHistoryView.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchHistoryView.h"
#import "TNCollectionView.h"
#import "TNSearchBaseViewModel.h"
#import "TNSearchFindCell.h"
#import "TNSearchHistoryBarView.h"
#import "TNSearchHistoryCollectionViewCell.h"
#import "TNSearchHistoryEmptyCollectionViewCell.h"
#import "TNSearchHistoryModel.h"
#import "TNSearchRankAndDiscoveryModel.h"
#import "TNSearchRankCell.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNSearchHistoryView () <UICollectionViewDelegate, UICollectionViewDataSource>

/// bar
@property (nonatomic, strong) TNSearchHistoryBarView *toolBar;
/// colelction
@property (nonatomic, strong) TNCollectionView *collectionView;
/// viewModel
@property (nonatomic, strong) TNSearchBaseViewModel *viewModel;
@end


@implementation TNSearchHistoryView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    self.toolBar = [[TNSearchHistoryBarView alloc] initWithViewModel:self.viewModel];

    [self addSubview:self.toolBar];
    [self addSubview:self.collectionView];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:YES];
    }];
    [self.viewModel initHistoryData];
    [self.viewModel getSearchRankAndDiscoveryData];
}
- (void)updateConstraints {
    [self.toolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:section];
    return sectionModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kSearchSectionType];
    if ([type isEqualToString:kSearchHistory]) {
        if ([model isKindOfClass:TNSearchHistoryModel.class]) {
            TNSearchHistoryCollectionViewCell *cell = [TNSearchHistoryCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
            TNSearchHistoryModel *trueModel = (TNSearchHistoryModel *)model;
            cell.model = trueModel;
            return cell;
        } else if ([model isKindOfClass:TNSearchHistoryEmptyModel.class]) {
            TNSearchHistoryEmptyCollectionViewCell *cell = [TNSearchHistoryEmptyCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
            TNSearchHistoryEmptyModel *trueModel = (TNSearchHistoryEmptyModel *)model;
            cell.model = trueModel;
            return cell;
        } else {
            // 为了异常错误提示
            UICollectionViewCell *cell = UICollectionViewCell.new;
            return cell;
        }
    } else if ([type isEqualToString:kSearchFind]) {
        TNSearchFindCell *cell = [TNSearchFindCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        TNSearchRankAndDiscoveryModel *findModel = (TNSearchRankAndDiscoveryModel *)model;
        cell.dataArray = findModel.rspList;
        @HDWeakify(self);
        cell.reloadCellBlock = ^{
            @HDStrongify(self);
            [self.collectionView successGetNewDataWithNoMoreData:YES];
        };
        cell.clickItemBlock = ^(NSString *_Nonnull itemStr) {
            @HDStrongify(self);
            !self.searchHistoryKeyWordSelected ?: self.searchHistoryKeyWordSelected(itemStr);
        };
        return cell;

    } else if ([type isEqualToString:kSearchRank]) {
        TNSearchRankCell *cell = [TNSearchRankCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        TNSearchRankAndDiscoveryModel *rankModel = (TNSearchRankAndDiscoveryModel *)model;
        cell.dataArray = rankModel.rspList;
        @HDWeakify(self);
        cell.clickItemBlock = ^(NSString *_Nonnull itemStr) {
            @HDStrongify(self);
            !self.searchHistoryKeyWordSelected ?: self.searchHistoryKeyWordSelected(itemStr);
        };
        return cell;
    } else {
        // 为了异常错误提示
        UICollectionViewCell *cell = UICollectionViewCell.new;
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kSearchSectionType];
    if ([type isEqualToString:kSearchHistory]) {
        return UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
    } else if ([type isEqualToString:kSearchFind] || [type isEqualToString:kSearchRank]) {
        return UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNSearchHistoryModel.class]) {
        TNSearchHistoryModel *trueModel = model;
        if (self.searchHistoryKeyWordSelected) {
            self.searchHistoryKeyWordSelected(trueModel.keyWord);
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.superview endEditing:YES];
}
#pragma mark - lazy load
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 12.0f;
        flowLayout.minimumInteritemSpacing = 12.0f;
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(70, 28);
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}

@end
