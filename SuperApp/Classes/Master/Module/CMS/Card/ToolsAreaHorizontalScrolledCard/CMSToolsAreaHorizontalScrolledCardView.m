//
//  CMSToolsAreaHorizontalScrolledCard.m
//  SuperApp
//
//  Created by seeu on 2022/4/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSToolsAreaHorizontalScrolledCardView.h"
#import "CMSToolsAreaHorizontalScrolledCardCell.h"
#import "HDScrollIndicatorView.h"


@interface CMSToolsAreaHorizontalScrolledCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

/// collection
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<CMSToolsAreaHorizontalScrolledCardCellModel *> *dataSource; ///< 数据源
///< scrollIndicator
@property (nonatomic, strong) HDScrollIndicatorView *scrollIndicator;
///< 单元格大小
@property (nonatomic, assign) CGSize cellSize;

@end


@implementation CMSToolsAreaHorizontalScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.scrollIndicator];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:CMSToolsAreaHorizontalScrolledCardCellModel.class]) {
        CMSToolsAreaHorizontalScrolledCardCell *cell = [CMSToolsAreaHorizontalScrolledCardCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SACMSNode *node = self.config.nodes[indexPath.row];
    if ([model isKindOfClass:CMSToolsAreaHorizontalScrolledCardCellModel.class]) {
        CMSToolsAreaHorizontalScrolledCardCellModel *trueModel = (CMSToolsAreaHorizontalScrolledCardCellModel *)model;
        !self.clickNode ?: self.clickNode(self, node, trueModel.link, [NSString stringWithFormat:@"node@%zd", indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSize;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.scrollIndicator.isHidden) {
        self.scrollIndicator.progress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(8));
        //        make.height.mas_equalTo(kRealWidth(74));
        make.height.mas_equalTo(self.cellSize.height);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealHeight(8));
    }];

    if (!self.scrollIndicator.isHidden) {
        [self.scrollIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-3);
            make.centerX.equalTo(self.collectionView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(50, 3));
        }];
    }

    [super updateConstraints];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    self.dataSource = [NSArray yy_modelArrayWithClass:CMSToolsAreaHorizontalScrolledCardCellModel.class json:self.config.getAllNodeContents];
    NSDictionary *cardConfig = [config getCardContent];
    NSString *tintColor = [cardConfig objectForKey:@"tintColor"];
    NSString *tintBgColor = [cardConfig objectForKey:@"tintBgColor"];
    if (self.dataSource.count > 5 && HDIsStringNotEmpty(tintColor)) {
        self.scrollIndicator.dotColor = [UIColor hd_colorWithHexString:tintColor];
        if (HDIsStringNotEmpty(tintBgColor)) {
            self.scrollIndicator.bgColor = [UIColor hd_colorWithHexString:tintBgColor];
        }
        self.scrollIndicator.hidden = YES;
    } else {
        self.scrollIndicator.hidden = YES;
    }

    CGFloat cellWidth = 0;
    CGFloat cellHeight = 0;
    CGFloat iconWidth = kRealWidth(30);
    if (self.dataSource.count > 5) {
        cellWidth = (config.maxLayoutWidth / 5.5) > iconWidth ? (config.maxLayoutWidth / 5.5) : iconWidth;
    } else {
        cellWidth = (config.maxLayoutWidth / self.dataSource.count) > iconWidth ? (config.maxLayoutWidth / self.dataSource.count) : iconWidth;
    }
    CGFloat maxTitleHeight = [self calcMaxTitleHeightWithDataSource:[self.dataSource copy] maxCellWidth:cellWidth];
    cellHeight = iconWidth + kRealHeight(5) * 2;
    cellHeight += maxTitleHeight;

    [self.dataSource enumerateObjectsUsingBlock:^(CMSToolsAreaHorizontalScrolledCardCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.cellSize = CGSizeMake(iconWidth, cellHeight);
    }];

    self.cellSize = CGSizeMake(cellWidth, cellHeight);
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (CGFloat)calcMaxTitleHeightWithDataSource:(NSArray<CMSToolsAreaHorizontalScrolledCardCellModel *> *)dataSource maxCellWidth:(CGFloat)maxCellWidth {
    __block CGFloat maxTitleHeight = 0;

    [dataSource enumerateObjectsUsingBlock:^(CMSToolsAreaHorizontalScrolledCardCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CGFloat titleHeight = [obj.title boundingAllRectWithSize:CGSizeMake(maxCellWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:obj.titleFont weight:UIFontWeightMedium]].height;
        CGFloat oneLineMaxHeight = [@"你" boundingAllRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:[UIFont systemFontOfSize:obj.titleFont weight:UIFontWeightMedium]].height;
        maxTitleHeight = MAX(maxTitleHeight, MIN(titleHeight, oneLineMaxHeight));
    }];
    return maxTitleHeight;
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    height += [self.titleView heightOfTitleView];
    height += kRealWidth(8 + 8) + self.cellSize.height;

    return height;
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
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

- (HDScrollIndicatorView *)scrollIndicator {
    if (!_scrollIndicator) {
        _scrollIndicator = [[HDScrollIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 3)];
    }
    return _scrollIndicator;
}

@end
