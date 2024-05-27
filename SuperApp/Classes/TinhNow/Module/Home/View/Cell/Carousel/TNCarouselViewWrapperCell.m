//
//  TNCarouselViewWrapperCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCarouselViewWrapperCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SASingleImageCollectionViewCell.h"
#import "SAWindowManager.h"

static CGFloat const kPageControlDotSize = 6;

#define sideWidth 0
#define cellMargin kRealWidth(0)


@interface TNCarouselViewWrapperCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView;                                       ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                         ///< pageControl
@property (nonatomic, strong) NSMutableArray<SASingleImageCollectionViewCellModel *> *dataSource; ///< 数据源
@end


@implementation TNCarouselViewWrapperCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.pageControl];
}

- (void)updateBannerViewConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.height.mas_equalTo(self.model.cellHeight);
        make.top.equalTo(self.contentView.mas_top).offset(self.model.contentEdgeInsets.top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-self.model.contentEdgeInsets.bottom);
    }];
}
- (void)updateConstraints {
    [self updateBannerViewConstraints];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-kRealWidth(5) - self.model.contentEdgeInsets.bottom);
        make.height.mas_equalTo(kPageControlDotSize);
    }];
    [super updateConstraints];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    SASingleImageCollectionViewCellModel *model = self.dataSource[index];
    if (self.model.type == TNCarouselViewWrapperCellTypeActivity) {
        model.placholderImage = [HDHelper placeholderImageWithCornerRadius:10 size:CGSizeMake(kScreenWidth, kScreenWidth * 80 / 345.0) logoWidth:60];
    } else if (self.model.type == TNCarouselViewWrapperCellTypeAdvertisement) {
        model.placholderImage = [HDHelper placeholderImageWithCornerRadius:10 size:CGSizeMake(kScreenWidth, kScreenWidth * 150 / 375.0) logoWidth:100];
    }
    model.cornerRadius = 0;
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.model.list.count) {
        return;
    }
    SAWindowItemModel *model = self.model.list[index];
    if (HDIsStringNotEmpty(model.jumpLink)) {
        // 埋点用
        [SAWindowManager openUrl:model.jumpLink withParameters:@{@"funnel": @"[电商]首页_点击banner广告图"}];

        [SATalkingData SATrackEvent:@"广告点击" label:@"" parameters:@{
            @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
            @"bannerId": model.detailId,
            @"bannerLocation": [NSNumber numberWithUnsignedInteger:self.model.type],
            @"bannerTitle": model.bannerName,
            @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
            @"link": model.jumpLink,
            @"imageUrl": model.bannerUrl,
            @"businessLine": SAClientTypeTinhNow
        }];

        [SATalkingData trackEvent:@"[电商]首页_点击banner广告图" label:@"" parameters:@{@"排序": @(index), @"名称": model.bannerName, @"路由": model.jumpLink}];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;

    const CGFloat width = CGRectGetWidth(pageView.frame) - UIEdgeInsetsGetHorizontalValue(self.model.contentEdgeInsets) - (pageView.isInfiniteLoop ? 2 * sideWidth : 0);
    const CGFloat height = CGRectGetHeight(pageView.frame) - UIEdgeInsetsGetVerticalValue(self.model.contentEdgeInsets);
    layout.itemSpacing = UIEdgeInsetsGetHorizontalValue(self.model.contentEdgeInsets);
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = self.model.contentEdgeInsets;
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - getters and setters
- (void)setModel:(TNCarouselViewWrapperCellModel *)model {
    _model = model;

    // 生成轮播数据源
    [self.dataSource removeAllObjects];
    for (SAWindowItemModel *adModel in model.list) {
        SASingleImageCollectionViewCellModel *model = SASingleImageCollectionViewCellModel.new;
        model.url = adModel.bannerUrl;
        [self.dataSource addObject:model];
    }
    self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
    [self updateBannerViewConstraints];
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 5.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
        _bannerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(10, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.TinhNowColor.C1;
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
