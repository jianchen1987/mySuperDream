//
//  CMSTwoImageScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTwoImagePagedCardView.h"
#import "CMSTwoImagePagedCardCell.h"
#import "CMSTwoImagePagedCardCellConfig.h"
#import "CMSTwoImagePagedItemConfig.h"

static CGFloat const kPageControlDotSize = 6;

#define sideWidth 0
#define cellMargin kRealWidth(0)


@interface CMSTwoImagePagedCardView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>

@property (nonatomic, strong) HDCyclePagerView *bannerView;                                 ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                   ///< pageControl
@property (nonatomic, strong) NSMutableArray<CMSTwoImagePagedCardCellConfig *> *dataSource; ///< 数据源

@end


@implementation CMSTwoImagePagedCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.bannerView];
    [self.containerView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(kRealWidth(10));
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView).offset(-HDAppTheme.value.padding.right);
        CGFloat width = (kScreenWidth - UIEdgeInsetsGetVerticalValue(HDAppTheme.value.padding) - UIEdgeInsetsGetVerticalValue(self.config.getContentEdgeInsets) - kRealWidth(10)) / 2.0;
        make.height.mas_equalTo(width * (88.0 / 163.0) + kRealWidth(30));
        if (self.pageControl.isHidden) {
            make.bottom.equalTo(self.containerView).offset(-kRealWidth(10));
        }
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pageControl.isHidden) {
            make.width.equalTo(self.bannerView);
            make.centerX.equalTo(self.bannerView);
            make.top.equalTo(self.bannerView.mas_bottom).offset(kRealWidth(15));
            make.height.mas_equalTo(kPageControlDotSize);
            make.bottom.equalTo(self.containerView).offset(-kRealWidth(5));
        }
    }];

    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    CGFloat availableWidth
        = (self.config.maxLayoutWidth - UIEdgeInsetsGetVerticalValue(HDAppTheme.value.padding) - UIEdgeInsetsGetVerticalValue(self.config.getContentEdgeInsets) - kRealWidth(10)) / 2.0;
    height += (availableWidth * 88.0) / 163.0 + kRealWidth(30); // cell height
    height += kRealHeight(10);                                  // cell top marin
    if (!self.pageControl.isHidden) {
        height += kRealWidth(15) + kPageControlDotSize + kRealWidth(5);
    } else {
        height += kRealWidth(10);
    }
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
    CMSTwoImagePagedCardCell *cell = [CMSTwoImagePagedCardCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    cell.config = self.dataSource[index];
    @HDWeakify(self);
    cell.clickedBlock = ^(SACMSNode *_Nonnull node, NSString *_Nonnull link) {
        @HDStrongify(self);
        !self.clickNode ?: self.clickNode(self, node, link, [NSString stringWithFormat:@"node@%zd", index]);
    };
    return cell;
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
    NSArray<CMSTwoImagePagedItemConfig *> *items = [NSArray yy_modelArrayWithClass:CMSTwoImagePagedItemConfig.class json:self.config.getAllNodeContents];
    [items enumerateObjectsUsingBlock:^(CMSTwoImagePagedItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        SACMSNode *node = self.config.nodes[idx];
        obj.node = node;
    }];
    NSArray *temp = [items hd_splitArrayWithEachCount:2];
    // 生成轮播数据源
    [self.dataSource removeAllObjects];
    for (NSArray *list in temp) {
        CMSTwoImagePagedCardCellConfig *model = CMSTwoImagePagedCardCellConfig.new;
        model.left2RightScale = kRealWidth(10);
        model.list = list;
        [self.dataSource addObject:model];
    }

    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.hidden = self.dataSource.count <= 1;
    [self.bannerView reloadData];
    [self.bannerView setNeedClearLayout];
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.isInfiniteLoop = false;
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(10, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.mainColor;
        _pageControl.pageIndicatorTintColor = HDAppTheme.color.G4;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

- (NSMutableArray<CMSTwoImagePagedCardCellConfig *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
