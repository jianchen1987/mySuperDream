//
//  CMSMainEntranceCardView.m
//  SuperApp
//
//  Created by seeu on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSMainEntranceCardView.h"
#import "CMSMainEntranceCardViewCell.h"


@interface CMSMainEntranceCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// collection
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<CMSMainEntranceCardViewCellModel *> *dataSource; ///< 数据源

@end


@implementation CMSMainEntranceCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:CMSMainEntranceCardViewCellModel.class]) {
        CMSMainEntranceCardViewCell *cell = [CMSMainEntranceCardViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return UICollectionViewCell.new;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:CMSMainEntranceCardViewCellModel.class]) {
        CMSMainEntranceCardViewCellModel *trueModel = (CMSMainEntranceCardViewCellModel *)model;
        return trueModel.cellSize;
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SACMSNode *node = self.config.nodes[indexPath.row];
    if ([model isKindOfClass:CMSMainEntranceCardViewCellModel.class]) {
        CMSMainEntranceCardViewCellModel *trueModel = (CMSMainEntranceCardViewCellModel *)model;
        !self.clickNode ?: self.clickNode(self, node, trueModel.link, [NSString stringWithFormat:@"node@%zd", indexPath.row]);
    }
}

#pragma mark - layout
- (void)updateConstraints {
    __block CGFloat height = 0;

    [self.dataSource enumerateObjectsUsingBlock:^(CMSMainEntranceCardViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == 0) {
            height += obj.cellSize.height;
        } else if (idx % 2 != 0) {
            height += obj.cellSize.height + kRealWidth(7);
        }
    }];

    if (height > 0) {
        height += 30.0f; /// sectionInsert
    }

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
        make.height.mas_equalTo(height);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSMainEntranceCardViewCellModel.class json:self.config.getAllNodeContents];
    [self.dataSource enumerateObjectsUsingBlock:^(CMSMainEntranceCardViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        // 可用宽度 - 卡片内边距 -
        CGFloat availableWidth = self.config.maxLayoutWidth - UIEdgeInsetsGetHorizontalValue(self.config.contentEdgeInsets) - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
        if (idx == 0) {
            obj.cellSize = CGSizeMake(availableWidth, availableWidth * kRealHeight(130) / kRealHeight(345));
        } else if (idx == 1 || idx == 2) {
            CGFloat width = (availableWidth - kRealWidth(7)) / 2.0;
            obj.cellSize = CGSizeMake(width, width * kRealHeight(110) / kRealHeight(169));
        } else {
            CGFloat width = (availableWidth - kRealWidth(7)) / 2.0;
            obj.cellSize = CGSizeMake(width, width * kRealHeight(75) / kRealHeight(169));
        }
    }];
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    __block CGFloat height = 0;

    [self.dataSource enumerateObjectsUsingBlock:^(CMSMainEntranceCardViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx == 0) {
            height += obj.cellSize.height;
        } else if (idx % 2 != 0) {
            height += obj.cellSize.height + kRealWidth(7);
        }
    }];

    if (height > 0) {
        height += 30.0f; /// sectionInsert
    }
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    height += [self.titleView heightOfTitleView];

    return height;
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(7);
        flowLayout.minimumInteritemSpacing = kRealWidth(7);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, HDAppTheme.value.padding.left, 15, HDAppTheme.value.padding.right);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.backgroundView = UIView.new;
        collectionView.scrollEnabled = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
