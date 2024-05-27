//
//  TNActivityCardMultipleBannersCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardMultipleBannersCell.h"
#import "SASingleImageCollectionViewCell.h"
#import "TNActivityCardItemView.h"
static CGFloat const kPageControlDotSize = 6;


@interface TNActivityCardMultipleBannersCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView;                                       ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;                                         ///< pageControl
@property (nonatomic, strong) NSMutableArray<SASingleImageCollectionViewCellModel *> *dataSource; ///< 数据源
@end


@implementation TNActivityCardMultipleBannersCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.baseView addSubview:self.bannerView];
    [self.baseView addSubview:self.pageControl];
}
- (void)setCardModel:(TNActivityCardModel *)cardModel {
    [super setCardModel:cardModel];
    [self.dataSource removeAllObjects];
    for (TNActivityCardBannerItem *item in cardModel.bannerList) {
        SASingleImageCollectionViewCellModel *model = SASingleImageCollectionViewCellModel.new;
        model.url = item.bannerUrl;
        model.placholderImage = [HDHelper placeholderImageWithCornerRadius:4 size:CGSizeMake(kScreenWidth - kRealWidth(40), cardModel.imageViewHeight) logoWidth:100];
        [self.dataSource addObject:model];
    }
    [self setNeedsUpdateConstraints];
    self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(self.cardModel.imageViewHeight);
        make.left.equalTo(self.baseView.mas_left).offset(self.cardModel.isSpecialStyleVertical ? 0 : kRealWidth(10));
        make.right.equalTo(self.baseView.mas_right).offset(self.cardModel.isSpecialStyleVertical ? 0 : -kRealWidth(10));
    }];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView.mas_bottom).offset(-kRealWidth(10));
        make.height.mas_equalTo(kPageControlDotSize);
    }];
}
#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    SASingleImageCollectionViewCellModel *model = self.dataSource[index];
    model.cornerRadius = 4;
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.cardModel.bannerList.count) {
        return;
    }
    TNActivityCardBannerItem *item = self.cardModel.bannerList[index];
    if (HDIsStringNotEmpty(item.jumpLink)) {
        [SAWindowManager openUrl:item.jumpLink withParameters:@{@"funnel": self.cardModel.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @""}];
    }
    NSString *eventName = self.cardModel.scene == TNActivityCardSceneIndex ? @"[电商]首页_点击广告位" : @"[电商]普通专题广告位";
    [SATalkingData trackEvent:eventName label:@"" parameters:@{@"排序": @(index), @"名称": item.title, @"路由": item.jumpLink, @"类型": @"走马灯"}];
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;

    const CGFloat width = self.cardModel.isSpecialStyleVertical ? kScreenWidth - kRealWidth(75) - kRealWidth(10) : kScreenWidth - kRealWidth(40);
    const CGFloat height = self.cardModel.isSpecialStyleVertical ? kRealWidth(118) : kRealWidth(138);
    layout.itemSpacing = kRealWidth(10);
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
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
