//
//  TNStoreRecommendWapperView.m
//  SuperApp
//
//  Created by 张杰 on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNStoreRecommendWapperView.h"
#import "SACollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNStoreRecommendProductView.h"


@interface TNRecommedProductGroupViewCell : SACollectionViewCell
/// 卖家sp
@property (nonatomic, copy) NSString *sp;
///
@property (strong, nonatomic) NSArray *dataSource;
/// 九宫格
@property (strong, nonatomic) HDGridView *productGridView;
@end


@implementation TNRecommedProductGroupViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.productGridView];
}
- (void)updateConstraints {
    [self.productGridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(182) + 5);
    }];
    [super updateConstraints];
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.productGridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < dataSource.count; i++) {
        TNStoreRecommendProductView *goodView = [[TNStoreRecommendProductView alloc] init];
        goodView.itemWidth = (kScreenWidth - kRealWidth(20)) / 3;
        goodView.sp = self.sp;
        goodView.model = dataSource[i];
        [self.productGridView addSubview:goodView];
    }
}
- (HDGridView *)productGridView {
    if (!_productGridView) {
        _productGridView = HDGridView.new;
        _productGridView.rowHeight = kRealWidth(182);
        _productGridView.columnCount = 3;
        _productGridView.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _productGridView.subViewHMargin = 5;
        _productGridView.subViewVMargin = 20;
    }
    return _productGridView;
}
@end
static CGFloat const kPageControlDotSize = 6;


@interface TNStoreRecommendWapperView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView; ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;   ///< pageControl
///  二维数组
@property (strong, nonatomic) NSArray *dataSource;
@end


@implementation TNStoreRecommendWapperView
- (void)hd_setupViews {
    [self addSubview:self.bannerView];
    [self addSubview:self.pageControl];
}
- (void)setGoodArr:(NSArray<TNGoodsModel *> *)goodArr {
    _goodArr = goodArr;
    self.dataSource = [goodArr hd_splitArrayWithEachCount:3];
    if (goodArr.count > 3) {
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];
    [self setNeedsUpdateConstraints];
}
- (void)setSp:(NSString *)sp {
    _sp = sp;
}
- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(182) + 8);
    }];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pageControl.isHidden) {
            make.width.centerX.equalTo(self.bannerView);
            make.height.mas_equalTo(kPageControlDotSize);
            make.top.equalTo(self.bannerView.mas_bottom).offset(3);
        }
    }];
    [super updateConstraints];
}
#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TNRecommedProductGroupViewCell *cell = [TNRecommedProductGroupViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSArray *singlePageDataSource = self.dataSource[index];
    cell.dataSource = singlePageDataSource;
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSize = CGSizeMake(width, height);
    return layout;
}

#pragma mark - HDCyclePagerViewDelegate
- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor whiteColor];
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.TinhNowColor.C1;
        _pageControl.pageIndicatorTintColor = HDAppTheme.TinhNowColor.cD6DBE8;
        _pageControl.hidesForSinglePage = true;
        _pageControl.pageIndicatorSpaing = 5;
    }
    return _pageControl;
}
@end
