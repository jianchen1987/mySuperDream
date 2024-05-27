//
//  WMNearbyStoreTagsFilterTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNearbyStoreTagsFilterTableViewCell.h"
#import "UICollectionViewLeftAlignLayout.h"
#import "WMNearbyStoreTagCollectionViewCell.h"
#import "WMNearbyStoreTagsModel.h"


@interface WMNearbyStoreTagsFilterTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// gap度
@property (nonatomic, assign) CGFloat cellHeight;
@end


@implementation WMNearbyStoreTagsFilterTableViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(self.cellHeight);
    }];

    [super updateConstraints];
}

- (void)setModel:(WMNearbyStoreTagsFilterTableViewCellModel *)model {
    _model = model;
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    HDLog(@"Collection ContentSize:%@", NSStringFromCGSize(self.collectionView.contentSize));
    self.cellHeight = self.collectionView.contentSize.height;
    [self setNeedsUpdateConstraints];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMNearbyStoreTagsModel *model = self.model.dataSource[indexPath.row];
    WMNearbyStoreTagCollectionViewCell *cell = [WMNearbyStoreTagCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = model;
    // 已选中的 置为选中状态
    if (model.selected) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.selected = model.selected;
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        //取消选中 返回NO，这样collectionView就不会再调用didSelectItemAtIndexPath方法
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        WMNearbyStoreTagsModel *model = self.model.dataSource[indexPath.row];
        model.selected = NO;
        if (self.tagDeletedHandler) {
            self.tagDeletedHandler(model);
        }
        return NO;
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WMNearbyStoreTagsModel *model = self.model.dataSource[indexPath.row];
    model.selected = YES;
    if (self.tagAddedHandler) {
        self.tagAddedHandler(model);
    }
}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    WMNearbyStoreTagsModel *model = self.model.dataSource[indexPath.row];
//    [self.selectedTags removeObject:model];
//    if(self.tagsSelectedHandler) {
//        self.tagsSelectedHandler(self.selectedTags);
//    }
//}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - lazy load
/** @lazy collectionView */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 15.0f;
        flowLayout.minimumInteritemSpacing = 20.0f;
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(kRealWidth(50), kRealWidth(20));
        flowLayout.sectionInset = UIEdgeInsetsMake(kRealHeight(10), kRealWidth(15), kRealHeight(10), kRealWidth(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 100) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end


@implementation WMNearbyStoreTagsFilterTableViewCellModel

@end
