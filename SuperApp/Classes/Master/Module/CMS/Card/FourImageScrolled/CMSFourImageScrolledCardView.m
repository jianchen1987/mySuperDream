//
//  CMSFourImageScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSFourImageScrolledCardView.h"
#import "CMSFourImageScrolledCardCell.h"
#import "CMSFourImageScrolledCardCellConfig.h"
#import "CMSFourImageScrolledItemConfig.h"

static CGFloat const kPageControlDotSize = 6;

#define sideWidth 0
#define cellMargin kRealWidth(0)


@interface CMSFourImageScrolledCardView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>

@property (nonatomic, strong) HDCyclePagerView *bannerView;                                     ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                       ///< pageControl
@property (nonatomic, strong) NSMutableArray<CMSFourImageScrolledCardCellConfig *> *dataSource; ///< 数据源

@property (nonatomic, strong) NSArray<CMSFourImageScrolledItemConfig *> *nodesConfig;

@end


@implementation CMSFourImageScrolledCardView

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
        make.bottom.equalTo(self.containerView).offset(kRealWidth(-10));
        if (self.nodesConfig.count > 2) {
            make.height.mas_equalTo(kRealHeight(110) * 2 + kRealHeight(10));
        } else {
            make.height.mas_equalTo(kRealHeight(110));
        }
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

    height += kRealWidth(20);
    if (self.nodesConfig.count > 0) {
        height += kRealHeight(110) * 2 + kRealHeight(10);
    } else {
        height += kRealHeight(110);
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
    CMSFourImageScrolledCardCell *cell = [CMSFourImageScrolledCardCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
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
    self.nodesConfig = [NSArray yy_modelArrayWithClass:CMSFourImageScrolledItemConfig.class json:self.config.getAllNodeContents];
    [self.nodesConfig enumerateObjectsUsingBlock:^(CMSFourImageScrolledItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        SACMSNode *node = self.config.nodes[idx];
        obj.node = node;
    }];
    NSArray<NSArray *> *temp = [self.nodesConfig hd_splitArrayWithEachCount:4];

    // 生成轮播数据源
    [self.dataSource removeAllObjects];
    for (int i = 0; i < temp.count; i++) {
        NSArray<CMSFourImageScrolledItemConfig *> *list = temp[i];
        CMSFourImageScrolledCardCellConfig *model = CMSFourImageScrolledCardCellConfig.new;
        model.list = list;
        [self.dataSource addObject:model];
    }

    //    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.hidden = YES;
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
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

- (NSMutableArray<CMSFourImageScrolledCardCellConfig *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
