//
//  CMSSingleImageScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSSingleImageScrolledCardView.h"
#import "CMSImageItemConfig.h"
#import "SASingleImageCollectionViewCell.h"

static CGFloat const kPageControlDotSize = 6;

#define sideWidth 0
#define cellMargin 0


@interface CMSSingleImageScrolledCardView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>

@property (nonatomic, strong) HDCyclePagerView *bannerView;                                       ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                         ///< pageControl
@property (nonatomic, strong) NSMutableArray<SASingleImageCollectionViewCellModel *> *dataSource; ///< 数据源

@end


@implementation CMSSingleImageScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.imageRatio = 120 / 375.0;
    self.cornerRadius = 10;
    [self.containerView addSubview:self.bannerView];
    [self.containerView addSubview:self.pageControl];
}
- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.containerView).offset(self.bannerView.isInfiniteLoop ? sideWidth : 0);
        make.right.equalTo(self.containerView);
        make.height.equalTo(self.containerView.mas_width).multipliedBy(self.imageRatio);
        make.top.equalTo(self.containerView).offset(0);
        make.bottom.equalTo(self.containerView);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-kRealWidth(12));
        make.height.mas_equalTo(kPageControlDotSize);
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    CGFloat availableWidth = self.config.maxLayoutWidth - self.config.contentEdgeInsets.left - self.config.contentEdgeInsets.right;

    height += availableWidth * self.imageRatio;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    SASingleImageCollectionViewCellModel *model = self.dataSource[index];
    model.placholderImage = [HDHelper placeholderImageWithCornerRadius:10 size:CGSizeMake(kScreenWidth, kScreenWidth * self.imageRatio) logoWidth:100];
    model.cornerRadius = self.cornerRadius;
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.config.nodes.count) {
        return;
    }
    SACMSNode *node = self.config.nodes[index];
    CMSImageItemConfig *itemConfig = [CMSImageItemConfig yy_modelWithJSON:node.getNodeContent];
    !self.clickNode ?: self.clickNode(self, node, itemConfig.link, [NSString stringWithFormat:@"node@%zd", index]);
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame) - 2 * cellMargin - (pageView.isInfiniteLoop ? 2 * sideWidth : 0);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = cellMargin;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - getters and setters
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    NSString *tintColor = config.getCardContent[@"tintColor"];
    if (HDIsStringNotEmpty(tintColor)) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor hd_colorWithHexString:tintColor];
    }

    NSArray<CMSImageItemConfig *> *items = [NSArray yy_modelArrayWithClass:CMSImageItemConfig.class json:self.config.getAllNodeContents];
    // 生成轮播数据源
    [self.dataSource removeAllObjects];
    for (CMSImageItemConfig *item in items) {
        SASingleImageCollectionViewCellModel *model = SASingleImageCollectionViewCellModel.new;
        model.url = item.imageUrl;
        [self.dataSource addObject:model];
    }
    self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];
    [self.bannerView setNeedClearLayout];
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 5.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(10, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

- (NSMutableArray<SASingleImageCollectionViewCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
