//
//  WMCardTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"


@implementation WMCardTableViewCell
@synthesize bgView = _bgView;
@synthesize collectionView = _collectionView;
@synthesize dataSource = _dataSource;
@synthesize flowLayout = _flowLayout;
@synthesize sliderView = _sliderView;
@synthesize provider = _provider;

- (void)hd_setupViews {
    if (self.cardUseBanner) {
        WMCyclePagerView *bannerView = WMCyclePagerView.new;
        bannerView.autoScrollInterval = self.cardCycleDurtion;
        bannerView.dataSource = self;
        bannerView.delegate = self;
        bannerView.distance = self.bannerDistance;
        bannerView.layer.cornerRadius = kRealWidth(8);
        bannerView.layer.masksToBounds = YES;
        self.collectionView = bannerView;
    } else {
        WMHomeCollectionView *collectionView = [[WMHomeCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        self.collectionView = collectionView;
    }
    self.flowLayout.itemSize = self.cardItemSize;
    self.flowLayout.minimumLineSpacing = self.cardSpace;
    self.flowLayout.minimumInteritemSpacing = self.lineCardSpace;

    self.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithCellReuseIdentifier:NSStringFromClass(self.cardClass)];
    self.provider.numberOfRowsInSection = 10;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    [self.contentView addSubview:self.sliderView];

    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
}

- (void)hd_bindViewModel {
    if (!self.cardUseBanner) {
        WMHomeCollectionView *collectionView = (WMHomeCollectionView *)self.collectionView;
        [collectionView registerClass:self.cardClass forCellWithReuseIdentifier:NSStringFromClass(self.cardClass)];
        collectionView.delegate = self.provider;
        collectionView.dataSource = self.provider;
    }
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.layoutModel.layoutConfig.outSets.left);
        make.right.mas_equalTo(-self.layoutModel.layoutConfig.outSets.right);
        make.top.mas_equalTo(self.layoutModel.layoutConfig.outSets.top);
        make.bottom.mas_equalTo(-self.layoutModel.layoutConfig.outSets.bottom);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.cardHeight).priorityHigh();
        make.right.mas_equalTo(-self.layoutModel.layoutConfig.inSets.right);
        make.left.mas_equalTo(self.layoutModel.layoutConfig.inSets.left);
        make.top.mas_equalTo(self.layoutModel.layoutConfig.inSets.top);
        make.bottom.mas_equalTo(-self.layoutModel.layoutConfig.inSets.bottom);
    }];

    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sliderView.isHidden) {
            make.width.mas_equalTo(kRealWidth(50));
            make.height.mas_offset(kRealWidth(3));
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.collectionView.mas_bottom);
        }
    }];
    [self.sliderView layoutIfNeeded];
    [super updateConstraints];
}

- (void)setLayoutModel:(WMHomeLayoutModel *)layoutModel {
    BOOL diff = (_layoutModel != layoutModel);
    _layoutModel = layoutModel;
    if (diff) {
        if (self.cardUseBanner) {
            HDCyclePagerView *bannerView = (HDCyclePagerView *)self.collectionView;
            bannerView.isInfiniteLoop = self.cardCycle;
            [bannerView reloadData];
        } else {
            WMHomeCollectionView *collectionView = (WMHomeCollectionView *)self.collectionView;
            collectionView.contentInset = layoutModel.layoutConfig.contenInset;
            [collectionView setContentOffset:CGPointMake(-collectionView.contentInset.left, 0) animated:NO];
            [collectionView updateUI];
        }
        [self setNeedsUpdateConstraints];
    } else {
        if (self.cardUseBanner) {
            HDCyclePagerView *bannerView = (HDCyclePagerView *)self.collectionView;
            [bannerView updateData];
        } else {
            WMHomeCollectionView *collectionView = (WMHomeCollectionView *)self.collectionView;
            [collectionView updateUI];
        }
    }
}

- (void)setGNModel:(id)data {
    if (!self.cardUseBanner) {
        WMHomeCollectionView *collectionView = (WMHomeCollectionView *)self.collectionView;
        if (self.dataSource.count > 0 && collectionView.delegate != self) {
            collectionView.delegate = self;
            collectionView.dataSource = self;
        }
    }
    self.sliderView.hidden = !self.cardUseSlider ? YES : (self.dataSource.count < self.cardSliderCount);
    self.sliderView.offset = self.sliderView.offset;
}

- (void)openLink:(NSString *)link dic:(nullable NSDictionary *)dic {
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:dic];
    }
}

#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Class class = [self cardClass];
    SACollectionViewCell *cell = [class cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(class)];
    if (self.dataSource.count > indexPath.row) {
        [cell setGNModel:self.dataSource[indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(cardItemSizeWithIndexPath:)]) {
        return [self cardItemSizeWithIndexPath:indexPath];
    }
    return self.cardItemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.cardSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineCardSpace;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    [self cellWillDisplayWithCollection:collectionView indexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.sliderView isHidden] && scrollView.contentSize.width > scrollView.frame.size.width) {
        self.sliderView.offset = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(card:itemClick:)]) {
        [self card:collectionView itemClick:indexPath];
    }
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    Class class = [self cardClass];
    SACollectionViewCell *cell = [class cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    if (self.dataSource.count > index) {
        [cell setGNModel:self.dataSource[index]];
    }
    [cell hd_endSkeletonAnimation];
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.dataSource.count)
        return;
    if ([self respondsToSelector:@selector(card:itemClick:)]) {
        [self card:pageView.collectionView itemClick:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    layout.itemSpacing = self.cardSpace;
    layout.itemSize = self.cardItemSize;
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
}

#pragma mark CardCellProtocol
- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
}

- (CGSize)cardItemSize {
    return CGSizeMake(kRealWidth(150), kRealWidth(150));
}

- (CGFloat)cardSpace {
    return kRealWidth(12);
}

- (CGFloat)lineCardSpace {
    return 0;
}

- (Class)cardClass {
    return UICollectionViewCell.class;
}

- (BOOL)cardHDLayout {
    return NO;
}

- (CGFloat)cardHeight {
    return self.cardItemSize.height;
}

- (BOOL)cardUseSlider {
    return NO;
}

- (NSInteger)cardSliderCount {
    return 3;
}

- (BOOL)cardCycle {
    return self.dataSource.count > 1;
}

- (CGFloat)cardCycleDurtion {
    return 5.0;
}

- (BOOL)cardUseBanner {
    return NO;
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
}

- (void)cardMoreClickAction {
}

- (void)cardDidScroll:(nonnull UIScrollView *)scrollView {
}

- (CGFloat)bannerDistance {
    return 0;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (WMIndicatorSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = WMIndicatorSliderView.new;
        _sliderView.layer.backgroundColor = HDAppTheme.WMColor.F1F1F1.CGColor;
        _sliderView.layer.cornerRadius = kRealWidth(3.5);
        _sliderView.hidden = YES;
    }
    return _sliderView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

@end


@implementation WMItemCardCell

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    CGFloat itemWidth = 140 / 375.0 * kScreenWidth;
    CGFloat contentH = kRealWidth(53);
    return itemWidth + contentH;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat itemWidth = 140 / 375.0 * kScreenWidth;
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(itemWidth);
        make.height.hd_equalTo(itemWidth);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(90);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    return @[r0, r1, r2];
}

@end
