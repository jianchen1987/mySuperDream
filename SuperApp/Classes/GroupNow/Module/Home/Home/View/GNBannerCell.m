//
//  GNBannerCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNBannerCell.h"
#import "SAWindowModel.h"

#define cellMargin kRealWidth(10)
static CGFloat const kPageControlDotSize = 5;


@interface GNBannerCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
///  轮播图
@property (nonatomic, strong) HDCyclePagerView *bannerView; ///< 轮播图
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl; /// pageControl

@end


@implementation GNBannerCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.model.height);
        make.top.mas_equalTo(self.model.space);
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.bottom.mas_equalTo(0);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bannerView);
        make.centerX.equalTo(self.bannerView);
        make.bottom.equalTo(self.bannerView).offset(-kRealWidth(12));
        make.height.mas_equalTo(kPageControlDotSize);
    }];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bannerView.layer.cornerRadius = kRealHeight(12);
    self.bannerView.clipsToBounds = YES;
}

- (void)setGNModel:(GNTagViewCellModel *)data {
    self.model = data;
    self.pageControl.hidden = !(data.tagArr.count > 1);
    self.bannerView.hidden = !(data.tagArr.count > 0);
    self.pageControl.numberOfPages = data.tagArr.count;
    self.bannerView.isInfiniteLoop = (data.tagArr.count > 1);
    [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.model.height);
    }];
    [self.bannerView updateData];
    self.backgroundColor = UIColor.clearColor;
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.model.tagArr.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    GNBannerCollectionViewCell *cell = [GNBannerCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    cell.model = self.model.tagArr[index];
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (index >= self.model.tagArr.count)
        return;
    SAWindowItemModel *model = self.model.tagArr[index];
    if (![model isKindOfClass:SAWindowItemModel.class])
        return;
    SAWindowModel *windowModel = self.model.model;
    if (![windowModel isKindOfClass:SAWindowModel.class])
        return;
    if (HDIsStringNotEmpty(model.jumpLink)) {
        /// 埋点参数
        [SAWindowManager openUrl:model.jumpLink
                  withParameters:@{@"bannerId": model.detailId, @"bannerLocation": [NSNumber numberWithUnsignedInteger:windowModel.type], @"bannerTitle": model.bannerName}];

        [SATalkingData SATrackEvent:@"广告点击" label:@"" parameters:@{
            @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
            @"bannerId": model.detailId,
            @"bannerLocation": [NSNumber numberWithUnsignedInteger:windowModel.type],
            @"bannerTitle": model.bannerName,
            @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
            @"link": model.jumpLink,
            @"imageUrl": model.bannerUrl,
            @"businessLine": SAClientTypeGroupBuy
        }];
    }
    if (HDIsStringNotEmpty(self.model.title)) {
        [SATalkingData trackEvent:self.model.title label:@"" parameters:@{@"位置": [NSString stringWithFormat:@"%ld", index + 1]}];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = cellMargin;
    layout.itemSize = CGSizeMake(width, height);
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
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(10, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.gn_mainColor;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end


@interface GNBannerCollectionViewCell ()

///< 图片
@property (nonatomic, strong) SDAnimatedImageView *imageView;
///< 覆盖层
@property (nonatomic, strong) UIView *coverView;
///< 覆盖层标题
@property (nonatomic, strong) UILabel *coverTitle;

@end


@implementation GNBannerCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.coverView];
    [self.coverView addSubview:self.coverTitle];
    @HDWeakify(self);
    [self setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        [self.contentView setRoundedCorners:UIRectCornerAllCorners radius:kRealHeight(8)];
    }];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.coverTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
    }];
    [super updateConstraints];
}

- (void)setModel:(SAWindowItemModel *)model {
    _model = model;
    NSString *url = nil;
    if ([model isKindOfClass:SAWindowItemModel.class]) {
        url = model.bannerUrl;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(150), kRealHeight(100)) logoWidth:kRealWidth(32)]];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
