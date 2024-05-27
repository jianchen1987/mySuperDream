//
//  CMSThreeImage7x3ScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage7x3ScrolledCardView.h"
#import "CMSThreeImage7x3ItemConfig.h"
#import "CMSThreeImage7x3ScrolledCardCell.h"

#define sideWidth 0
#define cellMargin kRealWidth(10)
#define cellWidth kRealWidth(165)
#define hasTitleCellHeight kRealWidth(102)
#define noTitleCellHeight kRealWidth(85)


@interface CMSThreeImage7x3ScrolledCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<CMSThreeImage7x3ItemConfig *> *dataSource; ///< 数据源
@property (nonatomic, assign) BOOL hasTitle;                                   ///< 所有数据是否有包含标题的

@end


@implementation CMSThreeImage7x3ScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView).offset(kRealHeight(10));
        make.height.mas_equalTo(self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
        make.bottom.equalTo(self.containerView).offset(-kRealHeight(10));
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;

    height += kRealHeight(20) + (self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:CMSThreeImage7x3ItemConfig.class]) {
        CMSThreeImage7x3ScrolledCardCell *cell = [CMSThreeImage7x3ScrolledCardCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SACMSNode *node = self.config.nodes[indexPath.row];
    if ([model isKindOfClass:CMSThreeImage7x3ItemConfig.class]) {
        CMSThreeImage7x3ItemConfig *trueModel = (CMSThreeImage7x3ItemConfig *)model;
        !self.clickNode ?: self.clickNode(self, node, trueModel.link, [NSString stringWithFormat:@"node@%zd", indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth, self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
}

#pragma mark - getters and setters
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSThreeImage7x3ItemConfig.class json:self.config.getAllNodeContents];
    [self.dataSource enumerateObjectsUsingBlock:^(CMSThreeImage7x3ItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (HDIsStringNotEmpty(obj.title)) {
            self.hasTitle = true;
            *stop = true;
        }
    }];
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(10);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.backgroundView = UIView.new;
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
