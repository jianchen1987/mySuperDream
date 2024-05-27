//
//  WMCMSBannerAutoScrollDataSourceCardView.m
//  SuperApp
//
//  Created by Tia on 2023/11/29.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCMSBannerAutoScrollDataSourceCardView.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"
#import "WMCyclePagerView.h"
#import "WMAdadvertisingModel.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"
#import "WMCyclePagerView.h"

#define kCollectionViewHeight ((kScreenWidth - 12 * 2) * 90 / 350.0)


@interface WMCMSBannerAutoScrollDataSourceCardViewCell : SACollectionViewCell
///图片
@property (nonatomic, strong) SDAnimatedImageView *imageView;

@property (nonatomic, strong) WMAdadvertisingModel *model;

@end


@implementation WMCMSBannerAutoScrollDataSourceCardViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (void)setModel:(WMAdadvertisingModel *)model {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.images]
                      placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(350 / 375.0 * kScreenWidth, 90.0 * kScreenWidth / 375.0)]];
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.clipsToBounds = YES;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
        };
        _imageView.backgroundColor = UIColor.redColor;
    }
    return _imageView;
}

@end


@interface WMCMSBannerAutoScrollDataSourceCardView () <HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>

@property (nonatomic, strong) WMCyclePagerView *collectionView;
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;

@property (nonatomic, copy) NSArray<WMAdadvertisingModel *> *dataSource; ///< 数据源

@end


@implementation WMCMSBannerAutoScrollDataSourceCardView

#pragma mark - Overwirite
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    if (HDIsStringNotEmpty(dataSource)) {
        return YES;
    }
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    return dataSource;
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    NSMutableDictionary *req = NSMutableDictionary.new;
    NSDictionary *superParameters = [super setupRequestParamtersWithDataSource:dataSource cardConfig:config];
    [req addEntriesFromDictionary:superParameters];
    if (config.addressModel) {
        [req addEntriesFromDictionary:@{@"geo": @{@"lat": config.addressModel.lat.stringValue, @"lon": config.addressModel.lon.stringValue}}];
    }
    req[@"space"] = WMHomeCarouselAdviseType;
    req[@"cardId"] = config.cardNo;
    return req;
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [super parsingDataSourceResponse:responseData withCardConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:WMAdadvertisingModel.class json:responseData[@"data"]];


    self.pageControl.hidden = !(self.dataSource.count > 1);
    self.pageControl.numberOfPages = self.dataSource.count;
    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    self.collectionView.isInfiniteLoop = self.dataSource.count > 1;
    [self.collectionView reloadData];
}


- (void)hd_setupViews {
    [super hd_setupViews];
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView).insets( UIEdgeInsetsMake(0, HDAppTheme.value.padding.left, 0, HDAppTheme.value.padding.right));
        make.height.mas_equalTo(kCollectionViewHeight);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionView.mas_right).offset(-kRealWidth(3));
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(-kRealWidth(8));
        make.width.mas_equalTo(MIN(kScreenWidth - kRealWidth(25), kRealWidth(12) * 10));
        make.height.mas_equalTo(kRealWidth(6));
    }];

    [super updateConstraints];
}


#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    if (self.dataSource.count <= 0)return 0;
    CGFloat height = 0;
    height += kCollectionViewHeight;
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
    //    Class class = [self cardClass];
    WMCMSBannerAutoScrollDataSourceCardViewCell *cell = [WMCMSBannerAutoScrollDataSourceCardViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    if (self.dataSource.count > index) {
        cell.model = self.dataSource[index];
    }
    //    [cell hd_endSkeletonAnimation];
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.dataSource.count) return;
    WMAdadvertisingModel *model = self.dataSource[index];
    NSString *link = model.link;
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:nil];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth - 12 * 2, (kScreenWidth - 12 * 2) * 90 / 350.0);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    self.dataSource = [NSArray yy_modelArrayWithClass:WMAdadvertisingModel.class json:config.getAllNodeContents];
    self.pageControl.hidden = !(self.dataSource.count > 1);
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.collectionView reloadData];
}

#pragma mark - lazy
- (WMCyclePagerView *)collectionView {
    if (!_collectionView) {
        WMCyclePagerView *bannerView = WMCyclePagerView.new;
        bannerView.autoScrollInterval = 5.0;
        bannerView.dataSource = self;
        bannerView.delegate = self;
        bannerView.distance = 0;
        bannerView.layer.cornerRadius = kRealWidth(8);
        bannerView.layer.masksToBounds = YES;
        _collectionView = bannerView;
    }
    return _collectionView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kRealWidth(6), kRealWidth(6));
        _pageControl.pageIndicatorSize = CGSizeMake(kRealWidth(6), kRealWidth(6));
        _pageControl.pageIndicatorSpaing = kRealWidth(6);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.WMColor.mainRed;
        _pageControl.pageIndicatorTintColor = [UIColor hd_colorWithHexString:@"000000"];
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end
