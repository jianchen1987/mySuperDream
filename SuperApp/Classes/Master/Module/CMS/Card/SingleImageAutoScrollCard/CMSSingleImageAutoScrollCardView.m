//
//  CMSSingleImageAutoScrollCardView.m
//  SuperApp
//
//  Created by seeu on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSSingleImageAutoScrollCardView.h"
#import "CMSImageItemConfig.h"
#import "SASingleImageCollectionViewCell.h"


@interface CMSSingleImageAutoScrollCardView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>

@property (nonatomic, strong) HDCyclePagerView *bannerView;                                       ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                         ///< pageControl
@property (nonatomic, strong) NSMutableArray<SASingleImageCollectionViewCellModel *> *dataSource; ///< 数据源

/// 图片比例 (高：宽)
@property (nonatomic, assign) CGFloat imageRatio;
/// 图片圆角
@property (nonatomic, assign) CGFloat cornerRadius;

@end


@implementation CMSSingleImageAutoScrollCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.bannerView];
    [self.containerView addSubview:self.pageControl];
}
- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
        make.height.equalTo(self.containerView.mas_width).multipliedBy(self.imageRatio);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-kRealHeight(6));
        make.height.mas_equalTo(kRealHeight(14));
        if (self.dataSource.count > 1) {
            make.width.mas_equalTo(self.dataSource.count * kRealWidth(8) + (self.dataSource.count - 1) * kRealHeight(4) + kRealHeight(8) + kRealWidth(8));
        } else {
            make.width.mas_equalTo(kRealWidth(16));
        }
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    CGFloat availableWidth = self.config.maxLayoutWidth - UIEdgeInsetsGetHorizontalValue(self.config.contentEdgeInsets);

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
    CGFloat availableWidth = self.config.maxLayoutWidth - UIEdgeInsetsGetHorizontalValue(self.config.contentEdgeInsets);
    model.placholderImage = [HDHelper placeholderImageWithCornerRadius:self.cornerRadius size:CGSizeMake(availableWidth, availableWidth * self.imageRatio) logoWidth:100];
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
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    NSNumber *cornerRadius = config.getCardContent[@"cornerRadius"];
    if (cornerRadius.floatValue > 0) {
        self.cornerRadius = cornerRadius.floatValue;
    }
    NSNumber *imageScale = config.getCardContent[@"imageScale"];
    if (imageScale.floatValue > 0) {
        self.imageRatio = imageScale.floatValue;
    } else {
        self.imageRatio = 120 / 375.0;
    }

    NSNumber *autoScrollInterval = config.getCardContent[@"autoScrollInterval"];
    self.bannerView.autoScrollInterval = autoScrollInterval.floatValue;

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
        _pageControl.currentPageIndicatorSize = CGSizeMake(kRealHeight(8), kRealHeight(8));
        _pageControl.pageIndicatorSize = CGSizeMake(kRealHeight(4), kRealHeight(4));
        _pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pageControl.hidesForSinglePage = true;
        _pageControl.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.7];
        _pageControl.pageIndicatorSpaing = kRealWidth(8);
        _pageControl.layer.cornerRadius = kRealHeight(7);
        _pageControl.layer.masksToBounds = YES;
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
